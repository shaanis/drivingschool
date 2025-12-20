import 'package:cloud_firestore/cloud_firestore.dart';

class SlotBookingModel {
  final String id;
  final String slotId;
  final String studentId;
  final String studentName;
  final String studentNumber;
  final String carName;
  final String slotTime;
  final DateTime createdAt;
  final DateTime date;

  SlotBookingModel({
    required this.id,
    required this.slotId,
    required this.studentId,
    required this.studentName,
    required this.studentNumber,
    required this.carName,
    required this.slotTime,
    required this.createdAt,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "slotId": slotId,
      "studentId": studentId,
      "studentName": studentName,
      "studentNumber": studentNumber,
      "carName": carName,
      "slotTime": slotTime,
      "createdAt": Timestamp.fromDate(createdAt),
      "date": Timestamp.fromDate(date),
    };
  }

  factory SlotBookingModel.fromMap(Map<String, dynamic> map) {
    return SlotBookingModel(
      id: map["id"] ?? "",
      slotId: map["slotId"] ?? "",
      studentId: map["studentId"] ?? "",
      studentName: map["studentName"] ?? "",
      studentNumber: map["studentNumber"] ?? "",
      carName: map["carName"] ?? "",
      slotTime: map["slotTime"] ?? "",

      // createdAt can be Timestamp or String
      createdAt: map["createdAt"] is Timestamp
          ? (map["createdAt"] as Timestamp).toDate()
          : DateTime.tryParse(map["createdAt"] ?? "") ?? DateTime.now(),

      // date can be Timestamp or String
      date: map["date"] is Timestamp
          ? (map["date"] as Timestamp).toDate()
          : DateTime.tryParse(map["date"] ?? "") ?? DateTime.now(),
    );
  }
}
