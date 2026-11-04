import 'package:fair_go/app/router/app_router.dart';
import 'package:fair_go/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Pumps the real app router starting at [location] on a phone-sized surface.
/// Returns the router so tests can push further routes. Pass `settle: false`
/// for screens with long-running animations or demo timers.
Future<GoRouter> pumpApp(
  WidgetTester tester,
  String location, {
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);

  final router = createRouter(initialLocation: location);
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return router;
}

/// Removes the app so screen timers are disposed before the test ends.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
}

/// Reads the current location of [router].
String locationOf(GoRouter router) {
  final matches = router.routerDelegate.currentConfiguration.matches;
  return matches.last.matchedLocation;
}
