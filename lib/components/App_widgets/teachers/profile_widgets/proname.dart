import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pronamet extends StatefulWidget {
  const Pronamet({super.key});

  @override
  State<Pronamet> createState() => _PronameState();
}

class _PronameState extends State<Pronamet> {
  Map<String, dynamic>? teacherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
  }

  Future<void> fetchTeacherData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? originalPhone = user.phoneNumber;
      print("📱 FirebaseAuth phone: $originalPhone");

      String normalizedPhone = originalPhone ?? "";
      if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
        normalizedPhone = '+91$normalizedPhone';
      }

      print("🔍 Searching teacher in all colleges for: $normalizedPhone");

      try {
        final firestore = FirebaseFirestore.instance;

        // Get all colleges
        final collegesSnapshot = await firestore.collection('Collages').get();

        for (var collegeDoc in collegesSnapshot.docs) {
          final collegeName = collegeDoc.id;
          print("🏫 Checking College: $collegeName");

          final teachersRootRef = firestore
              .collection('Collages')
              .doc(collegeName)
              .collection('teachers');

          final designationSnapshot = await teachersRootRef.get();

          for (var designationDoc in designationSnapshot.docs) {
            final designation = designationDoc.id;
            print("🧑‍🏫 Checking Designation: $designation");

            final teacherIdRef = teachersRootRef
                .doc(designation)
                .collection('teacher-id');

            final teacherSnapshot = await teacherIdRef.get();

            for (var teacherDoc in teacherSnapshot.docs) {
              final data = teacherDoc.data();
              final teacherId = teacherDoc.id;

              print(
                "👨‍🏫 Checking Teacher ID: $teacherId => ${data['Contact']}",
              );

              if (data['Contact'] == normalizedPhone) {
                setState(() {
                  teacherData = {
                    ...data,
                    "Designation": designation,
                    "TeacherID": teacherId,
                    "College": collegeName,
                  };
                  isLoading = false;
                });

                print("✅ Found Teacher: ${data['Name']}");
                return;
              }
            }
          }
        }

        print("❌ No teacher found for: $normalizedPhone");
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print("🔥 Firestore error: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("❗ User not logged in.");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (teacherData == null) {
      return const Center(child: Text("No data found"));
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: _calculateAvatarRadius(context),
            backgroundImage: const AssetImage("assets/images/mohits.jpeg"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${teacherData?["Name"]}",
                  style: TextStyle(
                    fontSize: _calculateFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${teacherData?["College"]}",
                  style: TextStyle(
                    fontSize: _calculateFontSize(context, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAvatarRadius(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * 0.1;
  }

  double _calculateFontSize(BuildContext context, double baseFontSize) {
    final double screenRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    return screenRatio > 1.2 ? baseFontSize : baseFontSize * 0.8;
  }
}
