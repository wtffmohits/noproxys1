// // lecture_card.dart (Widget)
// import 'package:flutter/material.dart';
// import 'package:noproxys/components/controller/lacture_card.dart';


// class LectureCard extends StatelessWidget {
//   final Lecture lecture;

//   const LectureCard({Key? key, required this.lecture}) : super(key: key);

//   Color getCardColor(int color) {
//     switch (color) {
//       case 0:
//         return Colors.pink[50]!;
//       case 1:
//         return Colors.blue[50]!;
//       case 2:
//         return Colors.green[50]!;
//       default:
//         return Colors.grey[200]!;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 58,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 15.0, right: 10),
//               child: Text(
//                 lecture.startTime,
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: getCardColor(lecture.color),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     lecture.title,
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     lecture.note,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.black54),
//                   ),
//                   const SizedBox(height: 10),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Text(
//                       '${lecture.startTime} - ${lecture.endTime}',
//                       style:
//                           const TextStyle(fontSize: 12, color: Colors.black54),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
