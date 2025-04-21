import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEditPaget extends StatefulWidget {
  const ProfileEditPaget({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPaget> {
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
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : teacherData == null
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
                          teacherData?["Name"] ?? "Not Available",
                        ),
                        buildTextField(
                          "Email",
                          teacherData?["email"] ?? "Not Available",
                        ),
                        buildTextField(
                          "Contact number",
                          teacherData?["Contact"] ?? "Not Available",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "College: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  teacherData?["College"] ?? "Not Available",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: true,
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
        _buildDetailRow(
          'Department',
          (teacherData?["Department"] as List<dynamic>?)?.join(", ") ?? "N/A",
        ),
        _buildDetailRow('ID', teacherData?["ID"] ?? "N/A"),
        // _buildDetailRow('Year', teacherData?["Year"] ?? "N/A"),
        // _buildDetailRow('Semester', teacherData?["Sem"] ?? "N/A"),
        // _buildDetailRow('Division', teacherData?["Devision"] ?? "N/A"),
        // _buildSubjectDetailsSection(),
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

  //   Widget _buildSubjectDetailsSection() {
  //     List<dynamic> subjectsList = studentData?["Subject"] ?? [];

  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text('Subjects:', style: TextStyle(fontWeight: FontWeight.w600)),
  //         const SizedBox(height: 5),
  //         ...subjectsList.map((subject) => _buildSubjectItem(subject.toString())),
  //       ],
  //     );
  //   }

  //   Widget _buildSubjectItem(String subject) {
  //     return Padding(
  //       padding: const EdgeInsets.only(bottom: 8.0),
  //       child: Text('- $subject'),
  //     );
  //   }
}
