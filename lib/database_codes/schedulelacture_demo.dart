
// import 'package:cloud_firestore/cloud_firestore.dart';


//  await addLectureSchedule(
//     collegeName: "Thakur Shyamnarayan Degree Collage",
//     departmentName: "BSC-IT",
//     batch: "Batch-A",
//     title: "Operating Systems",
//     note: "Intro lecture",
//     date: "2024-06-12",
//     startTime: "10:00 AM",
//     endTime: "11:00 AM",
//     reminderMinutes: 10,
//     repeat: "None",
//     color: 2,
//     scheduleCode: "ABCD12",
//     staffId: "T123",
//     subject: "OS",
//   );






 //  ye upper wale code main.drt ke my app main function ke andar likha hai







// Future<void> addLectureSchedule({
//   required String collegeName,
//   required String departmentName,
//   required String batch,
//   required String title,
//   required String note,
//   required String date,
//   required String startTime,
//   required String endTime,
//   required int reminderMinutes,
//   required String repeat,
//   required int color,
//   required String scheduleCode,
//   required String staffId,
//   required String subject,
//   bool isCompleted = false,
// }) async {
//   // Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   await _firestore
//       .collection('Collages')
//       .doc(collegeName)
//       .collection('Departments')
//       .doc(departmentName)
//       .collection('LectureSchedules')
//       .add({
//         'title': title,
//         'note': note,
//         'date': date,
//         'startTime': startTime,
//         'endTime': endTime,
//         'reminderMinutes': reminderMinutes,
//         'repeat': repeat,
//         'color': color,
//         'scheduleCode': scheduleCode,
//         'staffId': staffId,
//         'subject': subject,
//         'batch': batch,
//         'isCompleted': isCompleted,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
// }
