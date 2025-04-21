import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:noproxys/components/Buttons/button.dart';
import 'package:noproxys/components/controller/Db/Db_helper.dart';
import 'package:noproxys/components/controller/task_controller.dart';
import 'package:noproxys/model/task.dart';
import 'package:noproxys/widgets/teacher/input_field.dart';
// Import Firestore Helper

class Scheduling extends StatefulWidget {
  const Scheduling({super.key});

  @override
  State<Scheduling> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  final databaseReference = FirebaseDatabase.instance.ref("StoreData");
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String endTime = '9:30 PM';
  int? reminderMinutes = 5;
  int selectedColor = 0;
  String selectedRepeat = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Schedule'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1.000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                SizedBox(height: 15),
                Text(
                  "Add Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                MyInputField(
                  hint: "Enter your Title",
                  title: "Title",
                  controller: _titleController,
                ),
                MyInputField(
                  hint: "Enter your Note",
                  title: "Note",
                  controller: _noteController,
                ),
                MyInputField(
                  hint: DateFormat.yMd().format(selectedDate),
                  title: "Date",
                  widget: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _getDateFromUser,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyInputField(
                        hint: startTime,
                        title: "Start Time",
                        widget: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: _getStartTimeFromUser,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MyInputField(
                        hint: endTime,
                        title: "End Time",
                        widget: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: _getEndTimeFromUser,
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  hint:
                      reminderMinutes != null
                          ? "$reminderMinutes minutes early"
                          : "Select Reminder",
                  title: "Reminder",
                  widget: DropdownButton<int>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: [
                      DropdownMenuItem(
                        value: 5,
                        child: Text("5 minutes early"),
                      ),
                      DropdownMenuItem(
                        value: 10,
                        child: Text("10 minutes early"),
                      ),
                      DropdownMenuItem(
                        value: 15,
                        child: Text("15 minutes early"),
                      ),
                      DropdownMenuItem(
                        value: 20,
                        child: Text("20 minutes early"),
                      ),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        reminderMinutes = newValue;
                      });
                    },
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorSelectedIndex(),
                    BlueButton(lable: "Schedule", onTap: _validateAndAddTask),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndAddTask() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all the fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning_amber_rounded),
      );
      return;
    }

    if (taskController.teacherType == null ||
        taskController.teacherId == null) {
      Get.snackbar(
        "Error",
        "Teacher information not initialized. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning_amber_rounded),
      );
      return;
    }

    _addTaskToDb();
  }

  void _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _getStartTimeFromUser() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        startTime = time.format(context);
      });
    }
  }

  void _getEndTimeFromUser() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        endTime = time.format(context);
      });
    }
  }

  void _addTaskToDb() async {
    String scheduleCode = _generateScheduleCode();
    Task newTask = Task(
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime,
      endTime: endTime,
      reminderMinutes: reminderMinutes ?? 0,
      repeat: selectedRepeat,
      color: selectedColor,
      isCompleted: 0,
      scheduleCode: scheduleCode,
    );

    // Save task in Firestore
    bool success = await taskController.addTask(newTask);
    if (success) {
      Get.snackbar(
        "Success",
        "Schedule Created Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Failed to create schedule. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _generateScheduleCode() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return List.generate(
      6,
      (index) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  Widget _colorSelectedIndex() {
    return Wrap(
      children: List<Widget>.generate(3, (int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: [Colors.red, Colors.blue, Colors.green][index],
              child:
                  selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
            ),
          ),
        );
      }),
    );
  }
}
