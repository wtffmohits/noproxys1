import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:noproxys/model/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  // Batch, yearLevel, academicYear, department wise schedule fetch
  void getTasks({
    required String collegeName,
    required String departmentName,
    required String academicYear,
    required String yearLevel,
    required String batchName,
    required String subject,
  }) {
    // Validate inputs for Firestore path
    if ([collegeName, departmentName, academicYear, yearLevel, batchName].any((s) => s.isEmpty)) {
      print("Error: One or more Firestore path arguments are empty");
      print('collegeName: $collegeName');
      print('departmentName: $departmentName');
      print('academicYear: $academicYear');
      print('yearLevel: $yearLevel');
      print('batchName: $batchName');
      return;
    }

    FirebaseFirestore.instance
        .collection('Collages')
        .doc(collegeName)
        .collection('Departments')
        .doc(departmentName)
        .collection('AcademicYear')
        .doc(academicYear)
        .collection(yearLevel)
        .doc(batchName)
        .collection('LectureSchedules')
        .orderBy('date')
        .snapshots()
        .listen((snapshot) {
      taskList.value = snapshot.docs.map((doc) {
        return Task.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  Future deleteTask(
    String id,
    String collegeName,
    String departmentName,
    String academicYear,
    String yearLevel,
    String batchName,
    String subject,
  ) async {
    // Validate inputs for Firestore path
    if ([collegeName, departmentName, academicYear, yearLevel, batchName].any((s) => s.isEmpty)) {
      print("Error: One or more Firestore path arguments are empty on deleteTask");
      return;
    }

    await FirebaseFirestore.instance
        .collection('Collages')
        .doc(collegeName)
        .collection('Departments')
        .doc(departmentName)
        .collection('AcademicYear')
        .doc(academicYear)
        .collection(yearLevel)
        .doc(batchName)
        .collection('LectureSchedules')
        .doc(id)
        .delete();
  }
}
