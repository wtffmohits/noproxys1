import 'package:get/get.dart';
import 'package:noproxys/components/controller/Db/Db_helper.dart';
import 'package:noproxys/model/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs; // Observable list

  // 🔥 Firestore Collection Reference
  // final CollectionReference _tasksCollection = FirebaseFirestore.instance
  //     .collection('tasks');

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  Future<String> addTask(Task task) async {
    return await DbHelper.insert(task);
  }

  Future<void> getTasks() async {
    List<Task> tasks = await DbHelper.query();
    taskList.assignAll(tasks);
  }

  Future<void> updateTask(String docId, Task task) async {
    await DbHelper.updateTask(docId, task);
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
