import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class RetestRequestsTab extends StatelessWidget {
  final Color primary;
  final List<Map<String, dynamic>> retestRequests;

  final void Function(String requestId, String status) onProcessRetestRequest;

  final void Function(String requestId, DateTime newDate)
  onUpdateRetestDate; // 🔹 NEW

  const RetestRequestsTab({
    super.key,
    required this.primary,
    required this.retestRequests,
    required this.onProcessRetestRequest,
    required this.onUpdateRetestDate,
  });

  @override
  Widget build(BuildContext context) {
    final pendingRequests = retestRequests
        .where((r) => r["status"] == "pending")
        .toList();

    final processedRequests = retestRequests
        .where((r) => r["status"] != "pending")
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pendingRequests.isNotEmpty) ...[
          _sectionTitle("Pending Retests"),
          const SizedBox(height: 12),
          ...pendingRequests.map((r) => _retestCard(context, r)),
          const SizedBox(height: 24),
        ],
        if (processedRequests.isNotEmpty) ...[
          _sectionTitle("Processed Retests"),
          const SizedBox(height: 12),
          ...processedRequests.map((r) => _retestCard(context, r)),
        ],
      ],
    );
  }

  Widget _retestCard(BuildContext context, Map<String, dynamic> request) {
    Color statusColor;
    IconData statusIcon;

    switch (request["status"]) {
      case "approved":
        statusColor = Colors.green;
        statusIcon = EvaIcons.checkmark_circle;
        break;
      case "rejected":
        statusColor = Colors.red;
        statusIcon = EvaIcons.close_circle;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = EvaIcons.clock;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _pill(
                      request["status"].toString().toUpperCase(),
                      statusColor,
                    ),
                    const Spacer(),
                    Icon(statusIcon, color: statusColor, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  request["studentName"],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID: ${request["studentId"]}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request["testName"],
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 8),
                _infoRow(
                  Icons.score,
                  "Original Score: ${request["originalScore"]}%",
                ),
                _infoRow(
                  EvaIcons.calendar,
                  "Retest Date: ${DateFormat('dd MMM yyyy').format(request["preferredDate"])}",
                ),
                _infoRow(Icons.info, "Reason: ${request["reason"]}"),
              ],
            ),
          ),

          /// 🔹 ACTIONS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: request["status"] == "pending"
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              onProcessRetestRequest(request["id"], "rejected"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text("Reject"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              onProcessRetestRequest(request["id"], "approved"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                          ),
                          child: const Text("Approve"),
                        ),
                      ),
                    ],
                  )
                : request["status"] == "approved"
                ? ElevatedButton.icon(
                    onPressed: () => _pickNewDate(context, request["id"]),
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text("Update Retest Date"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickNewDate(BuildContext context, String requestId) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      onUpdateRetestDate(requestId, picked);
    }
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
