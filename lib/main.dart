import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noproxys/App.dart';
import 'package:noproxys/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await addLectureSchedule(
    collegeName: "Thakur Shyamnarayan Degree Collage",
    departmentName: "BSC-IT",
    batch: "Batch-A",
    title: "Operating Systems",
    note: "Intro lecture",
    date: "2024-06-12",
    startTime: "10:00 AM",
    endTime: "11:00 AM",
    reminderMinutes: 10,
    repeat: "None",
    color: 2,
    scheduleCode: "ABCD12",
    staffId: "T123",
    subject: "OS",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

Future<void> addLectureSchedule({
  required String collegeName,
  required String departmentName,
  required String batch,
  required String title,
  required String note,
  required String date,
  required String startTime,
  required String endTime,
  required int reminderMinutes,
  required String repeat,
  required int color,
  required String scheduleCode,
  required String staffId,
  required String subject,
  bool isCompleted = false,
}) async {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore
      .collection('Collages')
      .doc(collegeName)
      .collection('Departments')
      .doc(departmentName)
      .collection('LectureSchedules')
      .add({
        'title': title,
        'note': note,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'reminderMinutes': reminderMinutes,
        'repeat': repeat,
        'color': color,
        'scheduleCode': scheduleCode,
        'staffId': staffId,
        'subject': subject,
        'batch': batch,
        'isCompleted': isCompleted,
        'createdAt': FieldValue.serverTimestamp(),
      });
}


// now hear we go to devlop the app
// we will use firebase for authentication and firestore for data storage
// we will also use provider for state management
// we will use flutter_bloc for state management
// we will use dio for network requests
// we will use get_it for dependency injection
// we will use shared_preferences for local storage
// we will use flutter_local_notifications for push notifications