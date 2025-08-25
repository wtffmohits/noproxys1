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

    if (user == null) {
      print("❗User not logged in.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    String? originalPhone = user.phoneNumber;
    print("📱 FirebaseAuth phone: $originalPhone");

    if (originalPhone == null || originalPhone.isEmpty) {
      print("❗Phone number is null or empty.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Normalize phone number: prefix +91 if only 10 digits
    String normalizedPhone = originalPhone;
    if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
      normalizedPhone = '+91$normalizedPhone';
    }

    print("🔍 Searching for contact: $normalizedPhone"); // Should match screenshot

    try {
      final firestore = FirebaseFirestore.instance;

      // Search all 'student-id' subcollections, on lowercase 'contact' field
      final studentQuerySnapshot = await firestore
          .collectionGroup('student-id')
          .where('contact', isEqualTo: normalizedPhone)
          .limit(1)
          .get();

      if (studentQuerySnapshot.docs.isEmpty) {
        print("❌ No student found with contact: $normalizedPhone");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final studentDoc = studentQuerySnapshot.docs.first;
      final studentDataMap = studentDoc.data();
      print("✅ Student found: ${studentDataMap['name']}");

      // Get parent info (Collage, Department, Batch)
      DocumentReference batchRef = studentDoc.reference.parent.parent!;
      DocumentReference deptRef = batchRef.parent.parent!;
      DocumentReference collageRef = deptRef.parent.parent!;

      final collageDoc = await collageRef.get();
      final collageData = collageDoc.data() as Map<String, dynamic>?;

      setState(() {
        studentData = {
          ...studentDataMap,
          "Collage": collageData?['Collage'] ?? collageRef.id,
          "CollageID": collageRef.id,
          "Department": deptRef.id,
          "Division": batchRef.id,
          "StudentID": studentDoc.id,
        };
        isLoading = false;
      });
    } catch (e) {
      print("🔥 Firestore query error: $e");
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
      return const Center(child: Text("Student data not found."));
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: _calculateAvatarRadius(context),
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, size: 40), // Fallback icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${studentData?["name"] ?? 'N/A'}", // field is lowercase
                  style: TextStyle(
                    fontSize: _calculateFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${studentData?["Collage"] ?? 'Unknown College'}",
                  style: TextStyle(
                    fontSize: _calculateFontSize(context, 16),
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
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
    return (screenWidth * 0.1).clamp(30.0, 50.0);
  }

  double _calculateFontSize(BuildContext context, double baseFontSize) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return baseFontSize;
    } else if (screenWidth > 400) {
      return baseFontSize * 0.9;
    } else {
      return baseFontSize * 0.8;
    }
  }
}
