import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('PlanRideScreen', () {
    testWidgets('shows search field and seven recent places', (t) async {
      await pumpApp(t, AppRoutes.planRide);
      expect(find.text('Plan your ride'), findsOneWidget);
      expect(find.text('Where to?'), findsOneWidget);
      expect(find.text('The Rameshwaram Cafe @ JP Nagar'), findsOneWidget);
      expect(find.text('Castle Restaurant'), findsOneWidget);
      expect(find.text('Rameshwaram cafe food truck'), findsWidgets);
      expect(find.text('4.6 km'), findsOneWidget);
      expect(find.text('18 km'), findsWidgets);
      expect(find.text('18.0 km'), findsNothing);
    });

    testWidgets('tapping a place opens Add Stops', (t) async {
      final router = await pumpApp(t, AppRoutes.planRide);
      await t.tap(find.text('Castle Restaurant'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.stops);
    });

    testWidgets('tapping Where to? opens the stop search', (t) async {
      final router = await pumpApp(t, AppRoutes.planRide);
      await t.tap(find.byKey(const Key('where_to_field')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.addStop);
    });

    testWidgets('back returns to the previous screen', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.planRide);
      await t.pumpAndSettle();
      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });
  });

  group('AddStopsScreen', () {
    testWidgets('shows numbered stop, add row, drop-off and info', (t) async {
      await pumpApp(t, AppRoutes.stops);
      expect(find.text('Add Stops'), findsOneWidget);
      expect(find.text('Kaloor, Kochi'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Add another stop'), findsOneWidget);
      expect(find.text('Lulu Mall, Edapally'), findsOneWidget);
      expect(find.text('You can add multiple stops.'), findsOneWidget);
      expect(
        find.text('The driver will follow the order you set.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.drag_handle), findsNWidgets(2));
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('adding a stop inserts it before the drop-off', (t) async {
      final router = await pumpApp(t, AppRoutes.stops);
      await t.tap(find.byKey(const Key('add_another_stop')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.addStop);

      // Tap the list row (the map chip has the same text).
      await t.tap(find.text('Castle Restaurant').last);
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.stops);
      // Once as the map chip, once as the new stop row.
      expect(find.text('Castle Restaurant'), findsNWidgets(2));
      expect(find.byIcon(Icons.drag_handle), findsNWidgets(3));
      expect(find.text('2'), findsOneWidget);

      final castle = t.getTopLeft(find.text('Castle Restaurant').last).dy;
      final lulu = t.getTopLeft(find.text('Lulu Mall, Edapally')).dy;
      expect(castle, lessThan(lulu));
    });

    testWidgets('Done opens Choose a ride and updates the Home destination', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.stops);
      await t.pumpAndSettle();
      await t.tap(find.text('Done'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.chooseRide);

      router.go(AppRoutes.home);
      await t.pumpAndSettle();
      expect(find.text('Lulu Mall, Edapally'), findsOneWidget);
    });
  });

  group('AddStopSearchScreen', () {
    testWidgets('lists four recents and the saved address', (t) async {
      await pumpApp(t, AppRoutes.addStop);
      expect(find.text('Add a Stops'), findsOneWidget);
      expect(find.text('Search destination'), findsOneWidget);
      expect(find.text('The Rameshwaram Cafe @ JP Nagar'), findsOneWidget);
      expect(find.text('SUPERCODE®'), findsOneWidget);
      expect(find.text('Savoury Business Hotel'), findsNothing);
      expect(find.text('Saved Address'), findsOneWidget);
      expect(find.text('Palarivattom, Kochi'), findsOneWidget);
    });

    testWidgets('search filters and shows an empty state', (t) async {
      await pumpApp(t, AppRoutes.addStop);
      await t.enterText(find.byKey(const Key('search_destination')), 'castle');
      await t.pump();
      // The tile plus the map chip.
      expect(find.text('Castle Restaurant'), findsNWidgets(2));
      expect(find.text('SUPERCODE®'), findsNothing);

      await t.enterText(find.byKey(const Key('search_destination')), 'qqq');
      await t.pump();
      expect(find.text('No places found'), findsOneWidget);
    });

    testWidgets('choosing the saved address adds it and goes back', (t) async {
      final router = await pumpApp(t, AppRoutes.stops);
      await t.tap(find.byKey(const Key('add_another_stop')));
      await t.pumpAndSettle();
      await t.tap(find.text('Saved Address'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.stops);
      expect(find.text('Saved Address'), findsOneWidget);
    });
  });

  group('ChooseRideScreen', () {
    testWidgets('shows share card and the three fares', (t) async {
      await pumpApp(t, AppRoutes.chooseRide);
      expect(find.text('Choose a ride'), findsOneWidget);
      expect(find.text('Share a Ride'), findsOneWidget);
      expect(find.text('Most Popular'), findsOneWidget);
      expect(find.text('₹120'), findsOneWidget);
      expect(find.text('Auto'), findsOneWidget);
      expect(find.text('₹52.00'), findsOneWidget);
      expect(find.text('Faster'), findsOneWidget);
      expect(find.text('Bike Saver'), findsOneWidget);
      expect(find.text('₹39.00'), findsOneWidget);
      expect(find.text('₹44.00'), findsOneWidget);
      expect(find.text('Cab Non AC'), findsOneWidget);
      expect(find.text('₹125.90'), findsOneWidget);
      expect(find.text('Choose Auto'), findsOneWidget);
    });

    testWidgets('selecting options updates the button label', (t) async {
      await pumpApp(t, AppRoutes.chooseRide);
      await t.tap(find.byKey(const Key('ride_cab')));
      await t.pump();
      expect(find.text('Choose Cab'), findsOneWidget);
      await t.tap(find.byKey(const Key('ride_bike')));
      await t.pump();
      expect(find.text('Choose Bike Saver'), findsOneWidget);
      await t.tap(find.byKey(const Key('share_a_ride')));
      await t.pump();
      expect(find.text('Choose Share a Ride'), findsOneWidget);
    });

    testWidgets('a normal ride goes to Pickup Details', (t) async {
      final router = await pumpApp(t, AppRoutes.chooseRide);
      await t.tap(find.text('Choose Auto'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.pickupDetails);
    });

    testWidgets('Share a Ride goes to Confirm Shared Ride', (t) async {
      final router = await pumpApp(t, AppRoutes.chooseRide);
      await t.tap(find.byKey(const Key('share_a_ride')));
      await t.pump();
      await t.tap(find.text('Choose Share a Ride'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.sharedRide);
    });
  });

  group('ConfirmSharedRideScreen', () {
    testWidgets('shows riders, payment split and savings', (t) async {
      await pumpApp(t, AppRoutes.sharedRide);
      expect(find.text('Confirm Shared Ride'), findsOneWidget);
      expect(find.text('Sharing with'), findsOneWidget);
      expect(find.text('View route'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
      expect(find.text('Joined'), findsOneWidget);
      expect(find.text('Arjun'), findsOneWidget);
      expect(find.text('Meera'), findsOneWidget);
      expect(find.text('Pickup in 2 min'), findsOneWidget);
      expect(find.text('Pickup in 4 min'), findsOneWidget);
      expect(find.text('Total Fare'), findsOneWidget);
      expect(find.text('₹360'), findsOneWidget);
      expect(find.text('₹120'), findsOneWidget);
      expect(find.text('50% less'), findsOneWidget);
      expect(find.text('UPI (GPay)'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
      expect(find.text("You'll save ₹70 on this ride"), findsOneWidget);
    });

    testWidgets('Confirm & Share Ride opens Pickup Details', (t) async {
      final router = await pumpApp(t, AppRoutes.sharedRide);
      await t.tap(find.text('Confirm & Share Ride'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.pickupDetails);
    });
  });

  group('PickupDetailsScreen', () {
    testWidgets('shows the form and photo slots', (t) async {
      await pumpApp(t, AppRoutes.pickupDetails);
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('YOUR LOCATION'), findsOneWidget);
      expect(find.text('Landmark (Optional)'), findsOneWidget);
      expect(find.text('Additional Notes (Optional)'), findsOneWidget);
      expect(find.text('Add Photo (Optional)'), findsOneWidget);
      expect(find.byKey(const Key('add_pickup_photo')), findsOneWidget);
      expect(find.byKey(const Key('remove_pickup_photo')), findsOneWidget);
    });

    testWidgets('optional fields accept text; the remove button is safe', (
      t,
    ) async {
      await pumpApp(t, AppRoutes.pickupDetails);
      await t.enterText(find.byKey(const Key('landmark_field')), 'Gate 2');
      await t.enterText(find.byKey(const Key('notes_field')), 'Main gate');
      expect(find.text('Gate 2'), findsOneWidget);
      expect(find.text('Main gate'), findsOneWidget);
      await t.tap(find.byKey(const Key('remove_pickup_photo')));
      await t.pump();
      expect(t.takeException(), isNull);
    });

    testWidgets('Save opens Confirm Pickup Spot, back returns', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.pickupDetails);
      await t.pumpAndSettle();
      await t.tap(find.text('Save Pickup Details'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.pickupSpot);
    });
  });

  group('ConfirmPickupSpotScreen', () {
    testWidgets('shows the spot and confirms into Ride requested', (t) async {
      final router = await pumpApp(t, AppRoutes.pickupSpot);
      expect(find.text('Confirm the pickup spot'), findsOneWidget);
      expect(find.text('3rd Cross Road'), findsOneWidget);
      expect(find.text('Near Abees Mess'), findsOneWidget);
      expect(find.text('Abees Mess'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      await t.tap(find.text('Confirm pickup'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      expect(locationOf(router), AppRoutes.rideRequested);
      await disposeApp(t);
    });
  });
}
