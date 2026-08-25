class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name should only contain letters and spaces';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateId(String? value, String type) {
    if (value == null || value.isEmpty) {
      return '$type ID is required';
    }

    if (value.length < 3) {
      return '$type ID must be at least 3 characters long';
    }

    return null;
  }

  static String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle number is required';
    }

    // Example format: ABC-1234 or AB 123 CD
    final vehicleRegex = RegExp(r'^[a-zA-Z0-9\s-]{5,15}$');
    if (!vehicleRegex.hasMatch(value)) {
      return 'Please enter a valid vehicle number';
    }

    return null;
  }

  static String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'License number is required';
    }

    if (value.length < 5) {
      return 'License number is too short';
    }

    return null;
  }

  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return 'Start date is required';
    }

    if (endDate == null) {
      return 'End date is required';
    }

    if (endDate.isBefore(startDate)) {
      return 'End date cannot be before start date';
    }

    return null;
  }

  static String? validateDriverNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Truck number is required';
    }

    if (value.length < 3) {
      return 'Truck number must be at least 3 characters';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    return validateEmail(email) == null;
  }

  static bool isValidPassword(String password) {
    return validatePassword(password) == null;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    return validatePhoneNumber(phoneNumber) == null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      return 'Mobile number must be 10 digits';
    }

    final mobileRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!mobileRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Please enter a valid mobile number';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP code is required';
    }

    if (value.length != 4) {
      return 'OTP must be 4 digits';
    }

    if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }

    return null;
  }
}
