import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> copyStudentsToAcademicYearFY({
  required String collegeName,
  required String departmentName,
  required String academicYearToCopyTo, // e.g. "2022-2025"
  required String sourceYear, // e.g. "2023"
}) async {
  final firestore = FirebaseFirestore.instance;

  // Step 1: Fetch all batches in sourceYear (under Years)
  final batchesSnapshot =
      await firestore
          .collection('Collages')
          .doc(collegeName)
          .collection('Departments')
          .doc(departmentName)
          .collection('Years')
          .doc(sourceYear)
          .collection('Batches')
          .get();

  for (final batchDoc in batchesSnapshot.docs) {
    String batchName = batchDoc.id;

    // Step 2: Fetch all students in this batch
    final studentsSnapshot =
        await firestore
            .collection('Collages')
            .doc(collegeName)
            .collection('Departments')
            .doc(departmentName)
            .collection('Years')
            .doc(sourceYear)
            .collection('Batches')
            .doc(batchName)
            .collection('student-id')
            .get();

    for (final studentDoc in studentsSnapshot.docs) {
      final studentData = studentDoc.data();
      final studentId = studentDoc.id;

      // Step 3: Copy data to AcademicYear -> 2022-2025 -> FY -> Students -> BatchName -> student-id
      final targetDocRef = firestore
          .collection('Collages')
          .doc(collegeName)
          .collection('Departments')
          .doc(departmentName)
          .collection('AcademicYear')
          .doc(academicYearToCopyTo)
          .collection('FY')
          .collection('Students')
          .doc(batchName) // <=== pehle batchName as doc
          .collection('student-id')
          .doc(studentId); // finally studentId as doc

      await targetDocRef.set(studentData);
      print(
        'Copied student $studentId from batch $batchName to AcademicYear/FY',
      );
    }
  }
}

// --------- Kaise use kare ----------
/*
await copyStudentsToAcademicYearFY(
  collegeName: 'Thakur Shyamnarayan Degree Collage',
  departmentName: 'BSC-IT',
  academicYearToCopyTo: '2022-2025',
  sourceYear: '2023',
);
*/
