import 'dart:convert';
import 'package:http/http.dart' as http;

class CashfreeKycService {
  // Production Cashfree API credentials
  static const String _baseUrl = 'https://api.cashfree.com/verification';
  static const String _clientId = 'CF1090555D4S083QS1TNS73FVVH00';
  static const String _clientSecret = 'cfsk_ma_prod_074230ca84927ac6c8d032a92d94b4a6_e031fa76';
  static const String _apiVersion = '2025-12-10';

  // Sendbox
  // static const String _baseUrl = 'https://sandbox.cashfree.com/verification';
  // static const String _clientId = 'CF10822448D4SGM8K5Q4SS7385O16G';
  // static const String _clientSecret = 'cfsk_ma_test_3bc392cbdaf71e46b271eb02c7251080_42348fde';
  // static const String _apiVersion = '2025-12-10';

  // prod
  static Map<String, String> _getHeaders() {
    return {
      'x-client-id': _clientId,
      'x-client-secret': _clientSecret,
      'x-api-version': _apiVersion,
      'Content-Type': 'application/json',
    };
  }
  // send box
  // static Map<String, String> _getHeaders() {
  //   return {
  //     "x-client-id": _clientId,
  //     "x-client-secret": _clientSecret,
  //     "x-api-version": "2023-03-01",
  //     "Content-Type": "application/json"
  //   };
  // }

  // Aadhaar OTP Generation
  Future<Map<String, dynamic>?> generateAadhaarOTP({
    required String aadhaarNumber,
  }) async {
    try {
      final body = jsonEncode({
        "aadhaar_number": aadhaarNumber,
        "consent": "Y",
        "consent_text": "I hereby declare that I am providing my Aadhaar voluntarily",
      });

      // print('URL - $_baseUrl/offline-aadhaar/otp');
      // print('Request - $body');
      final response = await http.post(
        Uri.parse('$_baseUrl/offline-aadhaar/otp'),
        headers: {
          'Content-Type': 'application/json',
          'x-client-id': _clientId,
          'x-client-secret': _clientSecret,
          // include x-cf-signature only if required by your account’s 2FA/Pub-key setup
        },
        body: body,
      );
      // print('Response - $response');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'reference_id': data['ref_id'],
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to generate OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }


  // Aadhaar OTP Verification
  Future<Map<String, dynamic>?> verifyAadhaarOTP({
    required String otp,
    required int referenceId,
  }) async {
    try {
      final body = jsonEncode({
        'ref_id': referenceId.toString(),
        'otp': otp,
      });
      // print('URL - $_baseUrl/offline-aadhaar/verify');
      // print('Request - $body');
      final response = await http.post(
        Uri.parse('$_baseUrl/offline-aadhaar/verify'),
        headers: {
          'Content-Type': 'application/json',
          'x-client-id': _clientId,
          'x-client-secret': _clientSecret,
        },
        body: body,
      );
      // print('Response - $response');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Aadhaar verified successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'OTP verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }


  // PAN Verification
  Future<Map<String, dynamic>?> verifyPAN(String panNumber) async {
    try {
      final body = jsonEncode({
        'pan': panNumber,
      });

        // print('URL - $_baseUrl/pan');
        // print('Request - $body');
      final response = await http.post(
        Uri.parse('$_baseUrl/pan'),
        headers: _getHeaders(),
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('Data -- > ${data}');
        if(data['pan_status']=="VALID"){
          return {
            'success': true,
            'data': data,
            'message': 'PAN verified successfully',
          };
        }else{
          return {
            'success': false,
            'data': data,
            'message': 'PAN verified Failed',
          };
        }

      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'PAN verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // GSTIN Verification
  Future<Map<String, dynamic>?> verifyGSTIN(String gstin) async {
    try {
      final body = jsonEncode({
        'gstin': gstin,
      });
       final response = await http.post(
        Uri.parse('$_baseUrl/gstin'),
        headers: _getHeaders(),
        body: body,
      );
      // print('Response :${response}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('data :${data}');
        return {
          'success': true,
          'data': data,
          'message': 'GSTIN verified successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'GSTIN verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Bank Account Verification (Penny Drop)
  Future<Map<String, dynamic>?> verifyBankAccount({
    required String accountNumber,
    required String ifscCode,
    required String accountHolderName,
  }) async {
    try {
      final body = jsonEncode({
        'bank_account': accountNumber,
        'ifsc': ifscCode,
        'name': accountHolderName,
      });
      // print('URL - $_baseUrl/bank-account/sync');
      // print('Request - $body');
      final response = await http.post(
        Uri.parse('$_baseUrl/bank-account/sync'),
        headers: _getHeaders(),
        body: body,
      );

      // print('Response : ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("Data : ${data}");
        if(data['account_status']=="VALID"){
          return {
            'success': true,
            'data': data,
            'message': 'Bank account verified successfully',
          };
        }else{
          final error = jsonDecode(response.body);
          return {
            'success': false,
            'message': error['message'] ?? 'Bank verification failed',
          };
        }

      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Bank verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}

