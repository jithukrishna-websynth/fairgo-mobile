import 'package:fair_go/core/widgets/fair_go_logo.dart';
import 'package:fair_go/app/app.dart';
import 'package:fair_go/features/authentication/data/demo_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash through profile setup', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FairGoApp()));
    expect(find.byType(FairGoLogo), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Swipe to Get Started'), findsOneWidget);

    // A short swipe springs back and stays on the welcome screen.
    await tester.drag(
      find.byKey(const Key('swipe_thumb')),
      const Offset(150, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Swipe to Get Started'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('swipe_thumb')),
      const Offset(700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Select Your Language'), findsOneWidget);

    await tester.tap(find.byKey(const Key('language_hi')));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Invalid number is rejected.
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your mobile number'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('phone_field')), '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    expect(find.text('Verify OTP'), findsOneWidget);

    // Wrong OTP shows an error; the demo OTP proceeds.
    await tester.enterText(find.byKey(const Key('otp_field')), '000000');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect OTP. Please try again.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('otp_field')),
      DemoAuthRepository.demoOtp,
    );
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
    expect(find.text('Tell us about yourself'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('name_field')), 'Rahul');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a service'), findsOneWidget);
  });
}
