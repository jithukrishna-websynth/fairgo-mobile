import 'package:fair_go/app/router/app_routes.dart';
import 'package:fair_go/features/authentication/data/demo_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('PhoneLoginScreen', () {
    testWidgets('renders the form and social options', (t) async {
      await pumpApp(t, AppRoutes.login);
      expect(find.text('Enter Your Mobile Number'), findsOneWidget);
      expect(find.text('+91'), findsNothing); // prefix is "🇮🇳  +91"
      expect(find.textContaining('+91'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('empty and invalid numbers show errors', (t) async {
      final router = await pumpApp(t, AppRoutes.login);
      await t.tap(find.text('Send OTP'));
      await t.pumpAndSettle();
      expect(find.text('Enter your mobile number'), findsOneWidget);

      await t.enterText(find.byKey(const Key('phone_field')), '12345');
      await t.tap(find.text('Send OTP'));
      await t.pumpAndSettle();
      expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
      expect(locationOf(router), AppRoutes.login);
    });

    testWidgets('only digits are accepted, max 10', (t) async {
      await pumpApp(t, AppRoutes.login);
      await t.enterText(find.byKey(const Key('phone_field')), '98a76-54321099');
      await t.pump();
      final field = t.widget<TextFormField>(
        find.byKey(const Key('phone_field')),
      );
      expect(field.controller!.text, '9876543210');
    });

    testWidgets('consent is required', (t) async {
      final router = await pumpApp(t, AppRoutes.login);
      await t.enterText(find.byKey(const Key('phone_field')), '9876543210');
      await t.tap(find.byKey(const Key('consent_checkbox')));
      await t.pump();
      await t.tap(find.text('Send OTP'));
      await t.pumpAndSettle();
      expect(find.text('Please accept the terms to continue'), findsOneWidget);
      expect(locationOf(router), AppRoutes.login);
    });

    testWidgets('valid number opens the OTP screen with the number', (t) async {
      final router = await pumpApp(t, AppRoutes.login);
      await t.enterText(find.byKey(const Key('phone_field')), '9876543210');
      await t.tap(find.text('Send OTP'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.otp);
      expect(find.textContaining('+91 98765 43210'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('social buttons say they are not configured', (t) async {
      await pumpApp(t, AppRoutes.login);
      await t.tap(find.text('Continue with Google'));
      await t.pump();
      expect(
        find.text('Google sign-in is not configured yet.'),
        findsOneWidget,
      );
    });
  });

  group('OtpScreen', () {
    const route = '${AppRoutes.otp}?phone=9876543210';

    testWidgets('shows the number and a resend countdown', (t) async {
      await pumpApp(t, route);
      expect(find.text('Verify OTP'), findsOneWidget);
      expect(find.textContaining('+91 98765 43210'), findsOneWidget);
      expect(find.text('Resend in 0:24'), findsOneWidget);

      await t.pump(const Duration(seconds: 5));
      expect(find.text('Resend in 0:19'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('Resend appears when the countdown ends and restarts it', (
      t,
    ) async {
      await pumpApp(t, route);
      await t.pump(const Duration(seconds: 25));
      expect(find.byKey(const Key('resend_otp')), findsOneWidget);

      await t.tap(find.byKey(const Key('resend_otp')));
      await t.pump(const Duration(seconds: 1));
      expect(find.textContaining('Resend in'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('verify with fewer than 6 digits shows an error', (t) async {
      await pumpApp(t, route);
      await t.enterText(find.byKey(const Key('otp_field')), '123');
      await t.tap(find.text('Verify'));
      await t.pump();
      expect(find.text('Enter the 6-digit OTP'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('wrong OTP shows an error, right OTP continues', (t) async {
      final router = await pumpApp(t, route);
      await t.enterText(find.byKey(const Key('otp_field')), '000000');
      await t.tap(find.text('Verify'));
      await t.pumpAndSettle(const Duration(milliseconds: 100));
      expect(find.text('Incorrect OTP. Please try again.'), findsOneWidget);

      await t.enterText(
        find.byKey(const Key('otp_field')),
        DemoAuthRepository.demoOtp,
      );
      await t.pump();
      expect(find.text('Incorrect OTP. Please try again.'), findsNothing);
      await t.tap(find.text('Verify'));
      await t.pumpAndSettle(const Duration(milliseconds: 100));
      expect(locationOf(router), AppRoutes.profile);
      await disposeApp(t);
    });

    testWidgets('OTP field accepts digits only, max 6', (t) async {
      await pumpApp(t, route);
      await t.enterText(find.byKey(const Key('otp_field')), '12ab3456789');
      await t.pump();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('7'), findsNothing);
      await disposeApp(t);
    });
  });
}
