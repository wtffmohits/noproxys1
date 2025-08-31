import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  final String title;
  final String note;
  final Timestamp date;
  final String startTime;
  final String endTime;
  final int color;
  final String batch;
  final String subject;

  Lecture({
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.batch,
    required this.subject,
  });

  factory Lecture.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Lecture(
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      date: data['date'],
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      color: data['color'] ?? 0,
      batch: data['batch'] ?? '',
      subject: data['subject'] ?? '',
    );
  }
}
