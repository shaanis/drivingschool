class InstructorModel {
  String instructorID;
  String instructorName;
  int instructorNumber;
  String? instructorProPic;

  InstructorModel({
    required this.instructorID,
    required this.instructorName,
    required this.instructorNumber,
    this.instructorProPic,
  });

  factory InstructorModel.fromMap(Map<String, dynamic> map) {
    return InstructorModel(
      instructorID: map['instructorID'],
      instructorName: map['instructorName'],
      instructorNumber: map['instructorNumber'],
      instructorProPic: map['instructorProPic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instructorID': instructorID,
      'instructorName': instructorName,
      'instructorNumber': instructorNumber,
      'instructorProPic': instructorProPic,
    };
  }
}
