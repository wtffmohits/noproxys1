import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noproxys/bottomnav_stud.dart';
import 'package:noproxys/bottomnav_teach.dart';
import 'package:noproxys/screens/Signin/Student_login/otp_screen.dart';
import 'package:noproxys/screens/Signin/Student_login/signin_screen.dart';
import 'package:noproxys/screens/onbording/onbording_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  Future<bool> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == true) {
              return NavigationMenue(); // Student home
              // return NavigationMenuet(); // Teacher home, if needed
            } else {
              return const OnBordingScreen();
            }
          }
        },
      ),
      routes: {
        "/signins": (context) => RegisterPage(),
        "/otps": (context) => OtpScreen(verificationId: ""),
        "/home": (context) => NavigationMenue(),
        "/home2": (context) => NavigationMenuet(),
      },
    );
  }
}
