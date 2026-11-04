import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Color _starColor(WidgetTester t, int i) => t
    .widget<Icon>(
      find.descendant(
        of: find.byKey(Key('star_$i')),
        matching: find.byType(Icon),
      ),
    )
    .color!;

void main() {
  group('TripCompletedScreen', () {
    testWidgets('shows the fare summary', (t) async {
      await pumpApp(t, AppRoutes.tripCompleted);
      expect(find.text('Trip Completed'), findsOneWidget);
      expect(find.text('Thank you for choosing Fairgo!'), findsOneWidget);
      expect(find.text('₹120'), findsOneWidget);
      expect(find.text('Total Fare'), findsOneWidget);
      expect(find.text('₹60'), findsOneWidget);
      expect(find.text('(Shared Ride)'), findsOneWidget);
      expect(find.text('You saved ₹60'), findsNothing);
      expect(find.text('How was your ride?'), findsOneWidget);
      expect(find.text('Share your experience (optional)'), findsOneWidget);
    });

    testWidgets('tapping a star rates up to that star', (t) async {
      await pumpApp(t, AppRoutes.tripCompleted);
      const grey = Color(0xFFD9D9D9);
      for (var i = 1; i <= 5; i++) {
        expect(_starColor(t, i), grey);
      }
      await t.tap(find.byKey(const Key('star_3')));
      await t.pump();
      expect(_starColor(t, 1), isNot(grey));
      expect(_starColor(t, 3), isNot(grey));
      expect(_starColor(t, 4), grey);

      await t.tap(find.byKey(const Key('star_1')));
      await t.pump();
      expect(_starColor(t, 2), grey);
    });

    testWidgets('feedback is optional and accepts text', (t) async {
      await pumpApp(t, AppRoutes.tripCompleted);
      await t.enterText(find.byKey(const Key('feedback_field')), 'Great ride');
      expect(find.text('Great ride'), findsOneWidget);
    });

    testWidgets('Payment and Trip Details navigate', (t) async {
      final router = await pumpApp(t, AppRoutes.tripCompleted);
      await t.tap(find.byKey(const Key('trip_details_row')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.tripReceipt);

      await t.tap(find.byIcon(Icons.chevron_left).first);
      await t.pumpAndSettle();
      await t.tap(find.text('Payment'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.payment);
    });
  });

  group('Trip stack', () {
    testWidgets('Back from Trip Completed does not return to booking', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.pickupSpot);
      await t.tap(find.text('Confirm pickup'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text('Ride requested'), findsOneWidget);

      await t.pump(const Duration(seconds: 4));
      await t.pumpAndSettle();
      await t.pump(const Duration(seconds: 8));
      await t.pumpAndSettle();
      await t.pump(const Duration(seconds: 30));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.tripCompleted);

      await t.tap(find.byIcon(Icons.chevron_left).first);
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
      await disposeApp(t);
    });
  });

  group('PaymentScreen', () {
    testWidgets('shows fare, wallet and five methods', (t) async {
      await pumpApp(t, AppRoutes.payment);
      expect(find.text('Payment'), findsOneWidget);
      expect(find.text('Safe. Simple. Flexible.'), findsOneWidget);
      expect(find.text('₹120'), findsOneWidget);
      expect(find.text('Trip Fare'), findsOneWidget);
      expect(find.text('Use Wallet Balance'), findsOneWidget);
      expect(find.text('₹200 available'), findsOneWidget);
      for (final m in [
        'UPI (GPay)',
        'PhonePe',
        'Credit / Debit Card',
        'Cash',
      ]) {
        expect(find.text(m), findsOneWidget);
      }
      // Paytm shows twice: its text logo and its name.
      expect(find.text('Paytm'), findsNWidgets(2));
      expect(find.text('Add New Payment Method'), findsOneWidget);
      expect(find.text('Pay ₹120'), findsOneWidget);
      expect(find.text('Your payments are secure'), findsOneWidget);
    });

    testWidgets('exactly one method is selected and it can change', (t) async {
      await pumpApp(t, AppRoutes.payment);
      Finder checkIn(String id) => find.descendant(
        of: find.byKey(Key('method_$id')),
        matching: find.byIcon(Icons.check),
      );
      expect(checkIn('gpay'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      await t.tap(find.byKey(const Key('method_paytm')));
      await t.pump();
      expect(checkIn('paytm'), findsOneWidget);
      expect(checkIn('gpay'), findsNothing);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('the wallet switch toggles', (t) async {
      await pumpApp(t, AppRoutes.payment);
      bool value() =>
          t.widget<Switch>(find.byKey(const Key('wallet_switch'))).value;
      expect(value(), isTrue);
      await t.tap(find.byKey(const Key('wallet_switch')));
      await t.pump();
      expect(value(), isFalse);
    });

    testWidgets('the chosen method appears on the receipt', (t) async {
      await pumpApp(t, AppRoutes.payment);
      await t.tap(find.byKey(const Key('method_cash')));
      await t.pump();
      await t.tap(find.text('Pay ₹120'));
      await t.pumpAndSettle();
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('UPI (GPay)'), findsNothing);
    });

    testWidgets('Pay opens the receipt', (t) async {
      final router = await pumpApp(t, AppRoutes.payment);
      await t.tap(find.text('Pay ₹120'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.tripReceipt);
    });
  });

  group('TripReceiptScreen', () {
    testWidgets('shows the receipt details', (t) async {
      await pumpApp(t, AppRoutes.tripReceipt);
      expect(find.text('Trip Details'), findsOneWidget);
      expect(find.text('12 Jan 2026, 09:42 AM'), findsOneWidget);
      expect(find.text('Shared Ride'), findsOneWidget);
      expect(find.text('Fare Details'), findsOneWidget);
      expect(find.text('Total Fare'), findsOneWidget);
      expect(find.text('Your Share'), findsOneWidget);
      expect(find.text('Saved Amount'), findsOneWidget);
      expect(find.text('- ₹60'), findsOneWidget);
      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('UPI (GPay)'), findsOneWidget);
      expect(find.text('Download Invoice'), findsOneWidget);
      expect(find.text('GST compliant invoice'), findsOneWidget);
      expect(find.text('Get Help'), findsOneWidget);
    });

    testWidgets('Book a New Ride returns Home', (t) async {
      final router = await pumpApp(t, AppRoutes.tripReceipt);
      await t.tap(find.text('Book a New Ride'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });
  });
}
