Agar Batch Promotion ya Student Search chahiye toh:
Fetch all students in FY/Batch-A:

dart
FirebaseFirestore.instance
  .collection('Collages').doc('...')
  .collection('Departments').doc('...')
  .collection('AcademicYear').doc('...')
  .collection('FY')
  .collection('Batch-A')
  .collection('student-id')
  .get();



<!-- ----------------------------------------------------------- -->

  Fetch subjects for Semester-1:

dart
FirebaseFirestore.instance
  .collection('Collages').doc('...')
  .collection('Departments').doc('...')
  .collection('AcademicYear').doc('...')
  .collection('FY')
  .doc('Semester-1')
  .get();