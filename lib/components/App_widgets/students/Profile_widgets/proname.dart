import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Proname extends StatefulWidget {
  const Proname({super.key});

  @override
  State<Proname> createState() => _PronameState();
}

class _PronameState extends State<Proname> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? originalPhone = user.phoneNumber;
      print("📱 FirebaseAuth phone: $originalPhone");

      String normalizedPhone = originalPhone ?? "";
      if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
        normalizedPhone = '+91$normalizedPhone';
      }

      print("🔍 Searching for: $normalizedPhone");

      try {
        final firestore = FirebaseFirestore.instance;

        // ✅ Collage doc
        final collageDoc =
            await firestore
                .collection('Collages')
                .doc('Thakur Shyamnarayan Degree Collage')
                .get();

        String collageName = collageDoc.data()?['Collage'] ?? 'Unknown Collage';
        String collageId = collageDoc.id; // <-- Document name (ID)

        // ✅ Start walking through departments
        final collegeRef = firestore
            .collection('Collages')
            .doc(collageId)
            .collection('students');

        final deptSnapshot = await collegeRef.get();

        for (var deptDoc in deptSnapshot.docs) {
          final deptName = deptDoc.id; // e.g., Bscit, Baf, etc.
          final divisionRef = collegeRef.doc(deptName).collection('Devision');

          final batchSnapshot = await divisionRef.get();
          for (var batchDoc in batchSnapshot.docs) {
            final batchName = batchDoc.id; // e.g., Batch-A, Batch-B, etc.
            final studentIdRef = divisionRef
                .doc(batchName)
                .collection('student-id');

            final studentsSnapshot = await studentIdRef.get();

            for (var studentDoc in studentsSnapshot.docs) {
              final data = studentDoc.data();
              final studentId = studentDoc.id;

              print("👤 Checking Student: $studentId => ${data['Contact']}");

              if (data['Contact'] == normalizedPhone) {
                setState(() {
                  studentData = {
                    ...data,
                    "Collage": collageName,
                    "CollageID": collageId,
                    "Department": deptName,
                    "Division": batchName,
                    "StudentID": studentId,
                  };
                  isLoading = false;
                });

                print("✅ Found student: ${data['Name']}");
                return;
              }
            }
          }
        }

        print("❌ No student found for: $normalizedPhone");
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print("🔥 Firestore query error: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("❗User not logged in.");
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

    if (studentData == null) {
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
                  "Name: ${studentData?["Name"]}",
                  style: TextStyle(
                    fontSize: _calculateFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${studentData?["Collage"]}",
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
