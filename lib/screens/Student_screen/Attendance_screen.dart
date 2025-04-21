import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noproxys/components/App_widgets/students/Attendance_widgets/aly.dart';
import 'package:noproxys/widgets/Themes/buttons.dart';
import 'package:noproxys/widgets/Themes/size.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  // Function to mark attendance in Firestore
  Future<void> markAttendance(String qrData, String studentId, String studentName) async {
    try {
      // Split QR data to get lecture code
      final parts = qrData.split('-');
      if (parts.length != 3) {
        throw Exception('Invalid QR code format');
      }

      final lectureCode = parts[0];
      final timestamp = DateTime.now();

      // Reference to Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create attendance record
      await firestore.collection('Attendance').add({
        'studentId': studentId,
        'studentName': studentName,
        'lectureCode': lectureCode,
        'timestamp': timestamp,
        'status': 'Present',
        'date': timestamp.toLocal().toString().split(' ')[0],
        'time': timestamp.toLocal().toString().split(' ')[1],
      });

      // You can also update the student's attendance history if needed
      await firestore.collection('Students').doc(studentId).collection('AttendanceHistory').add({
        'lectureCode': lectureCode,
        'timestamp': timestamp,
        'status': 'Present',
      });

    } catch (e) {
      print('Error marking attendance: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('QR Scanner', style: TextStyle()),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(245, 245, 245, 1.000),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage("assets/images/qrrrr.png"),
                        height: Tsize.imageCarouselHeightLR,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: Tsize.buttonWidth,
                  height: 50,
                  child: CustomButton(
                    text: "Scan",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRViewExample(),
                        ),
                      );
                    },
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
