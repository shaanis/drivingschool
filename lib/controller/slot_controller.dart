import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlotController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  List<Map<String, dynamic>> allBookings = [];
  List<Map<String, dynamic>> filteredBookings = [];

  String selectedDateFilter = "today"; // today | tomorrow
  String searchQuery = "";

  AdminBookedSlotsController() {
    fetchTodaySlots(); // default load
  }

  /// Add slot
  Future<String> addSlot({
    required String carName,
    required String slotTime,
    required int slotsAvailable,
  }) async {
    try {
      // Check if slot exists
      final existingSlot = await _firestore
          .collection('slots')
          .where('carName', isEqualTo: carName)
          .where('slotTime', isEqualTo: slotTime)
          .get();

      if (existingSlot.docs.isNotEmpty) {
        return "Slot already exists for this car at same time";
        print("booking exists");
      }
      if (existingSlot.docs.isNotEmpty) {
        print("booking exists");
      }

      // If not exists → add new slot
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
    required String studentNumber,
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
        "studentNumber": studentNumber.toString(), // add dynamically later
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

  ///------------------------------
  /// 🔥 GET TODAY BOOKINGS
  ///------------------------------
  Future<void> fetchTodaySlots() async {
    isLoading = true;
    notifyListeners();

    try {
      String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

      final snap = await _firestore
          .collection("slotBookings")
          .where("date", isEqualTo: todayDate)
          .get();

      allBookings = snap.docs.map((d) => d.data()).toList();
      filteredBookings = List.from(allBookings);

      selectedDateFilter = "today";
    } catch (e) {
      debugPrint("Fetch today error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  ///------------------------------
  /// 🔥 GET TOMORROW BOOKINGS
  ///------------------------------
  Future<void> fetchTomorrowSlots() async {
    isLoading = true;
    notifyListeners();

    try {
      String tomorrowDate = DateFormat(
        "yyyy-MM-dd",
      ).format(DateTime.now().add(Duration(days: 1)));

      final snap = await _firestore
          .collection("slotBookings")
          .where("date", isEqualTo: tomorrowDate)
          .get();

      allBookings = snap.docs.map((d) => d.data()).toList();
      filteredBookings = List.from(allBookings);

      selectedDateFilter = "tomorrow";
    } catch (e) {
      debugPrint("Fetch tomorrow error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  ///------------------------------
  /// 🔍 SEARCH STUDENT (NAME + NUMBER)
  ///------------------------------
  void searchSlots(String query) {
    searchQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredBookings = List.from(allBookings);
    } else {
      filteredBookings = allBookings.where((slot) {
        final name = slot["studentName"].toString().toLowerCase();
        final number = slot["studentNumber"].toString().toLowerCase();
        return name.contains(searchQuery) || number.contains(searchQuery);
      }).toList();
    }

    notifyListeners();
  }
}
