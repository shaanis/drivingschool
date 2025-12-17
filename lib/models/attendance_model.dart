class AttendanceModel {
  String attID;
  String attDate;
  String attTime;
  String userID;
  String trainerName;

  AttendanceModel({
    required this.attID,
    required this.attDate,
    required this.attTime,
    required this.userID,
    required this.trainerName,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
        attID: map['attID'],
        attDate: map['attDate'],
        attTime: map['attTime'],
        userID: map['userID'],
        trainerName: map['trainerName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'attID': attID,
      'attDate': attDate,
      'attTime': attTime,
      'userID': userID,
      'trainerName': trainerName,
    };
  }
}


