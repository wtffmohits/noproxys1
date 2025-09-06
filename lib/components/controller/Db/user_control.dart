// lib/components/controller/user_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:noproxys/model/user_model.dart'; // Apna project name check kar lein

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  
  // YAHAN BADLAAV HAI: Yeh ek Rx variable hai
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
          // YAHAN BADLAAV HAI: Hum .value ko update karte hain
          user.value = UserModel.fromSnapshot(docSnapshot);
        } else {
          print("User document not found in Firestore for UID: ${firebaseUser.uid}");
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}