// filename: lacture_card.dart
import 'package:flutter/material.dart';

class Lecture {
  final String title;
  final String note;
  final String subject;
  final String date;
  final String startTime;
  final String endTime;
  final int color;

  Lecture({
    required this.title,
    required this.note,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

class LectureCard extends StatelessWidget {
  final Lecture lecture;

  const LectureCard({super.key, required this.lecture});

  Color _getCardColor() {
    switch (lecture.color) {
      case 0: return Colors.redAccent;
      case 1: return const Color(0xFF4B68FF); // Blue
      case 2: return Colors.green;
      default: return Colors.grey.shade400;
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: _getCardColor(), width: 5), right: BorderSide(color: _getCardColor(), width: 5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getCardColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lecture.subject.toUpperCase(),
                    style: TextStyle(
                      color: _getCardColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                _buildInfoRow(Icons.access_time_filled_rounded, '${lecture.startTime} - ${lecture.endTime}'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              lecture.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            if (lecture.note.isNotEmpty)
              Text(
                lecture.note,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}