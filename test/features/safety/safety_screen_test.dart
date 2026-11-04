import 'package:fair_go/app/router/app_router.dart';
import 'package:fair_go/app/router/app_routes.dart';
import 'package:fair_go/app/theme/app_theme.dart';
import 'package:fair_go/features/safety/domain/emergency_dialer.dart';
import 'package:fair_go/features/safety/presentation/providers/safety_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/pump_app.dart';

class _FakeDialer implements EmergencyDialer {
  _FakeDialer({this.succeeds = true});

  final bool succeeds;
  final dialed = <String>[];

  @override
  Future<bool> dial(String number) async {
    dialed.add(number);
    return succeeds;
  }
}

Future<GoRouter> _pumpWithDialer(WidgetTester t, _FakeDialer dialer) async {
  t.view.physicalSize = const Size(1080, 2340);
  t.view.devicePixelRatio = 2.6;
  addTearDown(t.view.reset);
  final router = createRouter(initialLocation: AppRoutes.safety);
  await t.pumpWidget(
    ProviderScope(
      overrides: [emergencyDialerProvider.overrideWithValue(dialer)],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await t.pumpAndSettle();
  return router;
}

void main() {
  group('SafetyEmergencyScreen', () {
    testWidgets('shows Quick SOS, contacts and safety options', (t) async {
      await pumpApp(t, AppRoutes.safety);
      expect(find.text('Safety & Emergency'), findsOneWidget);
      expect(find.text('Quick SOS'), findsOneWidget);
      expect(find.textContaining('Get immediate help.'), findsOneWidget);
      expect(find.text('Trigger SOS'), findsOneWidget);
      expect(find.text('Emergency Contacts'), findsOneWidget);
      expect(find.text('+ Add New'), findsOneWidget);
      expect(find.text('Akhil (Brother)'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('Amma'), findsOneWidget);
      expect(find.text('+91 98765 67890'), findsOneWidget);
      expect(find.text('Safety Options'), findsOneWidget);
      expect(find.text('Share Live Location'), findsOneWidget);
      expect(find.text('Call Police'), findsOneWidget);
      expect(find.text('Dial 112 directly'), findsOneWidget);
      expect(find.text('In-App Support'), findsOneWidget);
      expect(find.text('Safety Tips'), findsOneWidget);
    });

    testWidgets('Trigger SOS opens the SOS screen (demo notice included)', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.safety);
      await t.tap(find.byKey(const Key('trigger_sos')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.sos);
      expect(find.byKey(const Key('sos_demo_notice')), findsOneWidget);
    });

    testWidgets('Share Live Location opens Share Your Trip', (t) async {
      final router = await pumpApp(t, AppRoutes.safety);
      await t.tap(find.byKey(const Key('option_share_location')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.shareTrip);
    });

    testWidgets('Call Police dials 112', (t) async {
      final dialer = _FakeDialer();
      await _pumpWithDialer(t, dialer);
      await t.tap(find.byKey(const Key('option_call_police')));
      await t.pump();
      expect(dialer.dialed, ['112']);
      expect(find.text("Couldn't open the phone dialer."), findsNothing);
    });

    testWidgets('Call Police explains when no dialer is available', (t) async {
      final dialer = _FakeDialer(succeeds: false);
      await _pumpWithDialer(t, dialer);
      await t.tap(find.byKey(const Key('option_call_police')));
      await t.pump();
      expect(find.text("Couldn't open the phone dialer."), findsOneWidget);
    });

    testWidgets('unbuilt options say they are not available yet', (t) async {
      await pumpApp(t, AppRoutes.safety);
      await t.tap(find.byKey(const Key('option_support')));
      await t.pump();
      expect(find.text("In-app support isn't available yet."), findsOneWidget);

      await t.tap(find.byKey(const Key('option_tips')));
      await t.pump();
      expect(find.text("Safety tips isn't available yet."), findsOneWidget);

      await t.tap(find.byKey(const Key('add_contact')));
      await t.pump();
      expect(
        find.text("Adding a contact isn't available yet."),
        findsOneWidget,
      );

      await t.tap(find.byKey(const Key('edit_contact_0')));
      await t.pump();
      expect(
        find.text("Editing a contact isn't available yet."),
        findsOneWidget,
      );
    });

    testWidgets('the SOS screen row opens Safety & Emergency; back returns', (
      t,
    ) async {
      final router = await pumpApp(t, AppRoutes.sos);
      await t.tap(find.byKey(const Key('safety_row')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.safety);

      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.sos);
    });
  });

  group('Receipt: Book Again', () {
    testWidgets('shows Book Again and reopens the fare choice', (t) async {
      final router = await pumpApp(t, AppRoutes.tripReceipt);
      expect(find.text('Book Again'), findsOneWidget);
      expect(find.text('Same route, easier next time.'), findsOneWidget);

      await t.scrollUntilVisible(
        find.byKey(const Key('book_again')),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await t.tap(find.byKey(const Key('book_again')));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.chooseRide);

      // Back goes to Home, not to the old receipt.
      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });
  });
}
