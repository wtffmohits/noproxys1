import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> copySYtoTYKeepingSYIntact({
  required String collage,
  required String department,
  required String academicYear,
  required String batch,
}) async {
  final firestore = FirebaseFirestore.instance;

  // SY collection path (source)
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

  // TY collection path (destination)
  final tyBatchRef = firestore
      .collection('Collages')
      .doc(collage)
      .collection('Departments')
      .doc(department)
      .collection('AcademicYear')
      .doc(academicYear)
      .collection('TY')
      .doc(batch);

  final tyStudentRef = tyBatchRef.collection('student-id');

  // Create TY parent doc if not exists
  await tyBatchRef.set({'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

  // Fetch SY documents
  final sySnapshot = await syStudentRef.get();
  print('SY docs count: ${sySnapshot.docs.length}');
  if (sySnapshot.docs.isEmpty) {
    print('❌ No students found in SY for $batch!');
    return;
  }

  int copiedCount = 0;
  for (var doc in sySnapshot.docs) {
    final data = doc.data();
    print('Copying student: ${doc.id}');
    final tyData = Map<String, dynamic>.from(data);
    tyData['year'] = 'TY';

    // Copy to TY collection
    await tyStudentRef.doc(doc.id).set(tyData);
    copiedCount++;
  }

  final tySnapshot = await tyStudentRef.get();
  print('TY docs count after copy: ${tySnapshot.docs.length}');
  print('✅ $copiedCount students copied from SY to TY for $academicYear > $batch');
}

// Example call
// await copySYtoTYKeepingSYIntact(
//   collage: 'Thakur Shyamnarayan Degree Collage',
//   department: 'BSC-IT',
//   academicYear: '2022-2025',
//   batch: 'Batch-A',
// );
