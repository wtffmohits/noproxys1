import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:get/get.dart';

class LectureQrScanScreen extends StatefulWidget {
  const LectureQrScanScreen({Key? key}) : super(key: key);

  @override
  State<LectureQrScanScreen> createState() => _LectureQrScanScreenState();
}

class _LectureQrScanScreenState extends State<LectureQrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  // Static student data
  final Map<String, Map<String, dynamic>> studentData = {
    'CS101': {
      'students': [
        {'id': '2024001', 'name': 'John Doe', 'hasLecture': true},
        {'id': '2024002', 'name': 'Jane Smith', 'hasLecture': true},
        {'id': '2024003', 'name': 'Mike Johnson', 'hasLecture': false},
      ],
    },
    'CS102': {
      'students': [
        {'id': '2024001', 'name': 'John Doe', 'hasLecture': false},
        {'id': '2024002', 'name': 'Jane Smith', 'hasLecture': true},
        {'id': '2024003', 'name': 'Mike Johnson', 'hasLecture': true},
      ],
    },
  };

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing && scanData.code != null) {
        isProcessing = true;
        _processQRCode(scanData.code!);
      }
    });
  }

  void _processQRCode(String code) {
    // Handle both formats: "lectureCode-seed" and "studentId:courseCode"
    if (code.contains('-')) {
      // Web system format: lectureCode-seed
      final parts = code.split('-');
      if (parts.length != 2) {
        _showError('Invalid QR code format');
        return;
      }
      final lectureCode = parts[0];
      final seed = parts[1];

      // Here you would typically make an API call to your web backend
      // to verify the attendance. For now, we'll simulate it:
      _simulateAttendanceCheck(lectureCode);
    } else if (code.contains(':')) {
      // Legacy format: studentId:courseCode
      final parts = code.split(':');
      if (parts.length != 2) {
        _showError('Invalid QR code format');
        return;
      }
      final studentId = parts[0];
      final courseCode = parts[1];

      if (studentData.containsKey(courseCode)) {
        final student = studentData[courseCode]!['students'].firstWhere(
          (s) => s['id'] == studentId,
          orElse: () => null,
        );

        if (student != null) {
          if (student['hasLecture']) {
            _showSuccess('You have a lecture in this section');
          } else {
            _showError('You don\'t have any lecture in this section');
          }
        } else {
          _showError('Student ID not found');
        }
      } else {
        _showError('Course code not found');
      }
    } else {
      _showError('Invalid QR code format');
    }

    isProcessing = false;
  }

  void _simulateAttendanceCheck(String lectureCode) {
    // This is where you would make an API call to your web backend
    // For now, we'll just show a success message
    _showSuccess('Attendance recorded for lecture: $lectureCode');

    // You would typically want to:
    // 1. Make an API call to your web backend
    // 2. Send the student's ID and the lecture code
    // 3. Get back a confirmation
    // 4. Show appropriate message based on the response
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan QR code to check lecture attendance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
