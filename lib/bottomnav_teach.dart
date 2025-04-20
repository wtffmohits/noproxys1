import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:noproxys/screens/Student_screen/Attendance_screen.dart';
import 'package:noproxys/screens/teachers_screens/home_page.dart';
import 'package:noproxys/screens/teachers_screens/profile.dart';
import 'package:noproxys/screens/teachers_screens/schedule.dart';

class NavigationMenuet extends StatelessWidget {
  const NavigationMenuet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationControllert());
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        child: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected:
                (index) => controller.selectedIndex.value = index,
            destinations: [
              NavigationDestination(
                icon: Icon(Iconsax.home, size: 20),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.check_circle, size: 20),
                label: 'Attend',
              ),
              const NavigationDestination(
                icon: Icon(Iconsax.activity, size: 20),
                label: 'Schedule',
              ),
              const NavigationDestination(
                icon: Icon(Iconsax.user, size: 20),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationControllert extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final screens = [
    HomePageT(),
    const QrScanScreen(),
    const Scheduling(),
    const TeacherProfileScreen(),
  ];
}
