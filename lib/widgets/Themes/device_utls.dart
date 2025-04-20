
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class TDeviceUtils{
  static String getDeviceId() {
    return '1234567890';
  }
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
  static double getAppBarHeight(){
    return kToolbarHeight;
  }
  static bool isLandscapeOrientation(BuildContext context){
    final ViewInsets = View.of(context).viewInsets;
    return ViewInsets.bottom != 0;
  }
  static bool isPortraitOrientation(BuildContext context){
    final ViewInsets = View.of(context).viewInsets;
    return ViewInsets.bottom != 0;
  }
  static void setFullScreen(bool enable){
    SystemChrome.setEnabledSystemUIMode(enable ? SystemUiMode.immersiveSticky: SystemUiMode.edgeToEdge);
  }
  static double getScreenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double getPixelRatio(){
    return MediaQuery.of(Get.context!).devicePixelRatio;
  }
  static double getStatusBarHeight(){
    return MediaQuery.of(Get.context!).padding.top;
  }
  static double getNavigationBarHeight(){
    return MediaQuery.of(Get.context!).padding.bottom;
  }
  static bool isAndroid(){
    return GetPlatform.isAndroid;
  }
  static bool isIOS(){
    return GetPlatform.isIOS;
  }
  static bool isWeb(){
    return GetPlatform.isWeb;
  }
  // static void launchUrl(String url)async{
  //   if(await canLaunchUrlString(url)){
  //     await launchUrlString(url);
  //   }else{
  //     throw 'Could not launch $url';
  //   }
  // }

}