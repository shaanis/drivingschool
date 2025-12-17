import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivingschool/models/user_test_model.dart';
import 'package:flutter/material.dart';

class TestController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  List<TestModel> testsList = [];

  /// ============================================================
  /// ADD TEST (FIRST ATTEMPT – DATE REQUIRED)
  /// ============================================================
  Future<void> addTest({
    required String studentId,
    required String studentName,
    required String testName,
    required String rto,
    required DateTime date,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final doc = _firestore.collection('tests').doc();

      final model = TestModel(
        id: doc.id,
        studentId: studentId,
        studentName: studentName,
        testName: testName,
        rto: rto,
        date: date,
        passed: null,
        status: 'pending',
        attempt: 1,
        isRetest: false,
        parentTestId: '',
      );

      await doc.set(model.toFirestore());

      if (context != null) Navigator.pop(context);
    } catch (e) {
      debugPrint('❌ Add test error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================================================
  /// APPLY RETEST (❌ NO DATE SAVED)
  /// ============================================================
  Future<void> applyRetest(TestModel failedTest) async {
    try {
      isLoading = true;
      notifyListeners();

      final doc = _firestore.collection('tests').doc();

      final retest = TestModel(
        id: doc.id,
        studentId: failedTest.studentId,
        studentName: failedTest.studentName,
        testName: failedTest.testName,
        rto: failedTest.rto,
        date: null, // 🔥 ADMIN WILL SET LATER
        passed: null,
        status: 'pending',
        attempt: (failedTest.attempt ?? 1) + 1,
        isRetest: true,
        parentTestId: failedTest.parentTestId.isEmpty
            ? failedTest.id
            : failedTest.parentTestId,
      );

      await doc.set(retest.toFirestore());
    } catch (e) {
      debugPrint('❌ Retest error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================================================
  /// FETCH ALL TESTS
  /// ============================================================
  Future<void> fetchAllTests() async {
    try {
      isLoading = true;
      testsList.clear();
      notifyListeners();

      final snapshot = await _firestore
          .collection('tests')
          .orderBy('createdAt', descending: true)
          .get();

      testsList = snapshot.docs.map((e) => TestModel.fromFirestore(e)).toList();
    } catch (e) {
      debugPrint('❌ Fetch tests error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================================================
  /// FETCH TESTS BY STUDENT
  /// ============================================================
  Future<void> fetchTestsByStudent(String studentId) async {
    try {
      isLoading = true;
      testsList.clear();
      notifyListeners();

      final snapshot = await _firestore
          .collection('tests')
          .where('studentId', isEqualTo: studentId)
          .orderBy('createdAt', descending: true)
          .get();

      testsList = snapshot.docs.map((e) => TestModel.fromFirestore(e)).toList();
    } catch (e) {
      debugPrint('❌ Student tests error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================================================
  /// UPDATE RESULT (PASS / FAIL)
  /// ============================================================
  Future<void> updateTestResult({
    required String testId,
    required bool passed,
  }) async {
    try {
      final status = passed ? 'passed' : 'failed';

      await _firestore.collection('tests').doc(testId).update({
        'passed': passed,
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final index = testsList.indexWhere((t) => t.id == testId);
      if (index != -1) {
        testsList[index] = testsList[index].copyWith(
          passed: passed,
          status: status,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Update result error: $e');
    }
  }

  /// ============================================================
  /// ADMIN SET / UPDATE TEST DATE (FOR RETEST)
  /// ============================================================
  Future<void> updateTestDate({
    required String testId,
    required DateTime date,
  }) async {
    try {
      await _firestore.collection('tests').doc(testId).update({
        'date': date,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final index = testsList.indexWhere((t) => t.id == testId);
      if (index != -1) {
        testsList[index] = testsList[index].copyWith(date: date);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Update test date error: $e');
    }
  }

  /// ============================================================
  /// DELETE TEST
  /// ============================================================
  Future<void> deleteTest(String testId) async {
    try {
      await _firestore.collection('tests').doc(testId).delete();
      testsList.removeWhere((t) => t.id == testId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Delete test error: $e');
    }
  }
}
