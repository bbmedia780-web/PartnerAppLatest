class PaymentModel {
  final String id;
  final String customerName;
  final String customerImage;
  final DateTime date;
  final PaymentStatus status;
  final PaymentMode mode;
  final String amount;

  PaymentModel({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.date,
    required this.status,
    required this.mode,
    required this.amount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      customerImage: json['customerImage'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: PaymentStatus.fromString(json['status'] ?? 'pending'),
      mode: PaymentMode.fromString(json['mode'] ?? 'cash'),
      amount: json['amount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerImage': customerImage,
      'date': date.toIso8601String(),
      'status': status.toString(),
      'mode': mode.toString(),
      'amount': amount,
    };
  }
}

enum PaymentStatus {
  pending,
  complete,
  failed;

  static PaymentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'complete':
        return PaymentStatus.complete;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending;
    }
  }

  @override
  String toString() {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.complete:
        return 'Complete';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }
}

enum PaymentMode {
  cash,
  card,
  upi,
  wallet;

  static PaymentMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cash':
        return PaymentMode.cash;
      case 'card':
        return PaymentMode.card;
      case 'upi':
        return PaymentMode.upi;
      case 'wallet':
        return PaymentMode.wallet;
      default:
        return PaymentMode.cash;
    }
  }

  @override
  String toString() {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.card:
        return 'Card';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.wallet:
        return 'Wallet';
    }
  }
}

