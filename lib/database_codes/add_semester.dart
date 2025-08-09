import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedFY_SY_TY_withSemesters({
  required String collegeName,
  required String departmentName,
  required String academicYear, // e.g. "2022-2025"
}) async {
  final firestore = FirebaseFirestore.instance;

  // Map of year section (FY/SY/TY) and their respective semesters
  final Map<String, Map<String, List<String>>> data = {
    'FY': {
      'Semester-1': ['Maths I', 'Physics I', 'Programming Fundamentals'],
      'Semester-2': ['Maths II', 'Digital Logic', 'Data Structures'],
    },
    'SY': {
      'Semester-3': ['Discrete Maths', 'OOPS', 'Database'],
      'Semester-4': ['Operating System', 'Web Dev', 'Java'],
    },
    'TY': {
      'Semester-5': ['Networking', 'Software Engg', 'Mobile Computing'],
      'Semester-6': ['Cloud', 'Security', 'Project Work'],
    },
  };

  // Check main AcademicYear exists
  final academicYearDoc =
      await firestore
          .collection('Collages')
          .doc(collegeName)
          .collection('Departments')
          .doc(departmentName)
          .collection('AcademicYear')
          .doc(academicYear)
          .get();

  if (!academicYearDoc.exists) {
    print(
      '❌ AcademicYear "$academicYear" not found under "$departmentName". Pehle AcademicYear create karo.',
    );
    return;
  }

  // Iterate through FY/SY/TY
  for (final yearSection in data.keys) {
    // FY/SY/TY node create (if not present)
    final yearSectionRef = firestore
        .collection('Collages')
        .doc(collegeName)
        .collection('Departments')
        .doc(departmentName)
        .collection('AcademicYear')
        .doc(academicYear)
        .collection(yearSection);

    // Iterate through semesters for this section
    for (final entry in data[yearSection]!.entries) {
      final semester = entry.key;
      final subjects = entry.value;

      final semesterDocRef = yearSectionRef
          .doc(
            'Students',
          ) // Dummy doc, as we can't put a subcollection directly under a collection group
          .collection('Semesters')
          .doc(semester);

      // Actually, Firestore structure favors direct:
      // .../AcademicYear/{batch}/FY/Semesters/{semesterId}

      final correctSemesterDocRef = firestore
          .collection('Collages')
          .doc(collegeName)
          .collection('Departments')
          .doc(departmentName)
          .collection('AcademicYear')
          .doc(academicYear)
          .collection(yearSection)
          .doc('Semesters')
          .collection(semester);

      final semesterDoc = await semesterDocRef.get();

      if (!semesterDoc.exists) {
        await semesterDocRef.set({'subjects': subjects});
        print('✅ Added $yearSection | $semester');
      } else {
        print('⚠️ $yearSection | $semester already exists, skipping...');
      }
    }
  }
  print('🎉 FY/SY/TY semesters added successfully!');
}



// write this in main.dart to seed the data

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await seedSemesterSubjects(
  //   'Thakur Shyamnarayan Degree Collage',
  //   'BSC-IT',
  //   '2022-2025',
  // );