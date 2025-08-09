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
import 'package:noproxys/screens/Student_screen/lecture_qr_scan_screen.dart';
import 'package:noproxys/widgets/Appbar/Appbar.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StudentLecturesController _lecturesController = Get.put(
    StudentLecturesController(),
  );

  DateTime _selectedDate = DateTime.now();
  bool _isSwiped = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TAppbar(),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.025), // top padding ~2.5% of height
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Overview(),
                    SizedBox(height: size.height * 0.025),
                    Calender(
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    SizedBox(height: size.height * 0.025),
                    const Checkins(),
                    SizedBox(height: size.height * 0.025),
                    SwipeableButtonView(
                      onFinish: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LectureQrScanScreen(),
                          ),
                        );
                      },
                      onWaitingProcess: () {
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _isSwiped = true;
                          });
                        });
                      },
                      activeColor: Colors.blueAccent,
                      buttonWidget: Container(),
                      buttonText: "Swipe to check IN",
                    ),
                    SizedBox(height: size.height * 0.035),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.01,
                      ),
                      child: Text(
                        "Upcoming Lectures:",
                        style: TextStyle(
                          fontSize:
                              orientation == Orientation.portrait
                                  ? size.width * 0.05
                                  : size.height * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    // UpcomingLectures with limited height for better UX on larger screens
                    SizedBox(
                      height:
                          orientation == Orientation.portrait
                              ? size.height * 0.4
                              : size.height * 0.6,
                      child: UpcomingLectures(size: size),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget UpcomingLectures({required Size size}) {
    return Obx(() {
      // Filter lectures by formatted selected date (use yMd format)
      List<Task> filteredTasks =
          _lecturesController.lecturesList
              .where(
                (task) => task.date == DateFormat.yMd().format(_selectedDate),
              )
              .toList();

      if (filteredTasks.isEmpty) {
        return Center(
          child: Text(
            "No lectures found",
            style: TextStyle(
              fontSize: size.width * 0.045,
              color: Colors.grey[600],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index];
          return GestureDetector(
            onTap: () {
              showLectureOptions(context, task.title ?? "CS-101", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LectureQrScanScreen(),
                  ),
                );
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.008,
                horizontal: size.width * 0.01,
              ),
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
            ),
          );
        },
      );
    });
  }
}
