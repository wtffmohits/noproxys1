import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:noproxys/components/App_widgets/students/Home_widgets/calender.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/checkin.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/overview.dart';
import 'package:noproxys/components/App_widgets/teachers/Buttons/lacture_button_sheetS.dart';
import 'package:noproxys/components/controller/lacture_card.dart';

import 'package:noproxys/components/controller/student_lectures_controller.dart';
import 'package:noproxys/model/task.dart';
import 'package:noproxys/widgets/Appbar/Appbar.dart';

class HomeScreenS extends StatefulWidget {
  const HomeScreenS({super.key});

  @override
  State<HomeScreenS> createState() => _HomeScreenSState();
}

class _HomeScreenSState extends State<HomeScreenS> {
  final StudentLecturesController _lecturesController = Get.put(
    StudentLecturesController(),
  );

  // TODO: Replace these with actual logged-in student details
  final String collegeName = 'Thakur Shyamnarayan Degree Collage';
  final String departmentName = 'BSC-IT';
  final String academicYear = '2023-2026';
  final String yearLevel = 'FY';
  final String batchName = 'Batch-A';

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _lecturesController.getLectures(
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
                  _buildUpcomingLectures(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingLectures(BuildContext context) {
    return Obx(() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      List<Task> filteredTasks =
          _lecturesController.lecturesList
              .where((task) => task.date == formattedDate)
              .toList();

      if (filteredTasks.isEmpty) {
        return Center(
          child: Text(
            "No lectures found",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.045,
              color: Colors.grey[600],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index];
          return GestureDetector(
            onTap: () {
              showLectureOptionsStudent(
                context,
                task.scheduleCode ?? '',
                () {
                  // View details
                },
                () {
                  // Feedback
                },
              );
            },
            child: LectureCard(
              lecture: Lecture(
                title: task.title ?? 'No Title',
                note: task.note ?? 'No Note',
                date: task.date,
                startTime: task.startTime,
                endTime: task.endTime,
                color: task.color,
              ),
            ),
          );
        },
      );
    });
  }
}
