import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
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
      setState(() => isLoading = false);
      return;
    }

    String? phone = user.phoneNumber ?? "";
    if (!phone.startsWith('+91') && phone.length == 10) {
      phone = '+91$phone';
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final collageDoc =
          await firestore
              .collection('Collages')
              .doc('Thakur Shyamnarayan Degree Collage')
              .get();

      String collageName = collageDoc.data()?['Collage'] ?? 'Unknown Collage';
      String collageId = collageDoc.id;

      final collegeRef = firestore
          .collection('Collages')
          .doc(collageId)
          .collection('students');

      final deptSnapshot = await collegeRef.get();

      for (var deptDoc in deptSnapshot.docs) {
        final deptName = deptDoc.id;
        final divisionRef = collegeRef.doc(deptName).collection('Devision');
        final batchSnapshot = await divisionRef.get();

        for (var batchDoc in batchSnapshot.docs) {
          final batchName = batchDoc.id;
          final studentIdRef = divisionRef
              .doc(batchName)
              .collection('student-id');

          final studentsSnapshot = await studentIdRef.get();

          for (var studentDoc in studentsSnapshot.docs) {
            final data = studentDoc.data();
            final studentId = studentDoc.id;

            if (data['Contact'] == phone) {
              setState(() {
                studentData = {
                  ...data,
                  "Collage": collageName,
                  "CollageID": collageId,
                  "Department": deptName,
                  "Devision": batchName,
                  "StudentID": studentId,
                };
                isLoading = false;
              });
              return;
            }
          }
        }
      }

      setState(() => isLoading = false);
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : studentData == null
              ? const Center(child: Text("No data found."))
              : Stack(
                children: [
                  Container(height: 200, color: Colors.blue),
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(25, 160, 25, 30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(
                                'assets/images/mohits.jpeg',
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildTextField(
                              "Full Name",
                              studentData?["Name"] ?? "N/A",
                            ),
                            buildTextField(
                              "Email",
                              studentData?["email"] ?? "N/A",
                            ),
                            buildTextField(
                              "Contact",
                              studentData?["Contact"] ?? "N/A",
                            ),
                            const SizedBox(height: 20),
                            _buildCollegeChip(),
                            const SizedBox(height: 20),
                            _buildHeaderSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Save logic here
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text("Save", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildCollegeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Text(
            "College: ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              studentData?["Collage"] ?? "Not Available",
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
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
        _buildDetailRow('Course', studentData?["Department"] ?? "N/A"),
        _buildDetailRow('Roll No.', studentData?["Roll-no"] ?? "N/A"),
        _buildDetailRow('Year', studentData?["Year"] ?? "N/A"),
        _buildDetailRow('Semester', studentData?["Sem"] ?? "N/A"),
        _buildDetailRow('Division', studentData?["Devision"] ?? "N/A"),
        _buildSubjectDetailsSection(),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSubjectDetailsSection() {
    List<dynamic> subjectsList = studentData?["Subject"] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subjects:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        ...subjectsList.map((subject) => Text('- $subject')).toList(),
      ],
    );
  }
}
