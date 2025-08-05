import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noproxys/bottomnav_teach.dart'; // Teacher's home screen
import 'package:noproxys/screens/Signin/Teacher_login/otp_screen.dart'; // Teacher's OTP screen

class AuthServiceTeacher {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔍 Check if teacher exists by phone number in correct Firestore path
  Future<bool> checkIfTeacherExists(String phoneNumber) async {
    try {
      // According to your provided database structure, teacher data is inside collectionGroup 'staff-id'
      final Query staffQuery = _firestore
          .collectionGroup('staff-id')
          .where('Contact', isEqualTo: phoneNumber);
      final QuerySnapshot staffResult = await staffQuery.get();

      return staffResult.docs.isNotEmpty;
    } catch (e) {
      print("Error checking teacher existence: $e");
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
            MaterialPageRoute(builder: (_) => NavigationMenuet()),
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
                  (_) => OtpScreent(
                    verificationId: verificationId,
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timed out
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }

  /// ✅ Verify OTP and sign in teacher
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
        MaterialPageRoute(builder: (_) => NavigationMenuet()),
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
