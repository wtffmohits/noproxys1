import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:noproxys/screens/Signin/logi_dest.dart';

class OnBordingController extends GetxController {
  static OnBordingController get instance => Get.find();

  //Variable
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  //update current index when page scrolled
  void updatePage(index) => currentPageIndex.value = index;

  // jump spefic dot splited page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(2);
  }

  //update current index and jump next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.to(const LogiDest());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //update current index and jump last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
