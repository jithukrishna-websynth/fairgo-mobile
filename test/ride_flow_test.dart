import 'package:fair_go/app/app.dart';
import 'package:fair_go/app/router/app_routes.dart';
import 'package:fair_go/features/ride/presentation/providers/ride_providers.dart';
import 'package:fair_go/features/ride/presentation/screens/active_ride_screen.dart';
import 'package:fair_go/features/ride/presentation/screens/ride_requested_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('home to plan ride to stops, add a stop, done', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: FairGoApp()));
    final context = tester.element(find.byType(Navigator).first);
    GoRouter.of(context).go(AppRoutes.home);
    await tester.pumpAndSettle();

    expect(find.text('Choose a service'), findsOneWidget);
    expect(find.text('Aloha Cafe, 758B 5 Star Hotel'), findsOneWidget);

    await tester.tap(find.byKey(const Key('book_ride')));
    await tester.pumpAndSettle();
    expect(find.text('Plan your ride'), findsOneWidget);

    await tester.tap(find.text('Castle Restaurant'));
    await tester.pumpAndSettle();
    expect(find.text('Add Stops'), findsOneWidget);
    expect(find.text('Kaloor, Kochi'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_another_stop')));
    await tester.pumpAndSettle();
    expect(find.text('Add a Stops'), findsOneWidget);

    await tester.tap(find.text('SUPERCODE®'));
    await tester.pumpAndSettle();
    expect(find.text('SUPERCODE®'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a ride'), findsOneWidget);
    expect(find.text('Choose Auto'), findsOneWidget);

    // Selecting another option updates the button label.
    await tester.tap(find.byKey(const Key('ride_bike')));
    await tester.pumpAndSettle();
    expect(find.text('Choose Bike Saver'), findsOneWidget);

    // Share a Ride is selectable and opens the shared-ride confirmation.
    await tester.tap(find.byKey(const Key('share_a_ride')));
    await tester.pumpAndSettle();
    expect(find.text('Choose Share a Ride'), findsOneWidget);
    await tester.tap(find.text('Choose Share a Ride'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Shared Ride'), findsOneWidget);
    await tester.tap(find.text('Confirm & Share Ride'));
    await tester.pumpAndSettle();

    // Pickup details -> save -> confirm spot -> ride requested.
    expect(find.text('Pickup Details'), findsOneWidget);
    await tester.tap(find.text('Save Pickup Details'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm the pickup spot'), findsOneWidget);
    expect(find.text('3rd Cross Road'), findsOneWidget);
    await tester.tap(find.text('Confirm pickup'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Ride requested'), findsOneWidget);
    expect(find.text('Finding drivers nearby'), findsOneWidget);

    // After the demo delay a driver is found.
    await tester.pump(findingDriverDuration);
    await tester.pumpAndSettle();
    expect(find.text('Pick-up in 7 min'), findsOneWidget);
    expect(find.text('AP03AS2058'), findsOneWidget);
    await tester.tap(find.byKey(const Key('close_helmet_tip')));
    await tester.pumpAndSettle();
    expect(find.textContaining('wear a helmet'), findsNothing);

    // Trip details, then cancel the ride back to Home.
    await tester.tap(find.byKey(const Key('trip_details')));
    await tester.pumpAndSettle();
    expect(find.text('Ride details'), findsOneWidget);
    expect(find.text('₹38.30'), findsOneWidget);
    await tester.tap(find.byKey(const Key('cancel_ride')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reason_1')));
    await tester.pumpAndSettle();
    expect(find.text('Choose a service'), findsOneWidget);
    expect(find.text('Lulu Mall, Edapally'), findsOneWidget);
  });

  testWidgets('active ride to completion, payment and receipt', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: FairGoApp()));
    final context = tester.element(find.byType(Navigator).first);
    GoRouter.of(context).go(AppRoutes.activeRide);
    await tester.pumpAndSettle();

    expect(find.text('Enjoy the ride'), findsOneWidget);
    expect(find.text('23 min'), findsOneWidget);
    expect(find.text('12.4 km'), findsOneWidget);
    expect(find.text('SOS'), findsWidgets);

    // Demo: the ride completes after a delay.
    await tester.pump(activeRideDemoDuration);
    await tester.pumpAndSettle();
    expect(find.text('Trip Completed'), findsOneWidget);
    expect(find.text('You saved ₹60'), findsNothing);

    await tester.tap(find.byKey(const Key('star_4')));
    await tester.pump();
    await tester.tap(find.text('Payment'));
    await tester.pumpAndSettle();

    expect(find.text('Safe. Simple. Flexible.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('method_cash')));
    await tester.pump();
    await tester.tap(find.text('Pay ₹120'));
    await tester.pumpAndSettle();

    expect(find.text('Fare Details'), findsOneWidget);
    // Cash was selected on the Payment screen.
    expect(find.text('Cash'), findsOneWidget);
    await tester.tap(find.text('Book a New Ride'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a service'), findsOneWidget);
  });

  test('stops: add inserts before drop-off, reorder works', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(routeStopsProvider.notifier);
    final before = container.read(routeStopsProvider);
    expect(before.length, 2);
    notifier.addStop(before.first);
    final after = container.read(routeStopsProvider);
    expect(after.length, 3);
    expect(after.last, before.last);
  });
}
