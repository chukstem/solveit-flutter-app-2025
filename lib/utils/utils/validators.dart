class Validator {
  /// Validates a password with a minimum length of 8 characters.
  static String? password(String? value, {String message = 'Enter password'}) {
    if (value == null || value.isEmpty) return message;
    if (value.length < 7) {
      return 'Password should be at least 8 characters long';
    }

    return null;
  }

  /// Validates if the confirm password matches the original password.
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return "Enter confirm password";
    if (value != password) return "Passwords do not match";

    return null;
  }

  /// Validates if a field is not empty.
  static String? emptyField(String? value,
      {String message = 'Field cannot be empty'}) {
    return (value == null || value.isEmpty) ? message : null;
  }

  /// Validates a phone number format.
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return "Enter phone number";
    final regex = RegExp(r'^[+]?[0-9]{7,15}$'); // General phone number pattern
    if (value.length < 11) return "Phone number should be 11 digits";

    return regex.hasMatch(value) ? null : 'Enter a valid phone number';
  }

  /// Validates a 4-digit PIN.
  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length != 4) return 'PIN must be exactly 4 digits';

    return null;
  }

  /// Validates an email address format.
  static String? emailValidator(String? value, {bool optional = false}) {
    if (value == null || value.isEmpty) {
      return optional ? null : 'Field cannot be blank';
    }

    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(value) ? null : 'Enter a valid email address';
  }

  /// Parses API errors from a map.
  static String parseUnprocessedEntityError(Map<dynamic, dynamic> map) {
    return map.values.join('\n');
  }

  /// Validates a bank account number (NUBAN - Nigeria, 10 digits).
  static String? validateBankAccountNumber(String? input) {
    if (input == null || input.isEmpty) return 'Field is required';
    if (!isNumber(input)) return 'Invalid bank account number';

    return length(input,
        length: 10, message: 'Invalid Bank Account Number (NUBAN)');
  }

  /// Validates either an email or phone number.
  static String? emailOrPhoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be blank';
    if (emailValidator(value) == null || validatePhoneNumber(value) == null) {
      return null;
    }

    return "Not a valid phone number or email";
  }

  /// Validates a phone number.
  static String? validatePhoneNumber(String? value) {
    return phone(value);
  }

  /// Validates a National Identification Number (NIN) format (11 digits).
  static String? validateNIN(String? value) {
    if (value == null || value.isEmpty) return "Field cannot be empty";
    if (value.length == 11 && RegExp(r'^\d{11}$').hasMatch(value)) return null;

    return 'Enter a valid NIN';
  }

  /// Ensures a string has a specific length.
  static String? length(String input, {required int length, String? message}) {
    return input.length == length
        ? null
        : (message ?? 'Should be $length characters');
  }

  /// Checks if a given string is a valid number.
  static bool isNumber(String input) {
    return double.tryParse(input) != null;
  }
}
