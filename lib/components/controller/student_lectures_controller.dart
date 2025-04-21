import 'package:get/get.dart';
import 'package:noproxys/components/controller/Db/Db_helper.dart';
import 'package:noproxys/model/task.dart';

class StudentLecturesController extends GetxController {
  var lecturesList = <Task>[].obs; // Observable list

  @override
  void onReady() {
    getLectures();
    super.onReady();
  }

  Future<void> getLectures() async {
    try {
      List<Task> lectures = await DbHelper.queryAllLectures();
      lecturesList.assignAll(lectures);
    } catch (e) {
      print("Error getting lectures: $e");
    }
  }
}
