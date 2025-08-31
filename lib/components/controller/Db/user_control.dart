import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noproxys/model/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onReady() {
    super.onReady();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        final docSnapshot = await _db.collection("Users").doc(firebaseUser.uid).get();
        if (docSnapshot.exists) {
          user.value = UserModel.fromSnapshot(docSnapshot);
        }
      }
    } catch (e) {
      print("Something went wrong fetching user data: $e");
    }
  }
}