import 'package:flutter/material.dart';

class Lecture {
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int color;

  Lecture({
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

class LectureCard extends StatelessWidget {
  final Lecture lecture;
  const LectureCard({super.key, required this.lecture});

  Color getCardColor() {
    switch (lecture.color) {
      case 0:
        return Color(0xFFE74C3C);
      case 1:
        return Color(0xFF4b68ff);
      case 2:
        return Color(0xFF27AE60);
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 15,
              height: 99,
              decoration: BoxDecoration(
                color: getCardColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      lecture.note,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          lecture.date,
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${lecture.startTime} - ${lecture.endTime}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
