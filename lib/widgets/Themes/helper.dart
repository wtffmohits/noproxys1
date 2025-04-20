import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunction{
  static Color? getColor(String value){
    if(value == 'Green'){
      return Colors.green;
    } else if(value == 'Green'){
      return Colors.green;
    } else if(value == 'Red'){
      return Colors.red;
    }
    else if(value == 'Blue'){
      return Colors.blue;
    }
    else if(value == 'Pink'){
      return Colors.pink;
    }
    else if(value == 'Yellow'){
      return Colors.yellow;
    }
    else if(value == 'Purple'){
      return Colors.purple;
    }
    else if(value == 'Orange'){
      return Colors.orange;
    }
    else if(value == 'Grey'){
      return Colors.grey;
    }
    else if(value == 'Brown'){
      return Colors.brown;
    }
    else if(value == 'Black'){
      return Colors.black;
    }
    else if(value == 'White'){
      return Colors.white;
    }
    return null;
  }
  static void showAlert(String title, String message){
    showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK')
          ),
        ]
      );
    });
  }
  
  static double screenWidth(){
    return MediaQuery.of(Get.context!).size.width;
  }
  static double screenHeight(){
    return MediaQuery.of(Get.context!).size.height;
  }
  static Size screenSize(){
    return MediaQuery.of(Get.context!).size;
  }
  static void navigateToScreen(BuildContext context, Widget screen){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
  
}