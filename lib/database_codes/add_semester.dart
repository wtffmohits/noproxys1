import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addSemesters({
  required String collage,
  required String department,
  required String academicYear,
  required String yearLevel, // FY, SY, TY
  required String batch,
}) async {
  final firestore = FirebaseFirestore.instance;

  final semestersRef = firestore
      .collection('Collages')
      .doc(collage)
      .collection('Departments')
      .doc(department)
      .collection('AcademicYear')
      .doc(academicYear)
      .collection(yearLevel)
      .doc(batch)
      .collection('Semesters');

  // Example semester data - customize dates & subjects as needed
  List<Map<String, dynamic>> semestersData = [
    {
      'name': 'Semester-1',
      'startDate': Timestamp.fromDate(DateTime(2025, 8, 1)),
      'endDate': Timestamp.fromDate(DateTime(2025, 12, 31)),
      'subjects': ['Maths', 'Physics', 'Chemistry']
    },
    {
      'name': 'Semester-2',
      'startDate': Timestamp.fromDate(DateTime(2026, 1, 1)),
      'endDate': Timestamp.fromDate(DateTime(2026, 5, 31)),
      'subjects': ['Biology', 'English', 'Computer Science']
    }
  ];

  for (var semester in semestersData) {
    await semestersRef.doc(semester['name']).set({
      'startDate': semester['startDate'],
      'endDate': semester['endDate'],
      'subjects': semester['subjects'],
    });
    print('Added ${semester['name']} successfully.');
  }

  print('All semesters added for $yearLevel - $batch in $academicYear');
}

// Usage example
// void main() async {
//   await addSemesters(
//     collage: 'Thakur Shyamnarayan Degree Collage',
//     department: 'BSC-IT',
//     academicYear: '2025-2028',
//     yearLevel: 'FY',
//     batch: 'Batch-A',
//   );
// }
