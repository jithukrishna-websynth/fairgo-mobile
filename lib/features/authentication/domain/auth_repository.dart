abstract interface class AuthRepository {
  Future<void> sendOtp(String phoneNumber);

  /// Returns true when the OTP is accepted.
  Future<bool> verifyOtp(String phoneNumber, String otp);
}
