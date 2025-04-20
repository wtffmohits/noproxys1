import 'package:flutter/material.dart';

void showLectureOptions(
  BuildContext context,
  String scheduleCode,
  VoidCallback onScan, // नया स्कैन फंक्शन
) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Give Your Attendance", // टाइटल बदला गया
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            // स्कैन बटन जोड़ा गया
            ListTile(
              leading: Icon(Icons.qr_code_scanner, color: Colors.blue),
              title: Text(
                "Scan QR Code",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context); // बॉटम शीट बंद करें
                onScan(); // स्कैन पेज को ट्रिगर करें
              },
            ),
          ],
        ),
      );
    },
  );
}
