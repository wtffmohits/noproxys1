import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pronamet extends StatefulWidget {
  const Pronamet({super.key});

  @override
  State<Pronamet> createState() => _PronameState();
}

class _PronameState extends State<Pronamet> {
  Map<String, dynamic>? staffData; // Correct variable name
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStaffData();
  }

  Future<void> fetchStaffData() async {
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

    // Normalize phone number to include +91 if missing
    String normalizedPhone = originalPhone;
    if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
      normalizedPhone = '+91$normalizedPhone';
    }

    print("🔍 Searching for staff contact: $normalizedPhone");

    try {
      final firestore = FirebaseFirestore.instance;

      // Collection group query on 'staff-id' collection filtering by Contact field
      final staffQuerySnapshot =
          await firestore
              .collectionGroup('staff-id')
              .where('Contact', isEqualTo: normalizedPhone)
              .limit(1) // Assume unique phone number
              .get();

      if (staffQuerySnapshot.docs.isEmpty) {
        print("❌ No staff found with contact: $normalizedPhone");
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Staff document found
      final staffDoc = staffQuerySnapshot.docs.first;
      final staffDataMap = staffDoc.data();
      print("✅ Staff found: ${staffDataMap['Name']}");

      // Get the hierarchy: Collages/{collageId}/Departments/{departmentId}/Staff/{designation}/staff-id/{staffId}
      DocumentReference staffIdRef = staffDoc.reference;
      DocumentReference designationRef =
          staffIdRef.parent.parent!; // Staff/{designation}
      DocumentReference departmentRef =
          designationRef.parent.parent!; // Departments/{departmentId}
      DocumentReference collageRef =
          departmentRef.parent.parent!; // Collages/{collageId}

      // Fetch college document data for its name if available
      final collageDoc = await collageRef.get();
      final collageData = collageDoc.data() as Map<String, dynamic>?;

      setState(() {
        staffData = {
          ...staffDataMap,
          "Collage": collageData?['Collage'] ?? collageRef.id,
          "CollageID": collageRef.id,
          "Department": departmentRef.id,
          "Designation": designationRef.id,
          "StaffID": staffDoc.id,
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

    if (staffData == null) {
      return const Center(child: Text("Teacher data not found."));
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
            // backgroundImage: staffData?["photoUrl"] != null ? NetworkImage(staffData!["photoUrl"]) : null, // Uncomment if photo available
            child: const Icon(Icons.person, size: 40), // Fallback icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${staffData?["Name"] ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: _calculateFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${staffData?["Collage"] ?? 'Unknown College'}",
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
