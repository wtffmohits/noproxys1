import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noproxys/bottomnav_stud.dart'; // Student home screen
import 'package:noproxys/screens/Signin/Student_login/otp_screen.dart'; // OTP screen

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔍 Check if student exists by phone number (using Contact field)
  Future<bool> checkIfUserExists(String phoneNumber) async {
    try {
      final studentQuery = _firestore
          .collectionGroup('student-id')
          .where('Contact', isEqualTo: phoneNumber); // field must be 'Contact'

      final studentResult = await studentQuery.get();

      return studentResult.docs.isNotEmpty;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  /// 📲 Send OTP using Firebase Authentication
  void sendOtp({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (!context.mounted) return;
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationMenue()),
            (route) => false,
          );
        },

        verificationFailed: (FirebaseAuthException e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification Failed: ${e.message}")),
          );
        },

        codeSent: (String verificationId, int? resendToken) async {
          if (!context.mounted) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpScreen(
                    verificationId: verificationId,
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timed out
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }

  /// ✅ Verify OTP and sign in user
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      if (!context.mounted) return;
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavigationMenue()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in: ${e.message}")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }
}
