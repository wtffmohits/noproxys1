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

  // Get reference to schedule document based on teacher type and ID
  static DocumentReference getScheduleRef(
    String teacherType,
    String teacherId,
  ) {
    return _firestore
        .collection("Collages")
        .doc(_collageDoc)
        .collection("teachers")
        .doc(teacherType)
        .collection("teacher-id")
        .doc(teacherId)
        .collection("Schedule_lacture")
        .doc("schedulecodes");
  }

  // Find teacher ID by contact number
  static Future<Map<String, String>?> findTeacherByContact(
    String contact,
  ) async {
    try {
      print("Searching for teacher with contact: $contact");

      // Normalize the phone number if needed
      String normalizedContact = contact;
      if (!contact.startsWith('+91') && contact.length == 10) {
        normalizedContact = '+91$contact';
      }

      final teachersRef = _firestore
          .collection("Collages")
          .doc(_collageDoc)
          .collection("teachers");

      // First try Assistant Prof
      var assistantProfDocs =
          await teachersRef
              .doc("Assistant Prof")
              .collection("teacher-id")
              .where("Contact", isEqualTo: normalizedContact)
              .get();

      if (assistantProfDocs.docs.isNotEmpty) {
        print("Found teacher in Assistant Prof collection");
        return {
          'teacherType': 'Assistant Prof',
          'teacherId': assistantProfDocs.docs.first.id,
        };
      }

      // If not found, try HOD
      var hodDocs =
          await teachersRef
              .doc("HOD")
              .collection("teacher-id")
              .where("Contact", isEqualTo: normalizedContact)
              .get();

      if (hodDocs.docs.isNotEmpty) {
        print("Found teacher in HOD collection");
        return {'teacherType': 'HOD', 'teacherId': hodDocs.docs.first.id};
      }

      print("No teacher found with contact: $normalizedContact");
      return null;
    } catch (e) {
      print("Error finding teacher: $e");
      return null;
    }
  }

  // Insert Task into Firestore
  static Future<bool> insert(
    Task task,
    String teacherType,
    String teacherId,
  ) async {
    try {
      await ensureFirebaseInitialized();
      DocumentReference scheduleRef = getScheduleRef(teacherType, teacherId);

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
  static Future<List<Task>> query(String teacherType, String teacherId) async {
    try {
      await ensureFirebaseInitialized();
      DocumentSnapshot doc = await getScheduleRef(teacherType, teacherId).get();

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

  // Query all lectures for students
  static Future<List<Task>> queryAllLectures() async {
    try {
      await ensureFirebaseInitialized();
      List<Task> allTasks = [];

      // Get reference to teachers collection
      final teachersRef = _firestore
          .collection("Collages")
          .doc(_collageDoc)
          .collection("teachers");

      // Get all teacher types (Assistant Prof, HOD, etc.)
      final teacherTypesSnapshot = await teachersRef.get();

      // For each teacher type
      for (var teacherTypeDoc in teacherTypesSnapshot.docs) {
        final teacherType = teacherTypeDoc.id;

        // Get all teachers of this type
        final teachersSnapshot =
            await teachersRef.doc(teacherType).collection("teacher-id").get();

        // For each teacher
        for (var teacherDoc in teachersSnapshot.docs) {
          final teacherId = teacherDoc.id;

          // Get their schedule
          final scheduleRef = getScheduleRef(teacherType, teacherId);
          final scheduleDoc = await scheduleRef.get();

          if (scheduleDoc.exists) {
            final data = scheduleDoc.data() as Map<String, dynamic>;
            allTasks.addAll(
              data.values
                  .map(
                    (taskData) =>
                        Task.fromJson(taskData as Map<String, dynamic>),
                  )
                  .toList(),
            );
          }
        }
      }

      return allTasks;
    } catch (e) {
      print("Error querying all lectures: $e");
      return [];
    }
  }

  // Update a task in Firestore
  static Future<void> updateTask(
    String taskId,
    Task task,
    String teacherType,
    String teacherId,
  ) async {
    try {
      await ensureFirebaseInitialized();
      DocumentReference scheduleRef = getScheduleRef(teacherType, teacherId);

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
  static Future<void> deleteTask(
    String taskId,
    String teacherType,
    String teacherId,
  ) async {
    try {
      await ensureFirebaseInitialized();
      DocumentReference scheduleRef = getScheduleRef(teacherType, teacherId);

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
