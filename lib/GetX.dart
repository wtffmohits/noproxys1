import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserController extends GetxController {
  Rxn<UserModel> userModel = Rxn<UserModel>();

  Future<void> fetchUserProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

      if (snapshot.exists) {
        userModel.value = UserModel.fromSnapshot(snapshot);
      }
    }
  }
}
