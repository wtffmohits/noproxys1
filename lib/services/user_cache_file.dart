class UserProfile {
  final String collegeName;
  final String departmentName;
  final String role;
  final String academicYear;
  final String yearLevel;
  final String batchName;
  final String staffDocId;

  UserProfile({
    required this.collegeName,
    required this.departmentName,
    required this.role,
    required this.academicYear,
    required this.yearLevel,
    required this.batchName,
    required this.staffDocId,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      collegeName: map['collegeName'] ?? '',
      departmentName: map['departmentName'] ?? '',
      role: map['role'] ?? '',
      academicYear: map['academicYear'] ?? '',
      yearLevel: map['yearLevel'] ?? '',
      batchName: map['batchName'] ?? '',
      staffDocId: map['staffDocId'] ?? '',
    );
  }
}
