import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:noproxys/model/task.dart';

class StudentLecturesController extends GetxController {
  var lecturesList = <Task>[].obs;

  void getLectures({
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
          lecturesList.value =
              snapshot.docs.map((doc) {
                return Task.fromFirestore(doc.id, doc.data());
              }).toList();
        });
  }
}