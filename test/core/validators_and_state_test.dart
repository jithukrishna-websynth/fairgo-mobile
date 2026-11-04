import 'package:fair_go/core/utils/validators.dart';
import 'package:fair_go/features/authentication/data/demo_auth_repository.dart';
import 'package:fair_go/features/ride/data/demo_places.dart';
import 'package:fair_go/features/ride/domain/place.dart';
import 'package:fair_go/features/ride/presentation/providers/ride_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('phone accepts 10 digits starting 6-9, ignoring spaces', () {
      expect(Validators.phone(null), isNotNull);
      expect(Validators.phone('98765'), isNotNull);
      expect(Validators.phone('1234567890'), isNotNull);
      expect(Validators.phone('98765 43210'), isNull);
    });

    test('otp needs exactly 6 digits', () {
      expect(Validators.otp(null), isNotNull);
      expect(Validators.otp('12345'), isNotNull);
      expect(Validators.otp('12345a'), isNotNull);
      expect(Validators.otp('123456'), isNull);
    });

    test('name needs at least 2 characters', () {
      expect(Validators.name('A'), isNotNull);
      expect(Validators.name('  '), isNotNull);
      expect(Validators.name('Al'), isNull);
    });

    test('email is optional but must be valid when present', () {
      expect(Validators.optionalEmail(null), isNull);
      expect(Validators.optionalEmail('   '), isNull);
      expect(Validators.optionalEmail('a@b'), isNotNull);
      expect(Validators.optionalEmail('a@b.com'), isNull);
    });
  });

  group('DemoAuthRepository', () {
    final repo = DemoAuthRepository();

    test('accepts only the demo OTP', () async {
      expect(await repo.verifyOtp('9876543210', '000000'), isFalse);
      expect(
        await repo.verifyOtp('9876543210', DemoAuthRepository.demoOtp),
        isTrue,
      );
    });
  });

  group('RouteStops', () {
    late ProviderContainer container;
    late RouteStops notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(routeStopsProvider.notifier);
    });
    tearDown(() => container.dispose());

    test('starts with a first stop and the final drop-off', () {
      final stops = container.read(routeStopsProvider);
      expect(stops, [demoStopKaloor, demoStopLulu]);
    });

    test('addStop inserts before the drop-off', () {
      notifier.addStop(savedAddress);
      final stops = container.read(routeStopsProvider);
      expect(stops, [demoStopKaloor, savedAddress, demoStopLulu]);
    });

    test('reorder moves a stop (onReorderItem semantics)', () {
      notifier.addStop(savedAddress);
      notifier.reorder(0, 1);
      expect(container.read(routeStopsProvider).map((p) => p.name), [
        savedAddress.name,
        demoStopKaloor.name,
        demoStopLulu.name,
      ]);
    });

    test('removeAt never drops below two stops', () {
      notifier.removeAt(0);
      expect(container.read(routeStopsProvider).length, 2);
      notifier.addStop(savedAddress);
      notifier.removeAt(1);
      expect(container.read(routeStopsProvider).length, 2);
    });
  });

  group('Place.distanceLabel', () {
    test('drops the decimal for whole numbers', () {
      expect(
        const Place(name: 'a', address: 'b', distanceKm: 18).distanceLabel,
        '18 km',
      );
      expect(
        const Place(name: 'a', address: 'b', distanceKm: 4.6).distanceLabel,
        '4.6 km',
      );
      expect(const Place(name: 'a', address: 'b').distanceLabel, isNull);
    });
  });

  group('selected ride option', () {
    test('defaults to auto and can change', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(selectedRideOptionProvider), 'auto');
      container.read(selectedRideOptionProvider.notifier).select('cab');
      expect(container.read(selectedRideOptionProvider), 'cab');
    });
  });
}
