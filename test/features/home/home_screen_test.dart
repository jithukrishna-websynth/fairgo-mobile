import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('shows header, ride card, services, banner and nav', (t) async {
      await pumpApp(t, AppRoutes.home);
      expect(find.text('39/93, Annur Rd'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none), findsOneWidget);

      expect(find.text('Choose Your Ride'), findsOneWidget);
      expect(find.text('Ride'), findsOneWidget);
      expect(find.text('Share a Ride'), findsOneWidget);
      expect(find.text('START LOCATION'), findsOneWidget);
      expect(find.text('Your Current Location'), findsOneWidget);
      expect(find.text('YOUR DESTINATION'), findsOneWidget);
      expect(find.text('Aloha Cafe, 758B 5 Star Hotel'), findsOneWidget);
      expect(find.text('Book a Ride'), findsOneWidget);

      expect(find.text('Choose a service'), findsOneWidget);
      for (final s in [
        'Bike',
        'Auto',
        'Cab',
        'Parcel',
        'Cargo',
        'Book a Driver',
      ]) {
        expect(find.text(s), findsOneWidget);
      }
      expect(find.text('4 mins'), findsOneWidget);

      expect(find.text('S is arriving now'), findsOneWidget);
      for (final tab in ['Home', 'Bookings', 'Wallet', 'Account']) {
        expect(find.text(tab), findsOneWidget);
      }
    });

    testWidgets('Book a Ride opens Plan your ride', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      await t.tap(find.byKey(const Key('book_ride')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.planRide);
    });

    testWidgets('tapping the destination row opens Plan your ride', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      await t.tap(find.text('Aloha Cafe, 758B 5 Star Hotel'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.planRide);
    });
  });
}
