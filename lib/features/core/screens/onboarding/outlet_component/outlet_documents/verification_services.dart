import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../../../model/verification_res_model.dart';

// IMPORTANT: Replace this with your actual backend API endpoint
const String _BASE_URL = 'YOUR_BACKEND_SERVER_URL/api/cashfree';

class VerificationService {
  // You'll need an Authorization Token or similar for your backend
  static const String _baseUrl = 'https://api.cashfree.com/verification/v2'; // Production: 'https://api.cashfree.com/verification'
  static const String _clientId = 'CF1090555D4S083QS1TNS73FVVH00';
  static const String _clientSecret = 'cfsk_ma_prod_074230ca84927ac6c8d032a92d94b4a6_e031fa76';

  static Map<String, String> _getHeaders() {
    return {
      'x-client-id': _clientId,
      'x-client-secret': _clientSecret,
      'x-api-version': '2025-12-01',
      'Content-Type': 'application/json',
    };
  }
   Future<VerificationResponse> verifyAadhaar(String aadhaarNumber) {
    // New endpoint path for generating OTP (Step 1)
    return verifyDocument('aadhaar/generateOtp', {'aadhaar_number': aadhaarNumber});
    // This resolves to: https://api.cashfree.com/verification/v2/aadhaar/generateOtp
  }
  static Future<Map<String, dynamic>?> generateAadhaarOTP(String aadhaarNumber, String mobileNumber) async {
    final verificationId = const Uuid().v4();
    final body = jsonEncode({
      'aadhaar_number': aadhaarNumber,
      'mobile_number': mobileNumber,
      'verification_id': verificationId,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/aadhaar/generateOtp'),
      headers: _getHeaders(),
      body: body,
    );

    print('URL - $_baseUrl/aadhaar/generateOtp\n Headers : ${_getHeaders()}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns reference_id, status, etc.
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  // Aadhaar OTP: Verify with OTP
  static Future<Map<String, dynamic>?> verifyAadhaarOTP(String verificationId, String otp, int referenceId) async {
    final body = jsonEncode({
      'otp': otp,
      'reference_id': referenceId,
      'verification_id': verificationId,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/aadhaar/verify'),
      headers: _getHeaders(),
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns verified details like name, dob, etc.
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }






  Future<VerificationResponse> verifyDocument(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$_BASE_URL/$endpoint');
    try {
      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return VerificationResponse.fromJson(endpoint, responseBody);
      } else {
        // Handle non-200 status codes (e.g., 400, 500)
        return VerificationResponse(
          documentType: endpoint,
          status: 'ERROR',
          message: 'Server Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return VerificationResponse(
        documentType: endpoint,
        status: 'ERROR',
        message: 'Network/Unknown Error: $e',
      );
    }
  }

  // --- Cashfree API Wrappers (Your Backend Endpoints) ---


  Future<VerificationResponse> verifyPan(String panNumber) {
    return verifyDocument('pan-verify', {'pan_number': panNumber});
  }

  Future<VerificationResponse> verifyGstin(String gstinNumber) {
    return verifyDocument('gstin-verify', {'gstin_number': gstinNumber});
  }

  Future<VerificationResponse> verifyBank(String accNumber, String ifsc, String accName) {
    return verifyDocument('bank-verify', {
      'account_number': accNumber,
      'ifsc_code': ifsc,
      'account_holder_name': accName,
    });
  }
}

// **NOTE: You must implement the corresponding endpoints on your backend server.**
// For example, the 'aadhaar-verify' endpoint would receive the aadhaar_number,
// call the Cashfree Aadhaar Verification API using your Client ID/Secret, and
// return a simplified response to the Flutter app.