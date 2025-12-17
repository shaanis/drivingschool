import 'package:drivingschool/controller/test_controller.dart';
import 'package:drivingschool/controller/user_controller.dart';
import 'package:drivingschool/models/user_test_model.dart';
import 'package:drivingschool/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class TestResultsPage extends StatefulWidget {
  const TestResultsPage({super.key});

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
  final primary = const Color(0xFF2E7D32);
  late String _currentUserId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCtrl = context.read<UserController>();

      if (userCtrl.userModel == null) {
        await userCtrl.fetchUserData(userCtrl.uid);
      }

      _currentUserId = userCtrl.userModel.userID;

      final controller = context.read<TestController>();
      await controller.fetchTestsByStudent(_currentUserId);
      _scheduleAllUpcomingReminders(controller);
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scheduleAllUpcomingReminders(TestController controller) async {
    final upcoming = controller.testsList.where(
      (t) => t.status == 'pending' && t.date != null,
    );

    for (final test in upcoming) {
      await NotificationService.scheduleTestReminder(test.date!, test.testName);
    }
  }

  // ================= APPLY RETEST =================
  void _applyForRetest(TestModel failedTest) {
    final controller = context.read<TestController>();

    final alreadyPending = controller.testsList.any(
      (t) =>
          t.studentId == failedTest.studentId &&
          t.testName == failedTest.testName &&
          t.status == 'pending',
    );

    if (alreadyPending) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Retest already applied")));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Apply for Retest"),
        content: Text(
          "Are you sure you want to apply for ${failedTest.isRetest ? "another " : ""}retest for ${failedTest.testName}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performRetestApplication(controller, failedTest);
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  Future<void> _performRetestApplication(
    TestController controller,
    TestModel failedTest,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await controller.applyRetest(failedTest);

      // Refresh the tests list
      await controller.fetchTestsByStudent(_currentUserId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Retest applied successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Optionally navigate back after successful application
      // Navigator.pop(context); // Uncomment if you want to go back
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to apply retest: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F9F5),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Kerala DL Test Results",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: _isLoading || controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadInitialData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _modernStatsRow(controller),
                      const SizedBox(height: 32),
                      _sectionTitle("Upcoming DL Test"),
                      const SizedBox(height: 16),
                      _buildUpcomingTests(controller),
                      const SizedBox(height: 32),
                      _sectionTitle("Test History"),
                      const SizedBox(height: 16),
                      _buildHistory(controller),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ================= STATS =================
  Widget _modernStatsRow(TestController c) {
    final passed = c.testsList.where((t) => t.passed == true).length;
    final failed = c.testsList.where((t) => t.passed == false).length;
    final total = passed + failed;
    final avg = total == 0 ? 0 : ((passed / total) * 100).round();

    return Row(
      children: [
        _stat(
          "Passed",
          passed.toString(),
          EvaIcons.checkmark_circle,
          Colors.green,
        ),
        _stat("Failed", failed.toString(), EvaIcons.close_circle, Colors.red),
        _stat("Avg", "$avg%", EvaIcons.bar_chart, Colors.orange),
      ],
    );
  }

  Widget _stat(String t, String v, IconData i, Color c) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(i, color: c),
            const SizedBox(height: 12),
            Text(
              v,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              t,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UPCOMING =================
  Widget _buildUpcomingTests(TestController c) {
    final list = c.testsList.where((t) => t.status == 'pending').toList();

    if (list.isEmpty) {
      return Center(
        child: Text("No upcoming tests", style: GoogleFonts.poppins()),
      );
    }

    return Column(children: list.map(_upcomingCard).toList());
  }

  Widget _upcomingCard(TestModel t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _pill("UPCOMING", primary),
              if (t.isRetest) const SizedBox(width: 8),
              if (t.isRetest) _pill("RETEST", Colors.orange),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.testName,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              if (t.attempt != null)
                _pill("Attempt ${t.attempt}", Colors.blueGrey),
            ],
          ),
          const SizedBox(height: 8),
          _info(
            EvaIcons.calendar,
            t.date == null
                ? "Date not scheduled"
                : "${t.date!.day}-${t.date!.month}-${t.date!.year}",
          ),
          _info(EvaIcons.pin, t.rto),
        ],
      ),
    );
  }

  // ================= HISTORY =================
  Widget _buildHistory(TestController c) {
    final list = c.testsList.where((t) => t.status != 'pending').toList();

    if (list.isEmpty) {
      return Center(child: Text("No history", style: GoogleFonts.poppins()));
    }

    // Sort tests by date (most recent first)
    list.sort((a, b) => b.date?.compareTo(a.date ?? DateTime(2000)) ?? -1);

    // Group tests by testName and find the most recent failed test for each test type
    final Map<String, TestModel> lastFailedTests = {};

    for (final test in list) {
      if (test.passed == false) {
        // If this test type doesn't exist in map or if this test is more recent
        if (!lastFailedTests.containsKey(test.testName) ||
            (test.date?.isAfter(
                  lastFailedTests[test.testName]?.date ?? DateTime(2000),
                ) ??
                false)) {
          lastFailedTests[test.testName] = test;
        }
      }
    }

    return Column(
      children: list
          .map((test) => _historyCard(test, lastFailedTests))
          .toList(),
    );
  }

  Widget _historyCard(TestModel t, Map<String, TestModel> lastFailedTests) {
    final passed = t.passed == true;
    final color = passed ? Colors.green : Colors.red;

    // Check if this is the last failed test for this test type
    final isLastFailedTest = !passed && lastFailedTests[t.testName]?.id == t.id;

    // Show apply button if:
    // 1. It's a retest (regardless of position) OR
    // 2. It's the last failed test and not a retest
    final showApplyButton =
        t.isRetest || (!passed && isLastFailedTest && !t.isRetest);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _pill(passed ? "PASSED" : "FAILED", color),
              if (t.isRetest) const SizedBox(width: 8),
              if (t.isRetest) _pill("RETEST", Colors.orange),
              const Spacer(),
              if (t.attempt != null)
                _pill("Attempt ${t.attempt}", Colors.blueGrey),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            t.testName,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          _info(EvaIcons.pin, t.rto),
          if (t.date != null)
            _info(
              EvaIcons.calendar,
              "${t.date!.day}-${t.date!.month}-${t.date!.year}",
            ),

          // Show button based on the condition above
          if (showApplyButton) const SizedBox(height: 14),
          if (showApplyButton)
            ElevatedButton.icon(
              onPressed: () => _applyForRetest(t),
              icon: const Icon(Icons.refresh),
              label: Text(
                t.isRetest ? "Apply for Another Retest" : "Apply for Retest",
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
        ],
      ),
    );
  }

  // ================= COMMON =================
  Widget _pill(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: c.withOpacity(.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      t,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: c,
      ),
    ),
  );

  Widget _info(IconData i, String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Icon(i, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(t, style: GoogleFonts.poppins(fontSize: 13))),
      ],
    ),
  );

  Widget _sectionTitle(String t) => Text(
    t,
    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
  );
}
