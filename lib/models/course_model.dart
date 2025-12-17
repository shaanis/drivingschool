class CourseModel {
  String courseID;
  String courseName;
  int courseHours;
  int coursePrice;

  CourseModel({
    required this.courseID,
    required this.courseName,
    required this.courseHours,
    required this.coursePrice,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseID: map['courseID'],
      courseName: map['courseName'],
      courseHours: map['courseHours'],
      coursePrice: map['coursePrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'courseName': courseName,
      'courseHours': courseHours,
      'coursePrice': coursePrice,
    };
  }
}
