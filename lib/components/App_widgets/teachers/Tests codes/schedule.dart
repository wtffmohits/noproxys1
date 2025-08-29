// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';

// import 'package:noproxys/components/App_widgets/teachers/Buttons/button.dart'; // BlueButton import

// class Scheduling extends StatefulWidget {
//   const Scheduling({super.key});

//   @override
//   State<Scheduling> createState() => _SchedulingState();
// }

// class _SchedulingState extends State<Scheduling> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();

//   final String collegeName = 'Thakur Shyamnarayan Degree Collage';
//   String? departmentName; // Dynamic department

//   String? selectedYearLevel; // FY/SY/TY
//   String? selectedBatch;
//   String? selectedSubject;

//   List<String> yearLevels = ['FY', 'SY', 'TY'];
//   List<String> batches = [];
//   List<String> subjects = [];

//   DateTime selectedDate = DateTime.now();

//   String startTime = DateFormat("hh:mm a").format(DateTime.now());
//   String endTime = '9:30 PM';

//   int? reminderMinutes = 5;
//   int selectedColor = 0;
//   String selectedRepeat = 'None';

//   @override
//   void initState() {
//     super.initState();
//     _initDepartmentAndData();
//   }

//   Future<void> _initDepartmentAndData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       Get.snackbar("Error", "User not logged in");
//       return;
//     }
//     String phone = user.phoneNumber ?? '';
//     if (!phone.startsWith('+91') && phone.length == 10) {
//       phone = '+91$phone';
//     }

//     String? dept = await _getDepartmentByStaffContact(phone);
//     setState(() {
//       departmentName = dept ?? 'BSC-IT'; // fallback default
//     });

//     if (selectedYearLevel != null) {
//       await fetchBatchesAndSubjects(selectedYearLevel!);
//     }
//   }

//   Future<String?> _getDepartmentByStaffContact(String contact) async {
//     final firestore = FirebaseFirestore.instance;
//     try {
//       final departmentsSnap = await firestore
//           .collection('Collages')
//           .doc(collegeName)
//           .collection('Departments')
//           .get();

//       for (var deptDoc in departmentsSnap.docs) {
//         List<String> roles = ['HOD', 'Staff', 'Teachers', 'Faculty'];

//         for (String role in roles) {
//           final staffSnap = await deptDoc.reference
//               .collection('Staff')
//               .doc(role)
//               .collection('staff-id')
//               .where('Contact', isEqualTo: contact)
//               .limit(1)
//               .get();

//           if (staffSnap.docs.isNotEmpty) {
//             return deptDoc.id;
//           }
//         }
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching department by staff contact: $e");
//       return null;
//     }
//   }

//   Future<List<String>> _fetchAcademicYearsSorted() async {
//     if (departmentName == null) return [];
//     final snap = await FirebaseFirestore.instance
//         .collection('Collages')
//         .doc(collegeName)
//         .collection('Departments')
//         .doc(departmentName)
//         .collection('AcademicYear')
//         .get();

//     List<String> years = snap.docs.map((doc) => doc.id).toList();
//     years.sort();
//     return years;
//   }

//   Future<void> fetchBatchesAndSubjects(String yearLevel) async {
//     if (departmentName == null) return;
//     final years = await _fetchAcademicYearsSorted();
//     String? academicYear;

//     if (yearLevel == "FY" && years.isNotEmpty) {
//       academicYear = years.last;
//     } else if (yearLevel == "SY" && years.length > 1) {
//       academicYear = years[years.length - 2];
//     } else if (yearLevel == "TY" && years.length > 2) {
//       academicYear = years[years.length - 3];
//     }

//     if (academicYear == null) {
//       setState(() {
//         batches = [];
//         subjects = [];
//       });
//       return;
//     }

//     final batchSnap = await FirebaseFirestore.instance
//         .collection('Collages')
//         .doc(collegeName)
//         .collection('Departments')
//         .doc(departmentName)
//         .collection('AcademicYear')
//         .doc(academicYear)
//         .collection(yearLevel)
//         .get();

//     setState(() {
//       batches = batchSnap.docs
//           .map((doc) => doc.id)
//           .where((id) => !id.startsWith('Semester-')) // Filter semesters here
//           .toList();
//       selectedBatch = null;
//       subjects = [];
//       selectedSubject = null;
//     });
//   }

//   // This method is the key: fetching subjects when batch changes, conditionally loading semester subjects!
//   void onBatchChanged(String? val) async {
//   setState(() {
//     selectedBatch = val;
//     subjects = [];                   // Clear old subjects on batch change
//     selectedSubject = null;
//   });

//   if (val != null && val.startsWith('Semester-')) {
//     if (departmentName == null || selectedYearLevel == null) return;

//     final years = await _fetchAcademicYearsSorted();
//     String? academicYear;
//     if (selectedYearLevel == "FY" && years.isNotEmpty) {
//       academicYear = years.last;
//     } else if (selectedYearLevel == "SY" && years.length > 1) {
//       academicYear = years[years.length - 2];
//     } else if (selectedYearLevel == "TY" && years.length > 2) {
//       academicYear = years[years.length - 3];
//     }

//     if (academicYear == null) return;

//     final semesterSnap = await FirebaseFirestore.instance
//         .collection('Collages')
//         .doc(collegeName)
//         .collection('Departments')
//         .doc(departmentName)
//         .collection('AcademicYear')
//         .doc(academicYear)
//         .collection(selectedYearLevel!)
//         .doc(val)
//         .get();

//     if (semesterSnap.exists) {
//       print("Semester subjects fetched: ${semesterSnap['subjects']}");
//       setState(() {
//         subjects = List<String>.from(semesterSnap['subjects'] ?? []);
//         selectedSubject = null;
//       });
//     } else {
//       print("Semester document does not exist or no subjects");
//     }
//   }
// }

//   String _generateScheduleCode() {
//     const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//     return List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
//   }

//   void _validateAndAddTask() async {
//     if (_titleController.text.isEmpty ||
//         _noteController.text.isEmpty ||
//         selectedYearLevel == null ||
//         selectedBatch == null ||
//         selectedSubject == null) {
//       Get.snackbar("Error", "Please fill all fields",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       return;
//     }

//     String scheduleCode = _generateScheduleCode();
//     final years = await _fetchAcademicYearsSorted();
//     String? academicYear;

//     if (selectedYearLevel == "FY" && years.isNotEmpty) {
//       academicYear = years.last;
//     } else if (selectedYearLevel == "SY" && years.length > 1) {
//       academicYear = years[years.length - 2];
//     } else if (selectedYearLevel == "TY" && years.length > 2) {
//       academicYear = years[years.length - 3];
//     }

//     if (academicYear == null) {
//       Get.snackbar("Error", "Academic Year not found",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       return;
//     }

//     Map<String, dynamic> scheduleData = {
//       'title': _titleController.text,
//       'note': _noteController.text,
//       'date': DateFormat.yMd().format(selectedDate),
//       'startTime': startTime,
//       'endTime': endTime,
//       'reminderMinutes': reminderMinutes ?? 5,
//       'repeat': selectedRepeat,
//       'color': selectedColor,
//       'isCompleted': 0,
//       'scheduleCode': scheduleCode,
//       'batch': selectedBatch,
//       'subject': selectedSubject,
//       'yearLevel': selectedYearLevel,
//       'academicYear': academicYear,
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     try {
//       await FirebaseFirestore.instance
//           .collection('Collages')
//           .doc(collegeName)
//           .collection('Departments')
//           .doc(departmentName ?? 'BSC-IT')
//           .collection('AcademicYear')
//           .doc(academicYear)
//           .collection(selectedYearLevel!)
//           .doc(selectedBatch!)
//           .collection('LectureSchedules')
//           .add(scheduleData);

//       Get.snackbar("Success", "Schedule Created Successfully",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white);
//       Get.back();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to save schedule: $e",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomPadding = MediaQuery.of(context).padding.bottom;
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text('Schedule'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: bottomPadding),
//           child: Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Color.fromRGBO(245, 245, 245, 1),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 const Text(
//                   "Add Schedule",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 _buildInputField("Title", "Enter your Title", _titleController),
//                 _buildInputField("Note", "Enter your Note", _noteController),
//                 _buildInputField(
//                   "Date",
//                   DateFormat.yMd().format(selectedDate),
//                   null,
//                   icon: Icons.calendar_today,
//                   onPressed: _pickDate,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildInputField(
//                         "Start Time",
//                         startTime,
//                         null,
//                         icon: Icons.access_time,
//                         onPressed: _pickStartTime,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildInputField(
//                         "End Time",
//                         endTime,
//                         null,
//                         icon: Icons.access_time,
//                         onPressed: _pickEndTime,
//                       ),
//                     ),
//                   ],
//                 ),
//                 _buildDropdown("Year Level", selectedYearLevel, yearLevels, (val) {
//                   setState(() => selectedYearLevel = val);
//                   if (val != null) fetchBatchesAndSubjects(val);
//                 }),
//                 _buildDropdown("Batch", selectedBatch, batches, onBatchChanged),
//                 _buildDropdown("Subject", selectedSubject, subjects, (val) {
//                   setState(() => selectedSubject = val);
//                 }),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _colorSelectedIndex(),
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: BlueButton(
//                           lable: "Schedule",
//                           onTap: _validateAndAddTask,
//                           label: '',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(String title, String hint, TextEditingController? ctrlField,
//       {IconData? icon, VoidCallback? onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           TextField(
//             controller: ctrlField,
//             readOnly: onPressed != null,
//             onTap: onPressed,
//             decoration: InputDecoration(
//               hintText: hint,
//               suffixIcon: icon != null ? Icon(icon) : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdown(String title, String? selected, List<String> items, ValueChanged<String?> onChanged) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           DropdownButtonFormField<String>(
//             value: selected,
//             hint: Text("Select $title"),
//             items: items
//                 .map(
//                   (val) => DropdownMenuItem(value: val, child: Text(val)),
//                 )
//                 .toList(),
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _colorSelectedIndex() {
//     return Wrap(
//       children: List.generate(3, (int index) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedColor = index;
//             });
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: CircleAvatar(
//               radius: 14,
//               backgroundColor: [Colors.red, Colors.blue, Colors.green][index],
//               child: selectedColor == index
//                   ? const Icon(Icons.done, color: Colors.white, size: 16)
//                   : Container(),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   void _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) setState(() => selectedDate = picked);
//   }

//   void _pickStartTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) setState(() => startTime = picked.format(context));
//   }

//   void _pickEndTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) setState(() => endTime = picked.format(context));
//   }
// }
