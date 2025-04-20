import 'package:get/get.dart';
import 'package:noproxys/components/controller/Db/Db_helper.dart';
import 'package:noproxys/model/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs; // Observable list
  final String teacherType; // Store teacher type (Assistant Prof/HOD)

  TaskController({
    this.teacherType = 'Assistant Prof',
  }); // Default to Assistant Prof

  // 🔥 Firestore Collection Reference
  // final CollectionReference _tasksCollection = FirebaseFirestore.instance
  //     .collection('tasks');

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  Future<bool> addTask(Task task) async {
    return await DbHelper.insert(task, teacherType);
  }

  Future<void> getTasks() async {
    List<Task> tasks = await DbHelper.query(teacherType);
    taskList.assignAll(tasks);
  }

  Future<void> updateTask(String taskId, Task task) async {
    await DbHelper.updateTask(taskId, task, teacherType);
    getTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await DbHelper.deleteTask(taskId, teacherType);
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
