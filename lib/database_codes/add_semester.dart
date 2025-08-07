import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedSemesterSubjects(
  String collegeName,
  String departmentName,
  String AcademicYear,
) async {
  final firestore = FirebaseFirestore.instance;

  // Check if department exists
  final departmentDoc =
      await firestore
          .collection('Collages')
          .doc(collegeName)
          .collection('Departments')
          .doc(departmentName)
          .collection('AcademicYear')
          .doc(AcademicYear)
          .get();

  if (!departmentDoc.exists) {
    print(
      '❌ Department "$departmentName" does not exist under "$collegeName".',
    );
    return;
  }

  Map<String, List<String>> semesterSubjects = {
    'Semester-1': ['Maths I', 'Physics I', 'Programming Fundamentals'],
    'Semester-2': ['Maths II', 'Digital Logic', 'Data Structures'],
    'Semester-3': ['Discrete Maths', 'OOPS', 'Database'],
    'Semester-4': ['Operating System', 'Web Dev', 'Java'],
    'Semester-5': ['Networking', 'Software Engg', 'Mobile Computing'],
    'Semester-6': ['Cloud', 'Security', 'Project Work'],
  };

  for (var entry in semesterSubjects.entries) {
    final semesterDocRef = firestore
        .collection('Collages')
        .doc(collegeName)
        .collection('Departments')
        .doc(departmentName)
        .collection('AcademicYear')
        .doc(AcademicYear)
        .collection('Semesters')
        .doc(entry.key);

    final semesterDoc = await semesterDocRef.get();

    if (!semesterDoc.exists) {
      await semesterDocRef.set({'subjects': entry.value});
      print('✅ Added ${entry.key}');
    } else {
      print('⚠️ ${entry.key} already exists, skipping...');
    }
  }

  print('🎉 Semester subjects added successfully.');
}
