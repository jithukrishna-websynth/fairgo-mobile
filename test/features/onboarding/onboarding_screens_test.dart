import 'package:fair_go/app/router/app_routes.dart';
import 'package:fair_go/core/widgets/fair_go_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('shows the logo then moves to the welcome screen', (t) async {
      final router = await pumpApp(t, AppRoutes.splash);
      expect(find.byType(FairGoLogo), findsOneWidget);
      expect(locationOf(router), AppRoutes.splash);

      await t.pump(const Duration(seconds: 3));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.welcome);
    });

    testWidgets('leaving early cancels the timer cleanly', (t) async {
      await pumpApp(t, AppRoutes.splash);
      await disposeApp(t);
    });
  });

  group('WelcomeScreen', () {
    testWidgets('shows heading, description and swipe bar', (t) async {
      await pumpApp(t, AppRoutes.welcome);
      expect(find.textContaining('Request'), findsOneWidget);
      expect(find.textContaining('Ride in Seconds'), findsOneWidget);
      expect(find.textContaining('real-time tracking'), findsOneWidget);
      expect(find.text('Swipe to Get Started'), findsOneWidget);
      expect(find.byKey(const Key('swipe_thumb')), findsOneWidget);
    });

    testWidgets('a short swipe springs back', (t) async {
      final router = await pumpApp(t, AppRoutes.welcome);
      await t.drag(find.byKey(const Key('swipe_thumb')), const Offset(120, 0));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.welcome);
    });

    testWidgets('dragging the bar (not only the arrow) completes', (t) async {
      final router = await pumpApp(t, AppRoutes.welcome);
      await t.drag(
        find.byKey(const Key('swipe_to_start')),
        const Offset(700, 0),
      );
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.language);
    });
  });

  group('LanguageScreen', () {
    testWidgets('lists the six languages with English selected', (t) async {
      await pumpApp(t, AppRoutes.language);
      // English shows twice: its native and English names are identical.
      expect(find.text('English'), findsNWidgets(2));
      for (final name in ['Hindi', 'Bengali', 'Telugu', 'Tamil', 'Marathi']) {
        expect(find.text(name), findsOneWidget);
      }
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('search filters and shows an empty state', (t) async {
      await pumpApp(t, AppRoutes.language);
      await t.enterText(find.byType(TextField), 'tam');
      await t.pump();
      expect(find.text('Tamil'), findsOneWidget);
      expect(find.text('Hindi'), findsNothing);

      await t.enterText(find.byType(TextField), 'zzz');
      await t.pump();
      expect(find.text('No languages found'), findsOneWidget);
    });

    testWidgets('tapping a language moves the selection', (t) async {
      await pumpApp(t, AppRoutes.language);
      await t.tap(find.byKey(const Key('language_ta')));
      await t.pump();
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      final tile = find.byKey(const Key('language_ta'));
      expect(
        find.descendant(
          of: tile,
          matching: find.byIcon(Icons.radio_button_checked),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Continue goes to login, back goes to welcome', (t) async {
      final router = await pumpApp(t, AppRoutes.language);
      await t.tap(find.text('Continue'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.login);

      final router2 = await pumpApp(t, AppRoutes.language);
      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(locationOf(router2), AppRoutes.welcome);
    });
  });
}
