import 'package:flutter/material.dart';

class LectureCard extends StatelessWidget {
  final Lecture lecture;

  const LectureCard({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color indicator
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(lecture.color),
                    Color(lecture.color).withOpacity(0.2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Lecture title
            Text(
              lecture.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Lecture details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture.date,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '${lecture.startTime} - ${lecture.endTime}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),

                // Color indicator dot
                CircleAvatar(radius: 8, backgroundColor: Color(lecture.color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Lecture {
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final int color;

  Lecture({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}
