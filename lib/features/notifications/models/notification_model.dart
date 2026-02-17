class CustomNotification {
  final int id;
  final int transactionId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  CustomNotification({
    required this.id,
    required this.transactionId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory CustomNotification.fromJson(Map<String, dynamic> json) {
    return CustomNotification(
      id: json['id'],
      transactionId: json['transaction_id'],
      message: json['message'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}