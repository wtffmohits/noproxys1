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
      print("❗User not logged in.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    String? originalPhone = user.phoneNumber;
    print("📱 FirebaseAuth phone: $originalPhone");

    String normalizedPhone = originalPhone ?? "";
    if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
      normalizedPhone = '+91$normalizedPhone';
    }

    print("🔍 Searching for: $normalizedPhone");

    try {
      final firestore = FirebaseFirestore.instance;

      // 🔥 College Info
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
        print("📚 Department: $deptName");

        final divisionRef = collegeRef.doc(deptName).collection('Devision');

        final batchSnapshot = await divisionRef.get();

        if (batchSnapshot.docs.isEmpty) {
          print("⚠️ No batches found under $deptName");
        }

        for (var batchDoc in batchSnapshot.docs) {
          final batchName = batchDoc.id;
          print("🧾 Batch: $batchName");

          final studentIdRef = divisionRef
              .doc(batchName)
              .collection('student-id');

          final studentsSnapshot = await studentIdRef.get();

          for (var studentDoc in studentsSnapshot.docs) {
            final data = studentDoc.data();
            final studentId = studentDoc.id;

            print("👤 Checking: $studentId => ${data['Contact']}");

            if (data['Contact'] == normalizedPhone) {
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
              : SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height *
                        0.85, // 85% of screen height
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1.0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            'assets/images/mohits.jpeg',
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          "Full Name",
                          studentData?["Name"] ?? "Not Available",
                        ),
                        buildTextField(
                          "Email",
                          studentData?["email"] ?? "Not Available",
                        ),
                        buildTextField(
                          "Contact number",
                          studentData?["Contact"] ?? "Not Available",
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "College:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  studentData?["Collage"] ?? "Not Available",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildHeaderSection(),
                      ],
                    ),
                  ),
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
        ...subjectsList.map((subject) => _buildSubjectItem(subject.toString())),
      ],
    );
  }

  Widget _buildSubjectItem(String subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text('- $subject'),
    );
  }
}
