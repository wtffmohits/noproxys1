import 'package:flutter/material.dart';
import 'package:noproxys/components/App_widgets/students/Profile_widgets/edit_section.dart';
import 'package:noproxys/screens/Student_screen/Attendance_screen.dart';

class Proeditwidgets extends StatelessWidget {
  const Proeditwidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text("My Account"),
            subtitle: const Text("Make changes to your account"),
            leading: const Icon(Icons.person, color: Colors.blue),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Attend"),
            subtitle: const Text("Setting convenient"),
            leading: const Icon(Icons.qr_code_scanner, color: Colors.blue),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScanScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Activity"),
            subtitle: const Text("Chexk your activity"),
            leading: const Icon(Icons.local_activity, color: Colors.blue),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Notification"),
            subtitle: const Text("Check all notification"),
            leading: const Icon(Icons.notifications_active, color: Colors.blue),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
