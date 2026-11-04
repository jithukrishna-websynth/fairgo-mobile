abstract final class Validators {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Indian mobile numbers: 10 digits starting with 6-9. Spaces are ignored.
  static String? phone(String? value) {
    final digits = (value ?? '').replaceAll(' ', '');
    if (digits.isEmpty) return 'Enter your mobile number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Enter the 6-digit OTP';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().length < 2) return 'Enter your name';
    return null;
  }

  /// Email is optional: empty is valid.
  static String? optionalEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    return _email.hasMatch(v) ? null : 'Enter a valid email address';
  }
}
