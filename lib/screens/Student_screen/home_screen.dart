import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/calender.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/checkin.dart';
import 'package:noproxys/components/App_widgets/students/Home_widgets/overview.dart';
import 'package:noproxys/components/Buttons/lacture_button_sheetS.dart';
import 'package:noproxys/components/controller/lacture_card.dart';
import 'package:noproxys/components/controller/task_controller.dart';
import 'package:noproxys/model/task.dart';
import 'package:noproxys/screens/Student_screen/Attendance_screen.dart';
import 'package:noproxys/widgets/Appbar/Appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TAppbar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Upcoming Lectures:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    UpcomingLectures(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget UpcomingLectures() {
    return Obx(() {
      List<Task> filteredTasks =
          _taskController.taskList
              .where(
                (task) => task.date == DateFormat.yMd().format(_selectedDate),
              )
              .toList();

      if (filteredTasks.isEmpty) {
        return const Center(child: Text("No lectures found"));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index];
          return GestureDetector(
            onTap: () {
              showLectureOptions(context, "CS-101", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QrScanScreen()),
                );
              });
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

      // 🔹 Firestore se Data Fetch Karne Ka Method
    });
  }
}
