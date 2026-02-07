import 'package:flutter/services.dart';

/// Custom validation constants
class ValidationStrings {
  static const String required = "required";
}

class Validators {
  /// Validates if field is required (empty)
  /// Returns "required" if empty, null if valid
  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationStrings.required;
    }
    return null;
  }

  /// Validates minimum length
  /// Returns "required" if empty, custom message if too short, null if valid
  static String? minLength(String? value, int length, {String message = "Too short"}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationStrings.required;
    }
    if (value.trim().length < length) {
      return message;
    }
    return null;
  }

  /// Validates maximum length
  /// Returns "required" if empty, custom message if too long, null if valid
  static String? maxLength(String? value, int length, {String message = "Too long"}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationStrings.required;
    }
    if (value.trim().length > length) {
      return message;
    }
    return null;
  }

  /// Validates if value contains only numbers
  /// Returns "required" if empty, error message if invalid, null if valid
  static String? numberOnly(String? value, {String fieldName = "Number"}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationStrings.required;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only numbers allowed";
    }
    return null;
  }

  /// Validates Aadhaar number (12 digits)
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validateAadhaar(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    final normalized = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\d{12}$').hasMatch(normalized)) {
      return 'Enter a valid 12-digit Aadhaar number';
    }
    return null;
  }

  /// Validates Mobile number (10 digits)
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    final normalized = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\d{10}$').hasMatch(normalized)) {
      return 'Enter a valid 10-digit Mobile number';
    }
    return null;
  }

  /// Validates PAN number
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validatePan(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    final pan = value.toUpperCase().trim();
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(pan)) {
      return 'Enter a valid PAN (e.g. ABCDE1234F)';
    }
    return null;
  }

  /// Validates GST number
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validateGSTNo(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    final gst = value.toUpperCase().trim();
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(gst)) {
      return 'Enter a valid GST (e.g. 24AANCB6494K1Z3)';
    }
    return null;
  }

  /// Validates Account Holder name
  /// Returns "required" if empty, error message if too short, null if valid
  String? validateAccountHolder(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    if (value.trim().length < 2) return 'Enter a valid name';
    return null;
  }

  /// Validates Account Number (6-18 digits)
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    final normalized = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9]{6,18}$').hasMatch(normalized)) {
      return 'Enter a valid account number (6-18 digits)';
    }
    return null;
  }

  /// Validates IFSC code
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validateIfsc(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    final ifsc = value.toUpperCase().trim();
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
      return 'Enter a valid IFSC (e.g. SBIN0001234)';
    }
    return null;
  }

  /// Validates Bank Name
  /// Returns "required" if empty, null if valid
  String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    return null;
  }

  /// Validates Email
  /// Returns "required" if empty, error message if invalid format, null if valid
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationStrings.required;
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}