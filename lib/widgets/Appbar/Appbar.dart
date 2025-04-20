import 'package:flutter/material.dart';
import 'package:noproxys/screens/Student_screen/Attendance_screen.dart';

class TAppbar extends StatelessWidget {
  const TAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time to do what you do best',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "What's up, Mohit!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QrScanScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
