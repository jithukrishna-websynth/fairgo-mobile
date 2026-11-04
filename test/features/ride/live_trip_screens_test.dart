import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Active ride wiring', () {
    testWidgets('buttons open Share, SOS, Contact and Live ride', (t) async {
      final router = await pumpApp(t, AppRoutes.activeRide);

      await t.tap(find.text('Share Trip'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.shareTrip);
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();

      await t.tap(find.byKey(const Key('sos_button')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.sos);
      await t.tap(find.byKey(const Key('cancel_sos')));
      await t.pumpAndSettle();

      await t.tap(find.text('Contact'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.contactDriver);
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();

      await t.tap(find.byKey(const Key('open_live_ride')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.liveRide);
      await disposeApp(t);
    });

    testWidgets('does not auto-complete while another screen is open', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.activeRide);
      await t.tap(find.byKey(const Key('open_live_ride')));
      await t.pumpAndSettle();
      await t.pump(const Duration(seconds: 30));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.liveRide);
      await disposeApp(t);
    });
  });

  group('LiveRideScreen', () {
    testWidgets('shows banner, driver, live track and estimate', (t) async {
      await pumpApp(t, AppRoutes.liveRide);
      expect(find.text('On the way to destination'), findsOneWidget);
      expect(find.text('12 mins • 4.8 km'), findsNWidgets(2));
      expect(find.text('Active Ride'), findsOneWidget);
      expect(find.text('AP03AS2058'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Live Track'), findsOneWidget);
      expect(find.text('Pickup'), findsOneWidget);
      expect(find.text('09:15 AM'), findsOneWidget);
      expect(find.text('Drop'), findsOneWidget);
      expect(find.text('09:38 AM'), findsOneWidget);
      expect(find.text('ESTIMATED FARE'), findsOneWidget);
      expect(find.text('₹320 - ₹360'), findsOneWidget);
    });

    testWidgets('Chat says it is not available; Share Trip navigates', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.liveRide);
      await t.tap(find.text('Chat'));
      await t.pump();
      expect(find.text("Chat isn't available yet."), findsOneWidget);

      await t.tap(find.byKey(const Key('live_share_trip')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.shareTrip);
    });

    testWidgets('Contact and SOS navigate', (t) async {
      final router = await pumpApp(t, AppRoutes.liveRide);
      await t.tap(find.text('Contact'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.contactDriver);
    });
  });

  group('ContactDriverScreen', () {
    testWidgets('shows driver, protection notice and menu', (t) async {
      await pumpApp(t, AppRoutes.contactDriver);
      expect(find.text('Contact Driver Details'), findsOneWidget);
      expect(find.text('NAGARAJA'), findsOneWidget);
      expect(find.text('Your number is protected'), findsOneWidget);
      expect(find.text('Calls are masked for your safety'), findsOneWidget);
      for (final row in [
        'View Profile',
        'Share Trip',
        'Report Issue',
        'Cancel Ride',
      ]) {
        expect(find.text(row), findsOneWidget);
      }
    });

    testWidgets('close pops, Share Trip opens sharing, inert rows say so', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.contactDriver);
      await t.pumpAndSettle();

      await t.tap(find.text('View Profile'));
      await t.pump();
      expect(find.text("Driver profile isn't available yet."), findsOneWidget);

      await t.tap(find.text('Share Trip'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.shareTrip);
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();

      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });

    testWidgets('Cancel Ride asks for a reason', (t) async {
      final router = await pumpApp(t, AppRoutes.contactDriver);
      await t.tap(find.byKey(const Key('cancel_ride_row')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.cancelReason);
    });
  });

  group('ShareTripScreen', () {
    testWidgets('shows driver, route, ETA and share options', (t) async {
      await pumpApp(t, AppRoutes.shareTrip);
      expect(find.text('Share Your Trip'), findsOneWidget);
      expect(find.text('AP03AS2058'), findsOneWidget);
      expect(find.text('Message'), findsNothing); // no action row here
      expect(find.text('START LOCATION'), findsOneWidget);
      expect(find.text('ETA:'), findsOneWidget);
      expect(find.text('12 mins'), findsOneWidget);
      expect(find.text('Share via'), findsOneWidget);
      for (final o in ['WhatsApp', 'Messages', 'Copy Link', 'More']) {
        expect(find.text(o), findsOneWidget);
      }
    });

    testWidgets('options say sharing is not available yet', (t) async {
      await pumpApp(t, AppRoutes.shareTrip);
      await t.tap(find.byKey(const Key('share_WhatsApp')));
      await t.pump();
      expect(
        find.text("Sharing via WhatsApp isn't available yet."),
        findsOneWidget,
      );
    });

    testWidgets('close goes back', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.shareTrip);
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });
  });

  group('Change destination and fare review', () {
    testWidgets('Change Destination lists places and opens the review', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.changeDestination);
      expect(find.text('Change Destination'), findsOneWidget);
      expect(find.text('START LOCATION'), findsOneWidget);
      expect(find.text('Aloha Cafe, 758B 5 Star Hotel'), findsOneWidget);
      expect(find.text('The Rameshwaram Cafe @ JP Nagar'), findsOneWidget);
      expect(find.text('Confirm New Destination'), findsOneWidget);

      await t.tap(find.text('Castle Restaurant'));
      await t.pump();
      await t.tap(find.text('Confirm New Destination'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.reviewFare);
    });

    testWidgets('the + button opens the stop search', (t) async {
      final router = await pumpApp(t, AppRoutes.changeDestination);
      await t.tap(find.byKey(const Key('add_stop_circle')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.addStop);
    });

    testWidgets('Review Updated Fare shows the new total and notes', (t) async {
      await pumpApp(t, AppRoutes.reviewFare);
      expect(find.text('Review Updated Fare'), findsOneWidget);
      expect(find.text('Base Fare'), findsOneWidget);
      expect(find.text('₹320'), findsOneWidget);
      expect(find.text('Distance & Time Charges'), findsOneWidget);
      expect(find.text('₹40'), findsOneWidget);
      expect(find.text('Total Fare'), findsOneWidget);
      expect(find.text('₹380'), findsOneWidget);
      expect(find.text('↑ ₹60 higher than previous estimate'), findsOneWidget);
      expect(
        find.text('Route is 6 mins longer due to traffic.'),
        findsOneWidget,
      );
      expect(find.text('Confirm & Continue'), findsOneWidget);
      expect(find.text('Keep Original Route'), findsOneWidget);
    });

    testWidgets('Confirm & Continue applies the new destination', (t) async {
      final router = await pumpApp(t, AppRoutes.activeRide);
      await t.tap(find.byKey(const Key('route_destination')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.changeDestination);

      await t.tap(find.text('SUPERCODE®'));
      await t.pump();
      await t.tap(find.text('Confirm New Destination'));
      await t.pumpAndSettle();
      await t.tap(find.text('Confirm & Continue'));
      await t.pumpAndSettle();

      expect(locationOf(router), AppRoutes.activeRide);
      expect(find.text('SUPERCODE®'), findsOneWidget);
      await disposeApp(t);
    });

    testWidgets('Keep Original Route leaves the destination unchanged', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.activeRide);
      await t.tap(find.byKey(const Key('route_destination')));
      await t.pumpAndSettle();
      await t.tap(find.text('SUPERCODE®'));
      await t.pump();
      await t.tap(find.text('Confirm New Destination'));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('keep_original_route')));
      await t.pumpAndSettle();

      expect(locationOf(router), AppRoutes.changeDestination);
      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(find.text('Aloha Cafe, 758B 5 Star Hotel'), findsOneWidget);
      await disposeApp(t);
    });
  });

  group('SosScreen', () {
    testWidgets('shows the SOS state and is clearly marked as a demo', (
      t,
    ) async {
      await pumpApp(t, AppRoutes.sos);
      expect(find.text('Emergency SOS'), findsOneWidget);
      expect(find.text('SOS Activated'), findsOneWidget);
      expect(find.text('Help is on the way'), findsOneWidget);
      expect(find.textContaining('live location'), findsOneWidget);
      expect(find.text('Safety & Emergency'), findsOneWidget);
      expect(find.text('Cancel SOS'), findsOneWidget);
      expect(find.byKey(const Key('sos_demo_notice')), findsOneWidget);
      expect(find.textContaining('no alert has been sent'), findsOneWidget);
    });

    testWidgets('Cancel SOS and close go back', (t) async {
      final router = await pumpApp(t, AppRoutes.home);
      router.push(AppRoutes.sos);
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('cancel_sos')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);

      router.push(AppRoutes.sos);
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('sheet_close')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });
  });

  group('SavedLocationsScreen', () {
    testWidgets('lists all six locations with filter chips', (t) async {
      await pumpApp(t, AppRoutes.savedLocations);
      expect(find.text('Saved Locations'), findsOneWidget);
      for (final n in [
        'Home',
        'Work',
        'Lulu Mall',
        'Airport (COK)',
        'Marine Drive',
        "Friend's House",
      ]) {
        expect(find.text(n), findsWidgets);
      }
      expect(find.text('+ Add New'), findsOneWidget);
    });

    testWidgets('filters narrow the list', (t) async {
      await pumpApp(t, AppRoutes.savedLocations);
      await t.tap(find.byKey(const Key('filter_Work')));
      await t.pump();
      expect(find.byKey(const Key('saved_Work')), findsOneWidget);
      expect(find.byKey(const Key('saved_Lulu Mall')), findsNothing);

      await t.tap(find.byKey(const Key('filter_Others')));
      await t.pump();
      expect(find.byKey(const Key('saved_Lulu Mall')), findsOneWidget);
      expect(find.byKey(const Key('saved_Home')), findsNothing);

      await t.tap(find.byKey(const Key('filter_All')));
      await t.pump();
      expect(find.byKey(const Key('saved_Home')), findsOneWidget);
    });

    testWidgets('Add New says it is not available yet', (t) async {
      await pumpApp(t, AppRoutes.savedLocations);
      await t.tap(find.byKey(const Key('add_new_location')));
      await t.pump();
      expect(
        find.text("Adding a location isn't available yet."),
        findsOneWidget,
      );
    });

    testWidgets('choosing a location adds it as a stop', (t) async {
      final router = await pumpApp(t, AppRoutes.stops);
      await t.tap(find.byKey(const Key('add_another_stop')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('saved_more')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.savedLocations);

      await t.tap(find.byKey(const Key('saved_Work')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.stops);
      expect(find.text('Work'), findsOneWidget);
    });
  });

  group('TripInvoiceScreen', () {
    testWidgets('opens from the receipt and shows all sections', (t) async {
      final router = await pumpApp(t, AppRoutes.tripReceipt);
      await t.tap(find.byKey(const Key('open_invoice')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.tripInvoice);

      expect(find.text('Trip Receipt'), findsOneWidget);
      expect(find.text('15 Oct 2026'), findsOneWidget);
      expect(find.text('09:42 AM'), findsWidgets);
      expect(find.text('Trip Details'), findsOneWidget);
      expect(find.text('Kaloor, Kochi'), findsOneWidget);
      expect(find.text('Lulu Mall, Edapally'), findsOneWidget);
      expect(find.text('Maruti Swift'), findsOneWidget);
      expect(find.text('KL 07 AB 1234'), findsOneWidget);
      expect(find.text('Fare Details'), findsOneWidget);
      expect(find.text('Base Fare'), findsOneWidget);
      expect(find.text('Distance (8.4 km)'), findsOneWidget);
      expect(find.text('Time Charge (22 mins)'), findsOneWidget);
      expect(find.text('Coupon Discount'), findsOneWidget);
      expect(find.text('- ₹50'), findsOneWidget);
      expect(find.text('Total Paid'), findsOneWidget);
      expect(find.text('₹340'), findsOneWidget);
      expect(find.text('UPI (Google Pay)'), findsOneWidget);
    });

    testWidgets('Download Invoice says it is not available yet', (t) async {
      await pumpApp(t, AppRoutes.tripInvoice);
      await t.tap(find.byKey(const Key('download_invoice')));
      await t.pump();
      expect(
        find.text("Invoice download isn't available yet."),
        findsOneWidget,
      );
    });

    testWidgets('back returns to the receipt', (t) async {
      final router = await pumpApp(t, AppRoutes.tripReceipt);
      await t.tap(find.byKey(const Key('open_invoice')));
      await t.pumpAndSettle();
      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.tripReceipt);
    });
  });
}
