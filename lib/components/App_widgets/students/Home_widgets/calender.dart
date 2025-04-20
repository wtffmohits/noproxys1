import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';

class Calender extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected; // Callback function

  const Calender({super.key, required this.onDateSelected});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      height: 90,
      width: 60,
      initialSelectedDate: _selectedDate,
      selectionColor: Colors.blueAccent,
      dateTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(fontSize: 10),
      monthTextStyle: const TextStyle(fontSize: 10),
      onDateChange: (date) {
        setState(() {
          _selectedDate = date;
        });
        widget.onDateSelected(date); // Notify the parent
      },
    );
  }
}
