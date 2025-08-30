import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> copyFYtoSYKeepingFYIntact({
  required String collage,
  required String department,
  required String academicYear,
  required String batch,
}) async {
  final firestore = FirebaseFirestore.instance;

  // FY path - source students
  final fyStudentRef = firestore
      .collection('Collages')
      .doc(collage)
      .collection('Departments')
      .doc(department)
      .collection('AcademicYear')
      .doc(academicYear)
      .collection('FY')
      .doc(batch)
      .collection('student-id');

  // SY path - destination students
  final syBatchRef = firestore
      .collection('Collages')
      .doc(collage)
      .collection('Departments')
      .doc(department)
      .collection('AcademicYear')
      .doc(academicYear)
      .collection('SY')
      .doc(batch);

  final syStudentRef = syBatchRef.collection('student-id');

  // Create parent Batch-A document in SY if not exists!
  await syBatchRef.set({'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

  // Fetch FY students
  final fySnapshot = await fyStudentRef.get();
  print('FY docs count: ${fySnapshot.docs.length}');
  if (fySnapshot.docs.isEmpty) {
    print('❌ No students found in FY for $batch!');
    return;
  }

  int copiedCount = 0;
  for (var doc in fySnapshot.docs) {
    final data = doc.data();
    print('Copying student: ${doc.id}');
    final syData = Map<String, dynamic>.from(data);
    syData['year'] = 'SY';

    await syStudentRef.doc(doc.id).set(syData);
    copiedCount++;
  }

  final sySnapshot = await syStudentRef.get();
  print('SY docs count after copy: ${sySnapshot.docs.length}');
  print('✅ $copiedCount students copied from FY to SY for $academicYear > $batch');
}


// await copyFYtoSYKeepingFYIntact(
//   collage: 'Thakur Shyamnarayan Degree Collage',
//   department: 'BSC-IT',
//   academicYear: '2022-2025',
//   batch: 'Batch-A',
// );