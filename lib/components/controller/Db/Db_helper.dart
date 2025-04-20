import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noproxys/model/task.dart';

class DbHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _collectionName = "tasks";

  // Ensure Firebase is initialized before calling Firestore
  static Future<void> ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }

  // Insert Task into Firestore
  static Future<String> insert(Task task) async {
    try {
      await ensureFirebaseInitialized(); // Ensure Firebase is ready
      DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(task.toJson());
      print("Task added with ID: ${docRef.id}");
      return docRef.id; // Returning Firestore document ID
    } catch (e) {
      print("Error inserting task: $e");
      return "";
    }
  }

  // Query all tasks from Firestore
  static Future<List<Task>> query() async {
    try {
      await ensureFirebaseInitialized(); // Ensure Firebase is ready
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      return snapshot.docs
          .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error querying tasks: $e");
      return [];
    }
  }

  // Update a task in Firestore
  static Future<void> updateTask(String docId, Task task) async {
    try {
      await ensureFirebaseInitialized(); // Ensure Firebase is ready
      await _firestore
          .collection(_collectionName)
          .doc(docId)
          .update(task.toJson());
      print("Task updated: $docId");
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  // Delete a task from Firestore
  static Future<void> deleteTask(String docId) async {
    try {
      await ensureFirebaseInitialized(); // Ensure Firebase is ready
      await _firestore.collection(_collectionName).doc(docId).delete();
      print("Task deleted: $docId");
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
