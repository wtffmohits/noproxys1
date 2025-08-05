import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherProfileEditPage extends StatefulWidget {
  const TeacherProfileEditPage({super.key});

  @override
  _TeacherProfileEditPageState createState() => _TeacherProfileEditPageState();
}

class _TeacherProfileEditPageState extends State<TeacherProfileEditPage> {
  Map? teacherData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
  }

  Future<void> fetchTeacherData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❗ User not logged in.");
      setState(() {
        isLoading = false;
        errorMessage = "You are not logged in.";
      });
      return;
    }

    String? originalPhone = user.phoneNumber;
    if (originalPhone == null || originalPhone.isEmpty) {
      print("❗ Phone number is null or empty.");
      setState(() {
        isLoading = false;
        errorMessage = "Phone number not available.";
      });
      return;
    }

    String normalizedPhone = originalPhone;
    if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
      normalizedPhone = '+91$normalizedPhone';
    }

    print("🔍 Searching for teacher contact: $normalizedPhone");
    try {
      final firestore = FirebaseFirestore.instance;

      final teacherQuerySnapshot =
          await firestore
              .collectionGroup('staff-id')
              .where('Contact', isEqualTo: normalizedPhone)
              .limit(1)
              .get();

      if (teacherQuerySnapshot.docs.isEmpty) {
        print("❌ No teacher found with contact: $normalizedPhone");
        setState(() {
          isLoading = false;
          errorMessage =
              "Teacher data could not be found for your contact number.";
        });
        return;
      }

      final teacherDoc = teacherQuerySnapshot.docs.first;
      final teacherDataMap = teacherDoc.data();
      print("✅ Teacher found: ${teacherDataMap['Name']}");

      // Traverse up the document tree to get parent information
      DocumentReference designationRef = teacherDoc.reference.parent.parent!;
      DocumentReference departmentRef = designationRef.parent.parent!;
      DocumentReference collageRef = departmentRef.parent.parent!;
      final collageDoc = await collageRef.get();
      final collageData = collageDoc.data() as Map?;

      setState(() {
        teacherData = {
          ...teacherDataMap,
          "Collage": collageData?['Collage'] ?? collageRef.id,
          "CollageID": collageRef.id,
          "Department": departmentRef.id,
          "Designation": designationRef.id,
          "StaffID": teacherDoc.id,
        };
        isLoading = false;
      });
    } catch (e) {
      print("🔥 Firestore query error: $e");
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred while fetching teacher data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Edit Teacher Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }
    if (teacherData == null) {
      return const Center(child: Text("No data found."));
    }

    return Stack(
      children: [
        // Blue header background
        Container(height: 120, color: Colors.blue),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 60,
              left: 16,
              right: 16,
              bottom: 30,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                      'assets/images/teacher_avatar.png',
                    ), // change if you want different image
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildTextField("Full Name", teacherData?["Name"]),
                      buildTextField("Email", teacherData?["email"]),
                      buildTextField("Contact", teacherData?["Contact"]),
                      const SizedBox(height: 20),
                      _buildCollegeChip(),
                      const Divider(height: 30),
                      _buildHeaderSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String labelText, String? placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: placeholder ?? 'N/A'),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildCollegeChip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.school, color: Colors.blue.shade800, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              teacherData?["Collage"] ?? "Not Available",
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Professional Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildDetailRow('Department', teacherData?["Department"]),
        _buildDetailRow('Designation', teacherData?["Designation"]),
        // Aap yahan aur fields add kar sakte hain, jaise Subjects, StaffID, ya koi aur custom info
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          Text(value ?? 'N/A', style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
