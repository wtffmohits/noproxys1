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
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  /// Fetches student data efficiently using a Firestore collectionGroup query.
  Future<void> fetchStudentData() async {
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

    // Normalize phone number to ensure it has the +91 prefix for querying
    String normalizedPhone = originalPhone;
    if (!normalizedPhone.startsWith('+91') && normalizedPhone.length == 10) {
      normalizedPhone = '+91$normalizedPhone';
    }

    print("🔍 Searching for contact: $normalizedPhone");

    try {
      final firestore = FirebaseFirestore.instance;

      // Use a Collection Group query to efficiently search across all 'student-id' subcollections.
      final studentQuerySnapshot =
          await firestore
              .collectionGroup('student-id')
              .where('Contact', isEqualTo: normalizedPhone)
              .limit(1)
              .get();

      if (studentQuerySnapshot.docs.isEmpty) {
        print("❌ No student found with contact: $normalizedPhone");
        setState(() {
          isLoading = false;
          errorMessage =
              "Student data could not be found for your contact number.";
        });
        return;
      }

      final studentDoc = studentQuerySnapshot.docs.first;
      final studentDataMap = studentDoc.data();
      print("✅ Student found: ${studentDataMap['Name']}");

      // Traverse up the document tree to get parent information
      // Path: Collages/{collageId}/students/{deptId}/Devision/{batchId}/student-id/{studentId}
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
          "Devision":
              batchRef.id, // Correctly gets the division/batch name from its ID
          "StudentID": studentDoc.id,
        };
        isLoading = false;
      });
    } catch (e) {
      print("🔥 Firestore query error: $e");
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred while fetching data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Lighter background for the body
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: buildBody(),
      // bottomNavigationBar: buildSaveButton(),
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

    if (studentData == null) {
      return const Center(child: Text("No data found."));
    }

    return Stack(
      children: [
        // Blue header background
        Container(height: 120, color: Colors.blue),
        SafeArea(
          child: SingleChildScrollView(
            // Start scrolling content below the blue header
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
                    backgroundImage: AssetImage('assets/images/mohits.jpeg'),
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
                      buildTextField("Full Name", studentData?["Name"]),
                      buildTextField("Email", studentData?["email"]),
                      buildTextField("Contact", studentData?["Contact"]),
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
        readOnly: true, // Fields are not editable in this view
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
      width: double.infinity, // पूरे उपलब्ध width को लेगा
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school, color: Colors.blue.shade800, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              studentData?["Collage"] ?? "Not Available",
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
          "Academic Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildDetailRow('Course', studentData?["Department"]),
        // FIX: Convert potential integer values to String to prevent runtime error.
        _buildDetailRow('Roll No.', studentData?["Roll-no"]?.toString()),
        _buildDetailRow('Year', studentData?["Year"]?.toString()),
        _buildDetailRow('Semester', studentData?["Sem"]?.toString()),
        _buildDetailRow('Division', studentData?["Devision"]),
        // _buildDetailRow('Subjects', studentData?["Subjects"]?.toString()),
        const SizedBox(height: 10),
        _buildSubjectDetailsSection(),
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

  Widget _buildSubjectDetailsSection() {
    // Ensure that subjectsList is treated as a List<dynamic>
    final dynamic Subjects = studentData?["Subjects"];
    if (Subjects == null || Subjects is! List || Subjects.isEmpty) {
      return const SizedBox.shrink(); // Don't show anything if no subjects
    }

    final List<dynamic> subjectsList = Subjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 20),
        Text(
          'Subjects',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 5),
        ...subjectsList.map((Subject) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('•  $Subject', style: const TextStyle(fontSize: 15)),
          );
        }).toList(),
      ],
    );
  }

  // Widget buildSaveButton() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         // TODO: Implement save logic here.
  //         // This will involve creating controllers for each text field,
  //         // allowing them to be editable, and then on save,
  //         // updating the document in Firestore.
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Save functionality not implemented yet.'),
  //           ),
  //         );
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.blue,
  //         foregroundColor: Colors.white,
  //         padding: const EdgeInsets.symmetric(vertical: 15),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //       child: const Text("Save Changes", style: TextStyle(fontSize: 18)),
  //     ),
  //   );
  // }
}

Future<Map<String, dynamic>?> fetchSemesterDataForStudent({
  required String collegeName,
  required String departmentName,
  required String academicYear,
  required String yearLevel, // e.g. "FY", "SY", "TY"
  required String semesterId, // e.g. "Semester-1"
}) async {
  final firestore = FirebaseFirestore.instance;

  final semesterDocRef = firestore
      .collection('Collages')
      .doc(collegeName)
      .collection('Departments')
      .doc(departmentName)
      .collection('AcademicYear')
      .doc(academicYear)
      .collection(yearLevel) // FY, SY, TY
      .doc(semesterId); // Semester-1

  final snapshot = await semesterDocRef.get();
  if (!snapshot.exists) {
    print('❌ Semester "$semesterId" not found!');
    return null;
  }
  return snapshot.data();
}
