import 'package:flutter/material.dart';

import 'package:noproxys/screens/Signin/Student_login/signin_screen.dart';
import 'package:noproxys/screens/Signin/Teacher_login/signin_screen.dart';

class LogiDest extends StatelessWidget {
  const LogiDest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Select Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: _buildLoginButton(
                          context,
                          'assets/images/student.png',
                          'Student',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: _buildLoginButton(
                          context,
                          'assets/images/teach.png',
                          'Teacher',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPages(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildLoginButton(
  BuildContext context,
  String iconPath,
  String label,
  VoidCallback onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minimumSize: const Size(150, 150),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 50, height: 50),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
    ),
  );
}
