import 'package:fair_go/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('welcome car image loads from assets', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    await tester.runAsync(() async {
      final image = tester.widget<Image>(find.byType(Image));
      await precacheImage(image.image, tester.element(find.byType(Image)));
    });
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsOneWidget);
  });
}
