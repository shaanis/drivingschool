import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivingschool/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSlotPage extends StatefulWidget {
  const AdminSlotPage({super.key});

  @override
  State<AdminSlotPage> createState() => _AdminSlotPageState();
}

class _AdminSlotPageState extends State<AdminSlotPage> {
  final carCtrl = TextEditingController();
  final slotsCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  Future<void> createSlot() async {
    if (carCtrl.text.isEmpty ||
        slotsCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      showMessage("Please fill all fields", isError: true);
      return;
    }

    await FirebaseFirestore.instance.collection("slots").add({
      "carName": carCtrl.text.trim(),
      "slotTime": timeCtrl.text.trim(),
      "slotsAvailable": int.parse(slotsCtrl.text.trim()),
      "bookedStudents": [],
      "status": "active",
      "createdAt": FieldValue.serverTimestamp(),
    });

    showMessage("Slot created successfully!");
    carCtrl.clear();
    slotsCtrl.clear();
    timeCtrl.clear();
  }

  void showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.plusJakartaSans(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F6FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: defaultBlue,
        title: Text(
          "Slot Management",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCreateForm(),
          Expanded(child: _buildSlotList()),
        ],
      ),
    );
  }

  Widget _buildCreateForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _inputBox(carCtrl, "Car Name")),
              const SizedBox(width: 12),
              Expanded(
                child: _inputBox(slotsCtrl, "Max Slots", isNumber: true),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _inputBox(timeCtrl, "Time Slot (eg: 8AM - 9AM)"),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: createSlot,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: defaultBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Create Slot",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBox(
    TextEditingController ctrl,
    String hint, {
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffEEF3FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _buildSlotList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("slots")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snap.data!.docs;

        if (data.isEmpty) {
          return Center(
            child: Text(
              "No slots created yet",
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.length,
          itemBuilder: (context, i) {
            final slot = data[i];

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: defaultBlue.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: defaultBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slot["carName"],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slot["slotTime"],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: slot["status"] == "active"
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          slot["status"].toString().toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: slot["status"] == "active"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${slot['slotsAvailable']} slots",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  PopupMenuButton(
                    onSelected: (v) {
                      if (v == "delete") {
                        slot.reference.delete();
                      } else if (v == "toggle") {
                        slot.reference.update({
                          "status": slot["status"] == "active"
                              ? "inactive"
                              : "active",
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "toggle",
                        child: Text(
                          slot["status"] == "active"
                              ? "Deactivate"
                              : "Activate",
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text(
                          "Delete Slot",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
