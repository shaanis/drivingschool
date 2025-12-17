import 'package:drivingschool/controller/test_controller.dart';
import 'package:drivingschool/views/admin/widgets/add_test_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'widgets/test_results_tab.dart';
import 'widgets/retest_requests_tab.dart';

class AdminTestResultsPage extends StatefulWidget {
  const AdminTestResultsPage({super.key});

  @override
  State<AdminTestResultsPage> createState() => _AdminTestResultsPageState();
}

class _AdminTestResultsPageState extends State<AdminTestResultsPage> {
  final primary = const Color(0xFF2E7D32);

  int _selectedTab = 0;
  bool _isEditing = false;
  bool _showAddTest = false;

  /// ✅ RETEST REQUESTS (STATE SOURCE)
  final List<Map<String, dynamic>> _retestRequests = [
    {
      "id": "R1",
      "studentId": "STU002",
      "studentName": "Priya Sharma",
      "testName": "MCWG 8-Track Test (Bike)",
      "originalScore": 68,
      "requestDate": DateTime(2025, 12, 4),
      "preferredDate": DateTime(2025, 12, 15),
      "status": "pending",
      "reason": "Requesting retest due to health issues",
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TestController>(context, listen: false).fetchAllTests(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testController = context.watch<TestController>();

    if (_showAddTest) {
      return AddTest(
        primary: primary,
        onCancel: () async {
          setState(() => _showAddTest = false);
          await testController.fetchAllTests();
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Admin - Test Management",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          if (_selectedTab == 0)
            IconButton(
              icon: Icon(_isEditing ? Icons.done : Icons.edit, color: primary),
              onPressed: () {
                setState(() => _isEditing = !_isEditing);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _tabs(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _adminStatsRow(testController),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                /// TEST RESULTS
                TestResultsTab(
                  primary: primary,
                  allTestResults: testController.testsList.map((t) {
                    return {
                      "id": t.id,
                      "studentId": t.studentId,
                      "studentName": t.studentName,
                      "testName": t.testName,
                      "score": t.passed == null ? 0 : (t.passed! ? 75 : 65),
                      "passed": t.passed,
                      "rto": t.rto,
                      "date": t.date,
                      "status": t.status,
                      "remarks": "",
                    };
                  }).toList(),
                  isEditing: _isEditing,
                  onAddNewTest: _openAddTest,
                  onEvaluateTest: (test, passed) {
                    testController.updateTestResult(
                      testId: test["id"],
                      passed: passed,
                    );
                  },
                  onEvaluateWithScore: (test, score, _) {
                    testController.updateTestResult(
                      testId: test["id"],
                      passed: score >= 70,
                    );
                  },
                  onEditTestResult: (_) {},
                  onUpdateTestDate: (Map<String, dynamic> test, DateTime date) {
                    testController.updateTestDate(
                      testId: test["id"],
                      date: date,
                    );
                  },
                ),

                /// ✅ RETEST REQUESTS
                RetestRequestsTab(
                  primary: primary,
                  retestRequests: _retestRequests,
                  onProcessRetestRequest: _processRetestRequest,
                  onUpdateRetestDate: _updateRetestDate, // 🔥 FIXED
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ================= ACTIONS ================= */

  void _openAddTest() {
    setState(() => _showAddTest = true);
  }

  void _processRetestRequest(String requestId, String status) {
    setState(() {
      final index = _retestRequests.indexWhere((r) => r["id"] == requestId);
      if (index != -1) {
        _retestRequests[index]["status"] = status;
      }
    });
  }

  /// ✅ UPDATE RETEST DATE (WORKING)
  void _updateRetestDate(String requestId, DateTime newDate) {
    setState(() {
      final index = _retestRequests.indexWhere((r) => r["id"] == requestId);
      if (index != -1) {
        _retestRequests[index]["preferredDate"] = newDate;
      }
    });
  }

  /* ================= UI HELPERS ================= */

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _tabButton("Test Results", 0)),
          Expanded(child: _tabButton("Retest Requests", 1)),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
          _isEditing = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _adminStatsRow(TestController controller) {
    final total = controller.testsList.length;
    final passed = controller.testsList.where((t) => t.passed == true).length;
    final pending = controller.testsList.where((t) => t.passed == null).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stat("Total", total.toString(), EvaIcons.file_text, Colors.blue),
        _stat("Pending", pending.toString(), EvaIcons.clock, Colors.orange),
        _stat(
          "Passed",
          passed.toString(),
          EvaIcons.checkmark_circle,
          Colors.green,
        ),
      ],
    );
  }

  Widget _stat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
