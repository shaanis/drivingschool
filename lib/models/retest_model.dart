class RetestRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String testName;
  final int originalScore;
  final DateTime requestDate;
  final String status;
  final String reason;
  final DateTime preferredDate;

  RetestRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.testName,
    required this.originalScore,
    required this.requestDate,
    required this.status,
    required this.reason,
    required this.preferredDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'testName': testName,
      'originalScore': originalScore,
      'requestDate': requestDate,
      'status': status,
      'reason': reason,
      'preferredDate': preferredDate,
    };
  }

  RetestRequest copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? testName,
    int? originalScore,
    DateTime? requestDate,
    String? status,
    String? reason,
    DateTime? preferredDate,
  }) {
    return RetestRequest(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      testName: testName ?? this.testName,
      originalScore: originalScore ?? this.originalScore,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      preferredDate: preferredDate ?? this.preferredDate,
    );
  }
}
