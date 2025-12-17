import 'package:cloud_firestore/cloud_firestore.dart';

class TestModel {
  final String id;
  final String studentId;
  final String studentName;
  final String testName;
  final String rto;

  final DateTime? date; // ✅ nullable
  final bool? passed;
  final String status;

  final int? attempt;
  final bool isRetest;
  final String parentTestId;

  TestModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.testName,
    required this.rto,
    required this.date,
    required this.passed,
    required this.status,
    required this.attempt,
    required this.isRetest,
    required this.parentTestId,
  });

  /// Firestore → Dart
  factory TestModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return TestModel(
      id: doc.id,
      studentId: data['studentId'],
      studentName: data['studentName'] ?? '',
      testName: data['testName'] ?? '',
      rto: data['rto'] ?? '',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      passed: data['passed'],
      status: data['status'] ?? 'pending',
      attempt: data['attempt'],
      isRetest: data['isRetest'] ?? false,
      parentTestId: data['parentTestId'] ?? '',
    );
  }

  /// Dart → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'testName': testName,
      'rto': rto,
      if (date != null) 'date': Timestamp.fromDate(date!), // ✅ only if exists
      'passed': passed,
      'status': status,
      'attempt': attempt,
      'isRetest': isRetest,
      'parentTestId': parentTestId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  TestModel copyWith({DateTime? date, bool? passed, String? status}) {
    return TestModel(
      id: id,
      studentId: studentId,
      studentName: studentName,
      testName: testName,
      rto: rto,
      date: date ?? this.date,
      passed: passed ?? this.passed,
      status: status ?? this.status,
      attempt: attempt,
      isRetest: isRetest,
      parentTestId: parentTestId,
    );
  }
}
