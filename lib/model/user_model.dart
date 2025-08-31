import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String collegeName;
  final String departmentName;
  final String academicYear;
  final String yearLevel;
  final String batchName;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.collegeName,
    required this.departmentName,
    required this.academicYear,
    required this.yearLevel,
    required this.batchName,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      collegeName: data['collegeName'] ?? '',
      departmentName: data['departmentName'] ?? '',
      academicYear: data['academicYear'] ?? '',
      yearLevel: data['yearLevel'] ?? '',
      batchName: data['batchName'] ?? '',
    );
  }
}
