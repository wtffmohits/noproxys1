import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> exportCollectionAsJson(String collectionName) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection(collectionName).get();
  List<Map<String, dynamic>> dataList = [];
  for (var doc in snapshot.docs) {
    dataList.add(doc.data());
  }
  String jsonStr = jsonEncode(dataList);

  // Save JSON to device storage
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDocDir.path}/backup_$collectionName.json';
  File backupFile = File(filePath);
  await backupFile.writeAsString(jsonStr);

  print("Backup saved at: $filePath");
}


//  ye funcion call

// await exportCollectionAsJson("students");
