import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noproxys/bottomnav_stud.dart';
import 'package:noproxys/screens/Signin/Student_login/otp_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if student exists by phone number (using 'contact' field lowercase!)
  Future<bool> getStudentByPhone(String phoneNumber) async {
    try {
      String normalizedPhone = phoneNumber.trim();
      if (!normalizedPhone.startsWith('+')) {
        normalizedPhone = '+91$normalizedPhone'; // India code
      }
      print("Looking for phone: $normalizedPhone");

      final docs =
          await _firestore
              .collectionGroup('student-id')
              .where(
                'contact',
                isEqualTo: normalizedPhone,
              ) // lowercase 'contact'
              .get();

      print("Docs Found: ${docs.docs.length}");

      if (docs.docs.isNotEmpty) {
        print("Student found: ${docs.docs.first.data()}");
        return true;
      } else {
        print("Student not found for phone: $normalizedPhone");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  /// Send OTP using Firebase Auth
  void sendOtp({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (!context.mounted) return;
          // Navigate to student home screen
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NavigationMenue()),
            (route) => false,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed: ${e.message}")));
        },
        codeSent: (String verificationId, int? resendToken) async {
          if (!context.mounted) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => OtpScreen(
                    verificationId: verificationId,
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// Verify OTP and sign in user
  void verifyOtp({
    required String verificationId,
    required String smsCode,
    required BuildContext context,
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
        MaterialPageRoute(builder: (_) => NavigationMenue()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: ${e.message}")));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
