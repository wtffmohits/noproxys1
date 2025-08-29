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
      case 0: return const Color(0xFFE74C3C);
      case 1: return const Color(0xFF4B68FF);
      case 2: return const Color(0xFF27AE60);
      default: return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: getCardColor().withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 90,
              decoration: BoxDecoration(
                color: getCardColor(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lecture.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(lecture.date,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 20),
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text('${lecture.startTime} - ${lecture.endTime}',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
