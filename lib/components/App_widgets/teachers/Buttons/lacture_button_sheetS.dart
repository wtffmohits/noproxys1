// LectureOptionsStudent.dart

import 'package:flutter/material.dart';

void showLectureOptionsStudent(
  BuildContext context,
  String scheduleCode,
  VoidCallback onDetails,
  VoidCallback onFeedback,
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
              "Schedule Code: $scheduleCode",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text("View Details"),
              onTap: () {
                Navigator.pop(context);
                onDetails();
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback, color: Colors.orange),
              title: Text("Add Feedback"),
              onTap: () {
                Navigator.pop(context);
                onFeedback();
              },
            ),
          ],
        ),
      );
    },
  );
}
