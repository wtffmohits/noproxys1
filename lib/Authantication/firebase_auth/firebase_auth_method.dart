import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noproxys/bottomnav_stud.dart'; // Student home screen
import 'package:noproxys/screens/Signin/Student_login/otp_screen.dart'; // OTP screen

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔍 Check if student exists by phone number (using Contact field)
  Future<Map<String, dynamic>?> getStudentDataByPhone(
    String phoneNumber,
  ) async {
    try {
      String normalizedPhone = phoneNumber.trim();
      if (!normalizedPhone.startsWith('+')) {
        normalizedPhone =
            '+91$normalizedPhone'; // India country code add kar do agar missing ho
      }

      // Firestore collection group search in all "student-id" collections
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore
              .collectionGroup('student-id')
              .where('Contact', isEqualTo: normalizedPhone)
              .limit(1) // sirf pehla match chahiye
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var studentDoc = querySnapshot.docs.first;
        print("Student found: ${studentDoc.data()}");
        // Additional info: Firestore path se AcademicYear, YearLevel, Batch pata laga sakte ho:
        String academicYear =
            studentDoc.reference.parent.parent?.parent?.id ??
            'UnknownAcademicYear';
        String yearLevel =
            studentDoc.reference.parent.parent?.id ?? 'UnknownYearLevel';
        String batch = studentDoc.reference.parent.id;

        Map<String, dynamic> studentData = Map.from(studentDoc.data());
        // Extra metadata add karne ke liye:
        studentData['academicYear'] = academicYear;
        studentData['yearLevel'] = yearLevel;
        studentData['batch'] = batch;

        return studentData;
      } else {
        print("No student found for phone: $normalizedPhone");
        return null;
      }
    } catch (e) {
      print("Failed to fetch student by phone: $e");
      return null;
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
