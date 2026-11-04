import '../domain/auth_repository.dart';

/// DEMO ONLY: no OTP is sent. Replace with a real backend implementation.
/// Accepts [demoOtp] for any number.
class DemoAuthRepository implements AuthRepository {
  static const demoOtp = '123456';

  @override
  Future<void> sendOtp(String phoneNumber) =>
      Future<void>.delayed(const Duration(milliseconds: 600));

  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return otp == demoOtp;
  }
}
