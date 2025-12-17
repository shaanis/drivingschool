import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class TestResultsTab extends StatelessWidget {
  final Color primary;
  final List<Map<String, dynamic>> allTestResults;
  final bool isEditing;
  final VoidCallback onAddNewTest;
  final void Function(Map<String, dynamic> test, bool passed) onEvaluateTest;
  final void Function(Map<String, dynamic> test, int score, String remarks)
  onEvaluateWithScore;
  final void Function(Map<String, dynamic> test) onEditTestResult;
  final void Function(Map<String, dynamic> test, DateTime date)
  onUpdateTestDate;

  const TestResultsTab({
    super.key,
    required this.primary,
    required this.allTestResults,
    required this.isEditing,
    required this.onAddNewTest,
    required this.onEvaluateTest,
    required this.onEvaluateWithScore,
    required this.onEditTestResult,
    required this.onUpdateTestDate,
  });

  @override
  Widget build(BuildContext context) {
    final pendingTests = allTestResults
        .where((t) => t["passed"] == null)
        .toList();
    final completedTests = allTestResults
        .where((t) => t["passed"] != null)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Add New Test Button
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAddNewTest,
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(
                    "Add New Test",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (pendingTests.isNotEmpty) ...[
          _sectionTitle("Pending Evaluation"),
          const SizedBox(height: 12),
          ...pendingTests.map((t) => _pendingTestCard(context, t)).toList(),
          const SizedBox(height: 24),
        ],
        _sectionTitle("Completed Tests"),
        const SizedBox(height: 12),
        ...completedTests.map((t) => _adminTestCard(context, t)).toList(),
      ],
    );
  }

  /// ================= PENDING TEST CARD =================
  Widget _pendingTestCard(BuildContext context, Map<String, dynamic> test) {
    final DateTime? date = test["date"] as DateTime?;
    final score = test["score"] ?? 0;
    final isRetest = test["isRetest"] ?? false;

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
                    if (isRetest) _pill("RETEST", Colors.purple),
                    _pill("PENDING", Colors.orange),
                    const Spacer(),
                    Text(
                      "Score: $score%",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  test["studentName"] ?? "",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID: ${test["studentId"] ?? ""}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  test["testName"] ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                _infoRow(EvaIcons.pin, test["rto"] ?? ""),
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        EvaIcons.calendar,
                        date != null
                            ? DateFormat('dd MMM yyyy').format(date)
                            : "Not scheduled",
                      ),
                    ),
                    if (date == null)
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null) {
                            onUpdateTestDate(test, picked);
                          }
                        },
                        child: const Text("Approve Retest"),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (date != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onEvaluateTest(test, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Pass"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onEvaluateTest(test, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Fail"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// ================= COMPLETED TEST CARD =================
  Widget _adminTestCard(BuildContext context, Map<String, dynamic> test) {
    final passed = test["passed"] as bool? ?? false;
    final statusColor = passed ? Colors.green : Colors.red;
    final date = test["date"] as DateTime?;
    final score = test["score"] ?? 0;
    final remarks = test["remarks"]?.toString() ?? "";
    final isRetest = test["isRetest"] ?? false;

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isRetest) _pill("RETEST", Colors.purple),
                _pill(
                  passed ? "PASSED" : "FAILED",
                  passed ? Colors.green : Colors.red,
                ),
                const Spacer(),
                if (isEditing)
                  IconButton(
                    onPressed: () => onEditTestResult(test),
                    icon: const Icon(Icons.edit, size: 18),
                    color: Colors.grey[600],
                  ),
                Text(
                  "$score%",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              test["studentName"] ?? "",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "ID: ${test["studentId"] ?? ""}",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              test["testName"] ?? "",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            _infoRow(EvaIcons.pin, test["rto"] ?? ""),
            _infoRow(
              EvaIcons.calendar,
              date != null
                  ? DateFormat('dd MMM yyyy').format(date)
                  : "Not scheduled",
            ),
            if (remarks.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoRow(Icons.comment, "Remarks: $remarks"),
            ],
          ],
        ),
      ),
    );
  }

  /// ================= UI HELPERS =================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
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
