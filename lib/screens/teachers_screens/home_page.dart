import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:noproxys/components/App_widgets/students/Home_widgets/calender.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/checkin.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/overview.dart';
import 'package:noproxys/components/controller/lacture_card.dart';
import 'package:noproxys/components/App_widgets/teachers/Buttons/lacture_button_sheet.dart';
import 'package:noproxys/components/controller/task_controller.dart';
import 'package:noproxys/model/task.dart';
import 'package:noproxys/widgets/Appbar/Appbar.dart';

class HomePageT extends StatefulWidget {
  const HomePageT({super.key});

  @override
  State<HomePageT> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageT> {
  final TaskController _taskController = Get.put(TaskController());

  // TODO: Replace with actual logged-in teacher's details
  final String collegeName = 'Thakur Shyamnarayan Degree Collage';
  final String departmentName = 'BSC-IT';
  final String academicYear = '2023-2026';
  final String yearLevel = 'FY';
  final String batchName = 'Batch-A';

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController.getTasks(
      collegeName: collegeName,
      departmentName: departmentName,
      academicYear: academicYear,
      yearLevel: yearLevel,
      batchName: batchName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TAppbar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Overview(),
                  const SizedBox(height: 20),
                  Calender(
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Checkins(),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Upcoming Lectures:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildUpcomingLectures(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Rest of your file as it is, sirf _buildUpcomingLectures() method replace karna hai

Widget _buildUpcomingLectures() {
  return Obx(() {
    // Directly use your formatted date from calendar
    String formattedDate = DateFormat('M/d/yyyy').format(_selectedDate); // '8/28/2025'
    List<Task> filteredTasks = _taskController.taskList.where((task) {
      return task.date == formattedDate;
    }).toList();

    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No lectures found for selected date"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        Task task = filteredTasks[index];
        return LectureCard(
          lecture: Lecture(
            title: task.title ?? 'No Title',
            note: task.note ?? 'No Note',
            date: task.date,
            startTime: task.startTime,
            endTime: task.endTime,
            color: task.color, subject: 'NA',
          ),
        );
      },
    );
  });
}
}