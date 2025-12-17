import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userID;
  String userName;
  String userEmail;
  int userNumber;
  String? userProPic;
  dynamic selectedCourse; // Can be String or List
  String? selectedInstructor;
  List? userAttendance;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.userNumber,
    this.userProPic,
    this.selectedCourse,
    this.selectedInstructor,
    this.userAttendance,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserModel(
      userID: map['userID'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userNumber: map['userNumber'] ?? 0,
      userProPic: map['userProPic'],
      selectedCourse: map['selectedCourse'],
      selectedInstructor: map['selectedInstructor'],
      userAttendance: map['userAttendance'] ?? [],
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'userEmail': userEmail,
      'userNumber': userNumber,
      'userProPic': userProPic,
      'selectedCourse': selectedCourse,
      'selectedInstructor': selectedInstructor,
      'userAttendance': userAttendance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
