import 'package:flutter/material.dart';

void showLectureOptionsT(
  BuildContext context,
  String scheduleCode,
  VoidCallback onComplete,
  VoidCallback onDelete,
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
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("Mark as Complete"),
              onTap: () {
                Navigator.pop(context);
                onComplete();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete Lecture"),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      );
    },
  );
}
