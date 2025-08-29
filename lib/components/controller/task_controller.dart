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
  }) {
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
  ) async {
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
