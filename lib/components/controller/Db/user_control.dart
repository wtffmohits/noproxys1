// filename: user_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  UserModel? get user => _userModel.value;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        final docSnapshot = await _db.collection('Users').doc(firebaseUser.uid).get();
        if (docSnapshot.exists) {
          _userModel.value = UserModel.fromSnapshot(docSnapshot);
        } else {
          print("User data not found in Firestore for UID: ${firebaseUser.uid}");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }
}

class UserModel {
  final String uid;
  final String collegeName;
  final String departmentName;
  final String academicYear;
  final String yearLevel;
  final String batchName;

  UserModel({
    required this.uid,
    required this.collegeName,
    required this.departmentName,
    required this.academicYear,
    required this.yearLevel,
    required this.batchName,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      uid: document.id,
      collegeName: data['collegeName'] ?? '',
      departmentName: data['departmentName'] ?? '',
      academicYear: data['academicYear'] ?? '',
      yearLevel: data['yearLevel'] ?? '',
      batchName: data['batchName'] ?? '',
    );
  }
}