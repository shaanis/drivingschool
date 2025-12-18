import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlotController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  /// Add slot
  Future<String> addSlot({
    required String carName,
    required String slotTime,
    required int slotsAvailable,
  }) async {
    try {
      final doc = _firestore.collection('slots').doc();
      await doc.set({
        "id": doc.id,
        "carName": carName,
        "slotTime": slotTime,
        "slotsAvailable": slotsAvailable,
        "status": "active",
        "createdAt": FieldValue.serverTimestamp(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  /// Read all slots
  Stream<List<Map<String, dynamic>>> getAllSlots() {
    return _firestore
        .collection("slots")
        .orderBy("createdAt")
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList(),
        );
  }

  /// Count bookings for tomorrow per slot
  Future<Map<String, int>> getTomorrowBookingsCount() async {
    try {
      final date = DateFormat(
        "yyyy-MM-dd",
      ).format(DateTime.now().add(Duration(days: 1)));

      final snap = await _firestore
          .collection("slotBookings")
          .where("date", isEqualTo: date)
          .get();

      Map<String, int> countMap = {};

      for (var doc in snap.docs) {
        String slotId = doc["slotId"];
        countMap[slotId] = (countMap[slotId] ?? 0) + 1;
      }

      return countMap;
    } catch (e) {
      return {};
    }
  }

  Future<bool> checkUserBookedSlot(String studentId, String slotId) async {
    final date = DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.now().add(Duration(days: 1)));

    final snap = await _firestore
        .collection("slotBookings")
        .where("date", isEqualTo: date)
        .where("studentId", isEqualTo: studentId)
        .where("slotId", isEqualTo: slotId)
        .get();

    return snap.docs.isNotEmpty;
  }

  /// Check if user already booked tomorrow
  Future<bool> checkUserTomorrowBooking(String studentId) async {
    final date = DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.now().add(Duration(days: 1)));

    final snap = await _firestore
        .collection("slotBookings")
        .where("date", isEqualTo: date)
        .where("studentId", isEqualTo: studentId)
        .get();

    return snap.docs.isNotEmpty;
  }

  /// BOOK SLOT
  Future<String> bookSlot({
    required String slotId,
    required String studentId,
    required String studentName,
  }) async {
    try {
      /// slot data fetch
      final slotData = await _firestore.collection("slots").doc(slotId).get();

      if (!slotData.exists) return "Slot not found";

      final slot = slotData.data()!;
      final carName = slot["carName"];
      final slotTime = slot["slotTime"];
      final slotsAvailable = slot["slotsAvailable"];

      final tomorrowDate = DateFormat(
        "yyyy-MM-dd",
      ).format(DateTime.now().add(Duration(days: 1)));

      /// count booked already for slot
      final snap = await _firestore
          .collection("slotBookings")
          .where("slotId", isEqualTo: slotId)
          .where("date", isEqualTo: tomorrowDate)
          .get();

      if (snap.docs.length >= slotsAvailable) {
        return "Slot full";
      }

      /// one booking per student rule
      final exists = await checkUserTomorrowBooking(studentId);

      if (exists) return "You already booked tomorrow";

      /// save booking
      final bookingDoc = _firestore.collection("slotBookings").doc();

      await bookingDoc.set({
        "id": bookingDoc.id,
        "studentId": studentId,
        "studentName": studentName, // add dynamically later
        "slotId": slotId,
        "slotTime": slotTime,
        "carName": carName,
        "date": tomorrowDate,
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  /// Delete slot
  Future<void> deleteSlot(String slotId) async {
    await _firestore.collection('slots').doc(slotId).delete();
  }
}
