class ContactModel {
  String contactID;
  String contactName;
  int contactNumber;

  ContactModel({
    required this.contactID,
    required this.contactName,
    required this.contactNumber,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      contactID: map['contactID'],
      contactName: map['contactName'],
      contactNumber: map['contactNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactID': contactID,
      'contactName': contactName,
      'contactNumber': contactNumber,
    };
  }
}
