import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noproxys/bottomnav_stud.dart';
import 'package:noproxys/bottomnav_teach.dart';
import 'package:noproxys/screens/Signin/Student_login/otp_screen.dart';

void sendOTP(
  BuildContext context,
  String phoneNumber,
  dynamic selectedCountry,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    phoneNumber: "+91$phoneNumber",
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      print("User Auto-Signed In!");
    },
    verificationFailed: (FirebaseAuthException e) {
      print("Verification Failed: ${e.message}");
    },
    codeSent: (String verificationId, int? resendToken) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(verificationId: verificationId),
        ),
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print("Timeout!");
    },
  );
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> storeUserData(User? user) async {
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'phone': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("✅ User Data Saved to Firestore!");
    }
  }

  //   Future<void> verifyOTP(
  //     BuildContext context,
  //     String otp,
  //     String verificationId,
  //   ) async {
  //     try {
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId,
  //         smsCode: otp,
  //       );

  //       UserCredential userCredential = await _auth.signInWithCredential(
  //         credential,
  //       );

  //       // Firestore me user ka data save karo
  //       await storeUserData(userCredential.user);

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => NavigationMenue(), // Tumhara Home Page ka route
  //         ),
  //       );
  //     } catch (e) {
  //       print("OTP Verification Failed: $e");
  //     }
  //   }
  // }

  void verifyOTP(
    BuildContext context,
    String otp,
    String verificationId,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        final phone = user.phoneNumber!;
        final firestore = FirebaseFirestore.instance;

        final collegesSnapshot = await firestore.collection('Collages').get();
        bool userFound = false;

        for (var collegeDoc in collegesSnapshot.docs) {
          final collegeName = collegeDoc.id;
          print("🎓 Checking College: $collegeName");

          final studentsCollection = firestore
              .collection('Collages')
              .doc(collegeName)
              .collection('students');
          final teachersCollection = firestore
              .collection('Collages')
              .doc(collegeName)
              .collection('teachers');

          // First check for student data
          final departmentsSnapshot = await studentsCollection.get();
          for (var deptDoc in departmentsSnapshot.docs) {
            final deptName = deptDoc.id;
            print("🏢 Checking Department: $deptName");

            final divisionRef = studentsCollection
                .doc(deptName)
                .collection('Devision');
            final batchSnapshot = await divisionRef.get();

            for (var batchDoc in batchSnapshot.docs) {
              final batchName = batchDoc.id;
              print("📦 Checking Batch: $batchName");

              final studentIdRef = divisionRef
                  .doc(batchName)
                  .collection('student-id');
              final studentIdDocs = await studentIdRef.get();

              for (var studentDoc in studentIdDocs.docs) {
                final studentData = studentDoc.data();
                final contact = studentData['Contact'];

                print(
                  "👤 Checking Student ID: ${studentDoc.id} - Contact: $contact",
                );

                if (contact == phone) {
                  userFound = true;
                  print(
                    "✅ Student Found: $collegeName > $deptName > $batchName > ${studentDoc.id}",
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login Successful! Welcome $phone")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => NavigationMenue()),
                  );
                  break;
                }
              }
              if (userFound) break;
            }
            if (userFound) break;
          }

          // If not found in student records, check teacher data
          if (!userFound) {
            final designationsSnapshot = await teachersCollection.get();

            for (var designationDoc in designationsSnapshot.docs) {
              final designationName = designationDoc.id;
              print("🧑‍🏫 Checking Designation: $designationName");

              final teacherIdCollection = teachersCollection
                  .doc(designationName)
                  .collection('teacher-id');

              final teacherDocs = await teacherIdCollection.get();

              for (var teacherDoc in teacherDocs.docs) {
                final teacherData = teacherDoc.data();
                final contact = teacherData['Contact'];

                print(
                  "👨‍🏫 Checking Teacher ID: ${teacherDoc.id} - Contact: $contact",
                );

                if (contact == phone) {
                  userFound = true;
                  print(
                    "✅ Teacher Found: $collegeName > $designationName > ${teacherDoc.id}",
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login Successful! Welcome $phone")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => NavigationMenuet()),
                  );
                  break;
                }
              }

              if (userFound) break;
            }
          }

          if (userFound) break;
        }

        if (!userFound) {
          print("❌ No matching student or teacher found for $phone");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "No student or teacher record found for this number.",
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("❌ OTP Verification Failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP Verification Failed!")));
    }
  }

  void loginWithTestNumber(BuildContext context, String s) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(
            PhoneAuthProvider.credential(
              verificationId:
                  "TEST", // Special test case for Firebase test numbers
              smsCode: "123456", // Firebase me jo OTP set kiya hai
            ),
          );

      print("✅ Login Successful: ${userCredential.user?.uid}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Login Successful: ${userCredential.user?.phoneNumber}",
          ),
        ),
      );

      // Navigate to Home Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationMenue(), // Tumhara Home Page ka route
        ),
      );
    } catch (e) {
      print("❌ Login Failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    }
  }
}
