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

  // This function has been updated for efficiency.
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

    // Normalize the phone number to ensure it has the +91 prefix.
    String normalizedPhone = originalPhone;
    if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
      normalizedPhone = '+91$normalizedPhone';
    }

    print("🔍 Searching for contact: $normalizedPhone");

    try {
      final firestore = FirebaseFirestore.instance;

      // Use a Collection Group query to efficiently search across all 'student-id' subcollections.
      // This is much faster than iterating through each college, department, and division.
      final studentQuerySnapshot =
          await firestore
              .collectionGroup(
                'student-id',
              ) // IMPORTANT: Searches all collections named 'student-id'
              .where('Contact', isEqualTo: normalizedPhone)
              .limit(
                1,
              ) // We only need one result, assuming contact numbers are unique.
              .get();

      if (studentQuerySnapshot.docs.isEmpty) {
        print("❌ No student found with contact: $normalizedPhone");
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Student found, now get the document and its data.
      final studentDoc = studentQuerySnapshot.docs.first;
      final studentDataMap = studentDoc.data();
      print("✅ Student found: ${studentDataMap['Name']}");

      // Now, we get the parent documents to retrieve College, Department, and Division info.
      // The path is: Collages/{collageId}/students/{deptId}/Devision/{batchId}/student-id/{studentId}
      DocumentReference batchRef = studentDoc.reference.parent.parent!;
      DocumentReference deptRef = batchRef.parent.parent!;
      DocumentReference collageRef = deptRef.parent.parent!;

      // Fetch the collage document to get its name from the 'Collage' field.
      final collageDoc = await collageRef.get();
      final collageData = collageDoc.data() as Map<String, dynamic>?;

      setState(() {
        studentData = {
          ...studentDataMap,
          "Collage":
              collageData?['Collage'] ??
              collageRef.id, // Use field value or the ID as a fallback
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
            // Make sure you have this image in your assets folder
            // and have declared it in pubspec.yaml
            backgroundImage: const AssetImage(""),
            onBackgroundImageError: (exception, stackTrace) {
              print('Error loading image: $exception');
            },
            child: const Icon(Icons.person, size: 40), // Fallback icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${studentData?["Name"] ?? 'N/A'}",
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
    // Set a max radius to avoid it being too large on wide screens
    return (screenWidth * 0.1).clamp(30.0, 50.0);
  }

  double _calculateFontSize(BuildContext context, double baseFontSize) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Adjust font size based on screen width
    if (screenWidth > 600) {
      return baseFontSize;
    } else if (screenWidth > 400) {
      return baseFontSize * 0.9;
    } else {
      return baseFontSize * 0.8;
    }
  }
}
