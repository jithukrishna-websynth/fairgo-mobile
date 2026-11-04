import 'package:fair_go/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('ProfileSetupScreen', () {
    testWidgets('renders photo placeholder and both fields', (t) async {
      await pumpApp(t, AppRoutes.profile);
      expect(find.text('Tell us about yourself'), findsOneWidget);
      expect(find.text('Add Photo'), findsOneWidget);
      expect(find.text('(Optional)'), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('profile_avatar')), findsOneWidget);
    });

    testWidgets('name is required', (t) async {
      final router = await pumpApp(t, AppRoutes.profile);
      await t.tap(find.text('Continue'));
      await t.pumpAndSettle();
      expect(find.text('Enter your name'), findsOneWidget);
      expect(locationOf(router), AppRoutes.profile);
    });

    testWidgets('a bad email blocks continue, empty email is fine', (t) async {
      final router = await pumpApp(t, AppRoutes.profile);
      await t.enterText(find.byKey(const Key('name_field')), 'Rahul');
      await t.enterText(find.byKey(const Key('email_field')), 'nope');
      await t.tap(find.text('Continue'));
      await t.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(locationOf(router), AppRoutes.profile);

      await t.enterText(find.byKey(const Key('email_field')), '');
      await t.tap(find.text('Continue'));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.home);
    });

    testWidgets('back goes to the login screen', (t) async {
      final router = await pumpApp(t, AppRoutes.profile);
      await t.tap(find.byIcon(Icons.chevron_left));
      await t.pumpAndSettle();
      expect(locationOf(router), AppRoutes.login);
    });
  });
}
