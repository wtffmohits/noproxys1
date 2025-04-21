import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:noproxys/components/controller/Db/Db_helper.dart';
import 'package:noproxys/model/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs; // Observable list
  String? teacherType; // Store teacher type (Assistant Prof/HOD)
  String? teacherId; // Store teacher ID

  @override
  void onReady() {
    _initializeTeacher();
    super.onReady();
  }

  Future<void> _initializeTeacher() async {
    User? user = FirebaseAuth.instance.currentUser;
    print("Current user: ${user?.phoneNumber}");

    if (user?.phoneNumber != null) {
      print("Searching for teacher with phone: ${user!.phoneNumber}");
      var teacherInfo = await DbHelper.findTeacherByContact(user.phoneNumber!);

      if (teacherInfo != null) {
        print("Found teacher info: $teacherInfo");
        teacherType = teacherInfo['teacherType'];
        teacherId = teacherInfo['teacherId'];
        print("Teacher initialized - Type: $teacherType, ID: $teacherId");
        getTasks(); // Load tasks after getting teacher info
      } else {
        print("No teacher info found for phone: ${user.phoneNumber}");
      }
    } else {
      print("No phone number available for current user");
    }
  }

  Future<bool> addTask(Task task) async {
    if (teacherType == null || teacherId == null) return false;
    return await DbHelper.insert(task, teacherType!, teacherId!);
  }

  Future<void> getTasks() async {
    if (teacherType == null || teacherId == null) return;
    List<Task> tasks = await DbHelper.query(teacherType!, teacherId!);
    taskList.assignAll(tasks);
  }

  Future<void> updateTask(String taskId, Task task) async {
    if (teacherType == null || teacherId == null) return;
    await DbHelper.updateTask(taskId, task, teacherType!, teacherId!);
    getTasks();
  }

  Future<void> deleteTask(String taskId) async {
    if (teacherType == null || teacherId == null) return;
    await DbHelper.deleteTask(taskId, teacherType!, teacherId!);
    getTasks();
  }

  // 🔹 Firestore se Lecture Delete Karne Ka Method
  // Future<void> deleteLecture(String docId) async {
  //   try {
  //     await _tasksCollection.doc(docId).delete();
  //     taskList.removeWhere((task) => task.id == docId);
  //     Get.snackbar("Success", "Lecture deleted successfully");
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to delete lecture: $e");
  //   }
  // }
}
