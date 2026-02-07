class VerificationResponse {
  final String documentType;
  final String status; // E.g., 'SUCCESS', 'INVALID', 'ERROR'
  final String message; // Human-readable message
  final Map<String, dynamic>? verificationData; // E.g., nameAtBank, panName, etc.

  VerificationResponse({
    required this.documentType,
    required this.status,
    required this.message,
    this.verificationData,
  });

  factory VerificationResponse.fromJson(String documentType, Map<String, dynamic> json) {
    // This assumes a standardized response format from your backend.
    return VerificationResponse(
      documentType: documentType,
      status: json['status'] ?? 'ERROR',
      message: json['message'] ?? 'Unknown error',
      verificationData: json['data'],
    );
  }
}