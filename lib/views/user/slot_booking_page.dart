import 'package:drivingschool/const.dart';
import 'package:drivingschool/controller/slot_controller.dart';
import 'package:drivingschool/models/slote_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SlotBookingPage extends StatefulWidget {
  final String studentId;
  final String studentName;

  const SlotBookingPage({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<SlotBookingPage> createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  DateTime selectedDate = DateTime.now();
  bool bookingAvailableTime = false;
  bool hasTomorrowBooking = false;

  @override
  void initState() {
    super.initState();
    checkBookingWindow();
  }

  // 🔵 BOOKING WINDOW NOW 3PM - 5PM
  void checkBookingWindow() {
    final now = DateTime.now();
    bookingAvailableTime = now.hour >= 15 && now.hour < 17;
    setState(() {});
  }

  void showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(msg, style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> showBookingConfirmationDialog(
    SlotController controller,
    DrivingSlotModel slot,
  ) async {
    if (!slot.status.contains("active")) {
      showMessage("Slot inactive", isError: true);
      return;
    }

    if (hasTomorrowBooking) {
      showMessage(
        "You have already booked a slot for tomorrow!",
        isError: true,
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: defaultBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.schedule, color: defaultBlue, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Confirm Booking",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Are you sure you want to book this slot?",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: defaultBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: defaultBlue.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, color: defaultBlue, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            slot.slotTime,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: defaultBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        slot.carName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Book Now",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      final res = await controller.bookSlot(
        slotId: slot.id,
        studentId: widget.studentId,
        studentName: widget.studentName,
      );

      if (res == "success") {
        showMessage("Slot booked successfully!");
        setState(() {});
      } else {
        showMessage(res, isError: true);
      }
    }
  }

  Widget _buildTimeWindowIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bookingAvailableTime
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1), // Changed from orange to red
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bookingAvailableTime
              ? const Color.fromARGB(255, 4, 233, 12)
              : Colors.red.withOpacity(0.3), // Changed from orange to red
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            bookingAvailableTime ? Icons.lock_open : Icons.lock_clock,
            size: 16,
            color: bookingAvailableTime
                ? const Color.fromARGB(255, 4, 233, 12)
                : Colors.red, // Changed from orange to red
          ),
          const SizedBox(width: 6),
          Text(
            bookingAvailableTime
                ? "Booking Open (3 PM - 5 PM)"
                : "Booking Closed",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: bookingAvailableTime
                  ? const Color.fromARGB(255, 4, 233, 12)
                  : Colors.red, // Changed from orange to red
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('EEEE, dd MMM yyyy').format(selectedDate);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ChangeNotifierProvider(
        create: (_) => SlotController(),
        child: Consumer<SlotController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top:
                        MediaQuery.of(context).padding.top +
                        (isMobile ? 20 : 30),
                    left: isMobile ? 20 : 40,
                    right: isMobile ? 20 : 40,
                    bottom: isMobile ? 25 : 35,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        defaultBlue,
                        Color.lerp(defaultBlue, Colors.blue, 0.5)!,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: defaultBlue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Slot Booking",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: isMobile ? 24 : 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Book your driving session",
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: isMobile ? 13 : 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  day,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Student info moved to the top row
                          ],
                        ),
                      ),
                      // Booking window indicator moved here - below the date card
                      const SizedBox(height: 16),
                      Center(child: _buildTimeWindowIndicator()),
                    ],
                  ),
                ),

                // SLOT LIST
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: controller.getAllSlots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: defaultBlue),
                              const SizedBox(height: 16),
                              Text(
                                "Loading slots...",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No slots available",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Check back later for new slots",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final slots = snapshot.data!;

                      return FutureBuilder<Map<String, int>>(
                        future: controller.getTomorrowBookingsCount(),
                        builder: (context, bookingSnapshot) {
                          if (!bookingSnapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: defaultBlue,
                              ),
                            );
                          }

                          final bookingData = bookingSnapshot.data!;

                          return FutureBuilder<bool>(
                            future: controller.checkUserTomorrowBooking(
                              widget.studentId,
                            ),
                            builder: (context, myBookingSnapshot) {
                              if (!myBookingSnapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: defaultBlue,
                                  ),
                                );
                              }

                              hasTomorrowBooking = myBookingSnapshot.data!;

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth > 800;

                                  return isWide
                                      ? _buildGridView(
                                          slots,
                                          bookingData,
                                          controller,
                                          constraints,
                                        )
                                      : _buildListView(
                                          slots,
                                          bookingData,
                                          controller,
                                        );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(
    List<Map<String, dynamic>> slots,
    Map<String, int> bookingData,
    SlotController controller,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        return _buildSlotCard(
          DrivingSlotModel.fromMap(slots[index]),
          bookingData,
          controller,
        );
      },
    );
  }

  Widget _buildGridView(
    List<Map<String, dynamic>> slots,
    Map<String, int> bookingData,
    SlotController controller,
    BoxConstraints constraints,
  ) {
    final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2.5,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        return _buildSlotCard(
          DrivingSlotModel.fromMap(slots[index]),
          bookingData,
          controller,
        );
      },
    );
  }

  Widget _buildSlotCard(
    DrivingSlotModel slot,
    Map<String, int> bookingData,
    SlotController controller,
  ) {
    return FutureBuilder<bool>(
      future: controller.checkUserBookedSlot(widget.studentId, slot.id),
      builder: (context, userBookedSnapshot) {
        bool isMySlot = userBookedSnapshot.data ?? false;
        int bookedCount = bookingData[slot.id] ?? 0;
        bool full = bookedCount >= slot.slotsAvailable;
        final availableSlots = slot.slotsAvailable - bookedCount;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isMySlot ? Colors.green.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: isMySlot
                    ? Colors.green.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isMySlot
                                ? Colors.green.withOpacity(0.1)
                                : defaultBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.directions_car,
                            size: 20,
                            color: isMySlot ? Colors.green : defaultBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.slotTime,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              slot.carName,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isMySlot)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Booked",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: full
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            full ? Icons.person_off : Icons.person,
                            size: 14,
                            color: full ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            full
                                ? "Full"
                                : "$availableSlots/${slot.slotsAvailable} seats",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: full ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!full &&
                        bookingAvailableTime &&
                        slot.status == "active" &&
                        !hasTomorrowBooking &&
                        !isMySlot)
                      ElevatedButton(
                        onPressed: () =>
                            showBookingConfirmationDialog(controller, slot),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark_add, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Book Slot",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
