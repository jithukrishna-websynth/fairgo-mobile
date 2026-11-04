import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CancelRequestScreen', () {
    testWidgets('asks for confirmation with both choices', (t) async {
      await pumpApp(t, AppRoutes.cancelRequest);
      expect(find.text('Cancel ride?'), findsOneWidget);
      expect(find.text('Are you sure you want to cancel?'), findsOneWidget);
      expect(find.textContaining('offered to a driver'), findsOneWidget);
      expect(find.text('Cancel request'), findsOneWidget);
      expect(find.text('Wait for driver'), findsOneWidget);
      expect(find.text('Abees Mess'), findsOneWidget);
    });

    testWidgets('Cancel request goes Home', (t) async {
      final router = await pumpApp(t, AppRoutes.cancelRequest);
      await t.tap(find.byKey(const Key('confirm_cancel_request')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });

    testWidgets('Wait for driver and the close button go back', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.cancelRequest);
      await t.pumpAndSettle();
      await t.tap(find.text('Wait for driver'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);

      router.push(AppRoutes.cancelRequest);
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });
  });

  group('CancelReasonScreen', () {
    testWidgets('lists the six reasons and Keep my trip', (t) async {
      await pumpApp(t, AppRoutes.cancelReason);
      expect(find.text('Cancel ride?'), findsOneWidget);
      expect(find.text('Why do you want to cancel?'), findsOneWidget);
      for (final r in [
        'Wait time was too long',
        'Requested by accident',
        'Selected wrong pick-up',
        'Requested wrong vehicle',
        'Selected wrong drop-off',
        'Other',
      ]) {
        expect(find.text(r), findsOneWidget);
      }
      expect(find.text('Keep my trip'), findsOneWidget);
    });

    testWidgets('choosing a reason cancels the trip and returns Home', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.cancelReason);
      await t.tap(find.byKey(const Key('reason_2')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
      expect(find.text('Your trip was cancelled.'), findsOneWidget);
    });

    testWidgets('Keep my trip and close go back without cancelling', (t) async {
      final router = await pumpApp(t, AppRoutes.activeRide);
      router.push(AppRoutes.cancelReason);
      await t.pumpAndSettle();
      await t.tap(find.text('Keep my trip'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.activeRide);

      router.push(AppRoutes.cancelReason);
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.activeRide);
      await disposeApp(t);
    });

    testWidgets('Ride details Cancel ride opens the reasons', (t) async {
      final router = await pumpApp(t, AppRoutes.rideDetails);
      await t.tap(find.byKey(const Key('cancel_ride')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.cancelReason);
    });
  });
}
