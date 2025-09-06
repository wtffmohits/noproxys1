import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:noproxys/App.dart';
import 'package:noproxys/GetX.dart';
import 'package:noproxys/components/controller/Db/user_control.dart' hide UserController;
import 'package:noproxys/database_codes/Promote_FY.dart';
import 'package:noproxys/database_codes/add_semester.dart';
import 'package:noproxys/database_codes/add_student.dart';
import 'package:noproxys/database_codes/backup.dart';
import 'package:noproxys/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(UserController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}



// now hear we go to devlop the app
// we will use firebase for authentication and firestore for data storage
// we will also use provider for state management
// we will use flutter_bloc for state management
// we will use dio for network requests
// we will use get_it for dependency injection
// we will use shared_preferences for local storage
// we will use flutter_local_notifications for push notificationsnbnmb