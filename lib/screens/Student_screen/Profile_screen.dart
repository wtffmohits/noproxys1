import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noproxys/components/App_widgets/students/Profile_widgets/profile_screen.dart';
import 'package:noproxys/components/App_widgets/students/Profile_widgets/proname.dart';
import 'package:noproxys/screens/onbording/onbording_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1.000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                const Proname(),
                const SizedBox(height: 20),
                const Proeditwidgets(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text("Help & Support"),
                        leading: Icon(Icons.call, color: Colors.blue),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: const Text("Logout"),
                        leading: const Icon(
                          Icons.exit_to_app,
                          color: Colors.blue,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();

                          // Yeh ensure karega ki user back press karke wapas na aa sake
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnBordingScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                          // 🔥 This will restart the app
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
