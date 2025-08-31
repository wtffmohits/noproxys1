import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String? title;
  String? note;
  String date;
  String startTime;
  String endTime;
  int color;
  String? scheduleCode;
  String? academicYear;
  String? yearLevel;
  String? batch;
  String? subject;

  Task({
    this.id,
    this.title,
    this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.scheduleCode,
    this.academicYear,
    this.yearLevel,
    this.batch,
    this.subject,
  });

  factory Task.fromFirestore(String docId, Map<String, dynamic> data) {
    return Task(
      id: docId,
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      color: data['color'] ?? 0,
      scheduleCode: data['scheduleCode'],
      academicYear: data['academicYear'],
      yearLevel: data['yearLevel'],
      batch: data['batch'],
      subject: data['subject'] ?? 'N/A',
    );
  }

  static fromSnapshot(QueryDocumentSnapshot<Object?> doc) {}
}
