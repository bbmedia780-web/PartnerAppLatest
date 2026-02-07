class BookingModel {
  final String id;
  final String serviceProviderName;
  final String serviceProviderImage;
  final String serviceName;
  final String serviceType; // "Home Service" or "Parlour Service"
  final String price;
  final DateTime date;
  final BookingStatus status;

  BookingModel({
    required this.id,
    required this.serviceProviderName,
    required this.serviceProviderImage,
    required this.serviceName,
    required this.serviceType,
    required this.price,
    required this.date,
    required this.status,
  });

  // Factory constructor for creating from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      serviceProviderName: json['serviceProviderName'] ?? '',
      serviceProviderImage: json['serviceProviderImage'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceType: json['serviceType'] ?? '',
      price: json['price'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: BookingStatus.fromString(json['status'] ?? 'pending'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceProviderName': serviceProviderName,
      'serviceProviderImage': serviceProviderImage,
      'serviceName': serviceName,
      'serviceType': serviceType,
      'price': price,
      'date': date.toIso8601String(),
      'status': status.toString(),
    };
  }
}

enum BookingStatus {
  pending,
  approved,
  declined,
  completed,
  cancelled;

  static BookingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'approved':
        return BookingStatus.approved;
      case 'declined':
        return BookingStatus.declined;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }

  @override
  String toString() {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.approved:
        return 'approved';
      case BookingStatus.declined:
        return 'declined';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }
}

