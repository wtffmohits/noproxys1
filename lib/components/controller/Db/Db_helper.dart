import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noproxys/model/task.dart';

class DbHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _collageDoc = "Thakur Shyamnarayan Degree Collage";

  // Ensure Firebase is initialized before calling Firestore
  static Future<void> ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }

  // Get reference to schedule document based on teacher type (Assistant Prof/HOD)
  static DocumentReference getScheduleRef(String teacherType) {
    return _firestore
        .collection("Collages")
        .doc(_collageDoc)
        .collection("teachers")
        .doc(teacherType)
        .collection("Schedule_lacture")
        .doc("schedulecodes");
  }

  // Insert Task into Firestore
  static Future<bool> insert(Task task, String teacherType) async {
    try {
      await ensureFirebaseInitialized();
      DocumentReference scheduleRef = getScheduleRef(teacherType);

      // Get current data or initialize empty map
      DocumentSnapshot doc = await scheduleRef.get();
      Map<String, dynamic> currentData =
          doc.exists ? (doc.data() as Map<String, dynamic>) : {};

      // Use scheduleCode as the key instead of timestamp
      String taskId = task.scheduleCode;
      currentData[taskId] = task.toJson();

      await scheduleRef.set(currentData);
      print("Schedule added with ID: $taskId");
      return true;
    } catch (e) {
      print("Error inserting schedule: $e");
      return false;
    }
  }

  // Query all tasks from Firestore
  static Future<List<Task>> query(String teacherType) async {
    try {
      await ensureFirebaseInitialized();
      DocumentSnapshot doc = await getScheduleRef(teacherType).get();

      if (!doc.exists) return [];

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data.values
          .map((taskData) => Task.fromJson(taskData as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error querying schedules: $e");
      return [];
    }
  }

  // Update a task in Firestore
  static Future<void> updateTask(
    String taskId,
    Task task,
    String teacherType,
  ) async {
    try {
      await ensureFirebaseInitialized();
      DocumentReference scheduleRef = getScheduleRef(teacherType);

      DocumentSnapshot doc = await scheduleRef.get();
      if (!doc.exists) return;

      Map<String, dynamic> currentData = doc.data() as Map<String, dynamic>;
      currentData[taskId] = task.toJson();

      await scheduleRef.update(currentData);
      print("Schedule updated: $taskId");
    } catch (e) {
      print("Error updating schedule: $e");
    }
  }

  // Delete a task from Firestore
  static Future<void> deleteTask(String taskId, String teacherType) async {
    try {
      await ensureFirebaseInitialized();
      DocumentReference scheduleRef = getScheduleRef(teacherType);

      DocumentSnapshot doc = await scheduleRef.get();
      if (!doc.exists) return;

      Map<String, dynamic> currentData = doc.data() as Map<String, dynamic>;
      currentData.remove(taskId);

      await scheduleRef.set(currentData);
      print("Schedule deleted: $taskId");
    } catch (e) {
      print("Error deleting schedule: $e");
    }
  }
}
