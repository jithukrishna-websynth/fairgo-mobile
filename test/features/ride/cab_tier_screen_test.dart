import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Choose a ride -> Cab', () {
    testWidgets('Choose Cab opens Select a Cab', (t) async {
      final router = await pumpApp(t, AppRoutes.chooseRide);
      await t.tap(find.byKey(const Key('ride_cab')));
      await t.pump();
      expect(find.text('Choose Cab'), findsOneWidget);
      await t.tap(find.text('Choose Cab'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.cabTier);
    });
  });

  group('SelectCabTierScreen', () {
    testWidgets('shows the share card and the three tiers', (t) async {
      await pumpApp(t, AppRoutes.cabTier);
      expect(find.text('Select a Cab'), findsOneWidget);
      expect(find.text('Share a Ride'), findsOneWidget);
      expect(find.text('Most Popular'), findsOneWidget);
      for (final n in ['Mini', 'Sedan', 'SUV']) {
        expect(find.text(n), findsOneWidget);
      }
      expect(find.text('₹125- ₹300'), findsOneWidget);
      expect(find.text('₹125- ₹400'), findsOneWidget);
      expect(find.text('₹125- ₹250'), findsOneWidget);
      expect(find.text('Women only'), findsNWidgets(2));
      expect(find.text('3:33pm · 5 min'), findsNWidgets(3));
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('a tier can be selected; Continue opens Pickup Details', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.cabTier);
      await t.tap(find.byKey(const Key('tier_suv')));
      await t.pump();
      await t.tap(find.text('Continue'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.pickupDetails);
    });

    testWidgets(
      'choosing Share a Ride then Continue opens Confirm Shared Ride',
      (t) async {
        final router = await pumpApp(t, AppRoutes.cabTier);
        await t.tap(find.byKey(const Key('share_a_ride')));
        await t.pump();
        await t.tap(find.text('Continue'));
        await t.pumpAndSettle();
        expect(locationOf(router), AppRoutes.sharedRide);
      },
    );

    testWidgets('picking a tier after Share a Ride goes back to the cab', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.cabTier);
      await t.tap(find.byKey(const Key('share_a_ride')));
      await t.pump();
      await t.tap(find.byKey(const Key('tier_sedan')));
      await t.pump();
      await t.tap(find.text('Continue'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.pickupDetails);
    });
  });

  group('Home: ride mode and services', () {
    Color tileColor(WidgetTester t, String key) {
      final box = t.widget<Container>(
        find.descendant(
          of: find.byKey(Key(key)),
          matching: find.byType(Container),
        ),
      );
      return (box.decoration! as BoxDecoration).color!;
    }

    testWidgets('Ride and Share a Ride toggle the highlighted mode', (t) async {
      await pumpApp(t, AppRoutes.home);
      const dark = Color(0xFF0F3D26);
      expect(tileColor(t, 'mode_share'), dark);
      expect(tileColor(t, 'mode_ride'), isNot(dark));

      await t.tap(find.byKey(const Key('mode_ride')));
      await t.pump();
      expect(tileColor(t, 'mode_ride'), dark);
      expect(tileColor(t, 'mode_share'), isNot(dark));

      await t.tap(find.byKey(const Key('mode_share')));
      await t.pump();
      expect(tileColor(t, 'mode_share'), dark);
    });

    testWidgets('Cab preselects the cab fare and opens Plan your ride', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.home);
      await t.tap(find.byKey(const Key('service_Cab')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.planRide);

      // Carry on to the fare list: Cab is already selected.
      router.go(AppRoutes.chooseRide);
      await t.pumpAndSettle();
      expect(find.text('Choose Cab'), findsOneWidget);
    });

    testWidgets('Bike preselects the bike fare', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      await t.tap(find.byKey(const Key('service_Bike')));
      await t.pumpAndSettle();
      router.go(AppRoutes.chooseRide);
      await t.pumpAndSettle();
      expect(find.text('Choose Bike Saver'), findsOneWidget);
    });

    testWidgets('services without a flow say they are not available', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.home);
      await t.tap(find.byKey(const Key('service_Parcel')));
      await t.pump();
      expect(find.text("Parcel booking isn't available yet."), findsOneWidget);
      expect(locationOf(router), AppRoutes.home);
    });
  });
}
