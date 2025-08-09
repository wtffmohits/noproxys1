import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addSingleStudentToSpecifiedLocation() async {
  final firestore = FirebaseFirestore.instance;

  // Specify all details as per your needs:
  final Map<String, dynamic> studentData = {
    "name": "Mohit Singh",
    "contact": "+919865287232",
    "email": "rajputmohitsingh1715@gmail.com",
    "roll-no": 1,
    "subjects": [
      "Android Programing",
      "Cloud Computing",
      "Web Dev",
      "Maths",
      "English",
    ],
    "batchYear": "2023",
    "currentSemester": "Semester-1",
    "year": "FY",
    // add more fields if required...
  };

  await firestore
      .collection('Collages')
      .doc('Thakur Shyamnarayan Degree Collage')
      .collection('Departments')
      .doc('BSC-IT')
      .collection('AcademicYear')
      .doc('2022-2025')
      .collection('FY')
      .doc('Students') // "Students" is a document here
      .collection('student-id') // "student-id" is a collection
      .doc('1') // student docID
      .set(studentData);

  print('🎉 Student data added!');
}
