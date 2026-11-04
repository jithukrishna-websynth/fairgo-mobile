import 'package:fair_go/app/router/app_routes.dart';
import 'package:fair_go/features/ride/presentation/screens/active_ride_screen.dart';
import 'package:fair_go/features/ride/presentation/screens/ride_requested_screen.dart';
import 'package:fair_go/features/ride/presentation/screens/ride_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('RideRequestedScreen', () {
    testWidgets('shows searching state and the Auto details card', (t) async {
      await pumpApp(t, AppRoutes.rideRequested, settle: false);
      expect(find.text('Ride requested'), findsOneWidget);
      expect(find.text('Finding drivers nearby'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Auto details'), findsOneWidget);
      expect(find.textContaining('3rd Cross Road'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Cancel request'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('a driver is found after the demo delay', (t) async {
      final router = await pumpApp(t, AppRoutes.rideRequested, settle: false);
      await t.pump(findingDriverDuration);
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.rideTracking);
      await disposeApp(t);
    });

    testWidgets('Cancel request asks first; confirming returns Home', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.rideRequested, settle: false);
      await t.tap(find.byKey(const Key('cancel_request')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      expect(locationOf(router), AppRoutes.cancelRequest);

      await t.tap(find.byKey(const Key('confirm_cancel_request')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
      await t.pump(findingDriverDuration * 2);
      expect(locationOf(router), AppRoutes.home);
    });

    testWidgets('Wait for driver keeps searching and the driver is found', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.rideRequested, settle: false);
      await t.tap(find.byKey(const Key('cancel_request')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      // The search timer elapses while the confirmation is open: no jump.
      await t.pump(findingDriverDuration);
      expect(locationOf(router), AppRoutes.cancelRequest);

      await t.tap(find.text('Wait for driver'));
      await t.pump();
      await t.pump(const Duration(seconds: 2));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.rideTracking);
      await disposeApp(t);
    });
  });

  group('RideTrackingScreen', () {
    testWidgets('shows pickup ETA, PIN and driver details', (t) async {
      await pumpApp(t, AppRoutes.rideTracking);
      expect(find.text('Pick-up in 7 min'), findsOneWidget);
      expect(find.textContaining('wear a helmet'), findsOneWidget);
      expect(find.text('Trip Details'), findsOneWidget);
      expect(find.text('PIN for this trip'), findsOneWidget);
      for (final d in ['0', '2', '8', '1']) {
        expect(find.text(d), findsOneWidget);
      }
      expect(find.text('AP03AS2058'), findsOneWidget);
      expect(find.text('NAGARAJA'), findsOneWidget);
      expect(find.text('Red Yamaha Crux'), findsOneWidget);
      expect(find.text('4,111 trips'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('the helmet tip can be dismissed', (t) async {
      await pumpApp(t, AppRoutes.rideTracking);
      await t.tap(find.byKey(const Key('close_helmet_tip')));
      await t.pump();
      expect(find.textContaining('wear a helmet'), findsNothing);
      await disposeApp(t);
    });

    testWidgets('the ride starts after the demo delay', (t) async {
      final router = await pumpApp(t, AppRoutes.rideTracking);
      await t.pump(driverArrivalDemoDuration);
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.activeRide);
      await disposeApp(t);
    });

    testWidgets('does not jump away while Ride details is open', (t) async {
      final router = await pumpApp(t, AppRoutes.rideTracking);
      await t.tap(find.byKey(const Key('trip_details')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.rideDetails);
      await t.pump(driverArrivalDemoDuration * 2);
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.rideDetails);
      await disposeApp(t);
    });
  });

  group('RideDetailsScreen', () {
    testWidgets('shows route, PIN, fare and actions', (t) async {
      await pumpApp(t, AppRoutes.rideDetails);
      expect(find.text('Ride details'), findsOneWidget);
      expect(find.text('START LOCATION'), findsOneWidget);
      expect(find.text('Your Current Location'), findsOneWidget);
      expect(find.text('YOUR DESTINATION'), findsOneWidget);
      expect(find.text('PIN for this trip'), findsOneWidget);
      expect(find.text('₹38.30'), findsOneWidget);
      expect(find.text('Pay Online'), findsOneWidget);
      expect(find.text('Share trip status'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Cancel ride'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('Close goes back, Cancel ride goes Home', (t) async {
      final router = await pumpApp(t, AppRoutes.rideTracking);
      await t.tap(find.byKey(const Key('trip_details')));
      await t.pumpAndSettle();
      await t.tap(find.text('Close'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.rideTracking);

      await t.tap(find.byKey(const Key('trip_details')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('cancel_ride')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.cancelReason);
      await t.tap(find.byKey(const Key('reason_0')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
      await disposeApp(t);
    });
  });

  group('ActiveRideScreen', () {
    testWidgets('shows progress, driver and the action buttons', (t) async {
      await pumpApp(t, AppRoutes.activeRide);
      expect(find.text('Enjoy the ride'), findsOneWidget);
      expect(find.textContaining('Kakkanad'), findsOneWidget);
      expect(find.text('23 min'), findsOneWidget);
      expect(find.text('Time left'), findsOneWidget);
      expect(find.text('12.4 km'), findsOneWidget);
      expect(find.text('Distance'), findsOneWidget);
      expect(find.text('AP03AS2058'), findsOneWidget);
      expect(find.text('Share Trip'), findsOneWidget);
      expect(find.text('SOS'), findsNWidgets(2));
      expect(find.text('Contact'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('completes after the demo duration', (t) async {
      final router = await pumpApp(t, AppRoutes.activeRide);
      await t.pump(activeRideDemoDuration);
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.tripCompleted);
      await disposeApp(t);
    });
  });
}
