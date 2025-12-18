import 'package:cloud_firestore/cloud_firestore.dart';

class DrivingSlotModel {
  final String id;
  final String carName;
  final int slotsAvailable;
  final String slotTime;
  final String status;
  final DateTime createdAt;

  DrivingSlotModel({
    required this.id,
    required this.carName,
    required this.slotsAvailable,
    required this.slotTime,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "carName": carName,
      "slotsAvailable": slotsAvailable,
      "slotTime": slotTime,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  factory DrivingSlotModel.fromMap(Map<String, dynamic> map) {
    return DrivingSlotModel(
      id: map["id"] ?? "",
      carName: map["carName"] ?? "Unknown Car",
      slotsAvailable: map["slotsAvailable"] ?? 0,
      slotTime: map["slotTime"] ?? "Unknown Time",
      status: map["status"] ?? "inactive",
      createdAt: map["createdAt"] != null
          ? (map["createdAt"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
