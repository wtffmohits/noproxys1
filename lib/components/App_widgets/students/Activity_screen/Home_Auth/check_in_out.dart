// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Employee Attendance App',
//       home: AttendanceScreen(),
//     );
//   }
// }

// class AttendanceScreen extends StatefulWidget {
//   @override
//   _AttendanceScreenState createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   String status = "Not Checked In";
//   DateTime checkInTime = DateTime.now();
//   DateTime checkOutTime = DateTime.now();

//   Future<void> checkIn() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     // Add geofencing logic here to check if within allowed area
//     setState(() {
//       checkInTime = DateTime.now();
//       status = "Checked In at ${checkInTime.toLocal()}";
//     });
//     saveAttendance("checkIn", checkInTime);
//   }

//   Future<void> checkOut() async {
//     setState(() {
//       checkOutTime = DateTime.now();
//       status = "Checked Out at ${checkOutTime.toLocal()}";
//     });
//     saveAttendance("checkOut", checkOutTime);
//   }

//   Future<void> saveAttendance(String type, DateTime time) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(type, time.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Employee Attendance"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(status),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: checkIn,
//               child: Text("Check In"),
//             ),
//             ElevatedButton(
//               onPressed: checkOut,
//               child: Text("Check Out"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }