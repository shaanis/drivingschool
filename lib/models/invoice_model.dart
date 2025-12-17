class InvoiceModel {
  String invoiceId;
  String userId;
  String invoiceUserName;
  String invoiceCourseName;
  String invoiceDate;
  double invoicePrice;
  String dueDate;

  InvoiceModel({
    required this.invoiceId,
    required this.userId,
    required this.invoiceUserName,
    required this.invoiceCourseName,
    required this.invoiceDate,
    required this.invoicePrice,
    required this.dueDate,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      invoiceId: map['invoiceId'] ?? '', // Default empty string
      userId: map['userId'] ?? '',
      invoiceUserName: map['invoiceUserName'] ?? '',
      invoiceCourseName: map['invoiceCourseName'] ?? '',
      invoiceDate: map['invoiceDate'] ?? '',
      invoicePrice: (map['invoicePrice'] != null)
          ? (map['invoicePrice'] as num).toDouble()
          : 0.0,
      dueDate: map['dueDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'userId': userId,
      'invoiceUserName': invoiceUserName,
      'invoiceCourseName': invoiceCourseName,
      'invoiceDate': invoiceDate,
      'invoicePrice': invoicePrice,
      'dueDate': dueDate,
    };
  }
}
