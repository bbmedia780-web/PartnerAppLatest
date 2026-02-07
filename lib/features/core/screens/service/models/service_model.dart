class ServiceModel {
  final String id;
  final String serviceType;
  final String serviceName;
  final String description;
  final String imageUrl;
  final String status; // "Active" or "Inactive"
  final String loungeName;
  final String address;
  final String workingDays;
  final String workingHours;

  ServiceModel({
    required this.id,
    required this.serviceType,
    required this.serviceName,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.loungeName,
    required this.address,
    required this.workingDays,
    required this.workingHours,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      serviceType: json['serviceType'] ?? '',
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      status: json['status'] ?? 'Active',
      loungeName: json['loungeName'] ?? '',
      address: json['address'] ?? '',
      workingDays: json['workingDays'] ?? '',
      workingHours: json['workingHours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'serviceName': serviceName,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
      'loungeName': loungeName,
      'address': address,
      'workingDays': workingDays,
      'workingHours': workingHours,
    };
  }
}

