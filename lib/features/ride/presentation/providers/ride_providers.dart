import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/demo_places.dart';
import '../../domain/place.dart';

/// Ordered stops for the trip; the last one is the final drop-off.
class RouteStops extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [demoStopKaloor, demoStopLulu];

  /// Inserts a stop before the final drop-off.
  void addStop(Place place) {
    final stops = [...state];
    stops.insert(stops.length - 1, place);
    state = stops;
  }

  /// [newIndex] is already adjusted for the removed item (onReorderItem).
  void reorder(int oldIndex, int newIndex) {
    final stops = [...state];
    stops.insert(newIndex, stops.removeAt(oldIndex));
    state = stops;
  }

  void removeAt(int index) {
    if (state.length <= 2) return; // keep a start stop and a drop-off
    state = [...state]..removeAt(index);
  }
}

final routeStopsProvider = NotifierProvider<RouteStops, List<Place>>(
  RouteStops.new,
);

class HomeDestination extends Notifier<Place> {
  @override
  Place build() => demoHomeDestination;

  void set(Place place) => state = place;
}

final homeDestinationProvider = NotifierProvider<HomeDestination, Place>(
  HomeDestination.new,
);

class SelectedRideOption extends Notifier<String> {
  @override
  String build() => 'auto';

  void select(String id) => state = id;
}

final selectedRideOptionProvider = NotifierProvider<SelectedRideOption, String>(
  SelectedRideOption.new,
);

/// DEMO: the pickup spot suggested by the map until geocoding is wired up.
class PickupSpot {
  const PickupSpot(this.title, this.subtitle);

  final String title;
  final String subtitle;
}

class PickupSpotNotifier extends Notifier<PickupSpot> {
  @override
  PickupSpot build() => const PickupSpot('3rd Cross Road', 'Near Abees Mess');

  void set(PickupSpot spot) => state = spot;
}

final pickupSpotProvider = NotifierProvider<PickupSpotNotifier, PickupSpot>(
  PickupSpotNotifier.new,
);

/// Payment methods offered on the Payment screen (id -> label).
const paymentMethodLabels = {
  'gpay': 'UPI (GPay)',
  'phonepe': 'PhonePe',
  'paytm': 'Paytm',
  'card': 'Credit / Debit Card',
  'cash': 'Cash',
};

class SelectedPaymentMethod extends Notifier<String> {
  @override
  String build() => 'gpay';

  void select(String id) => state = id;
}

final selectedPaymentMethodProvider =
    NotifierProvider<SelectedPaymentMethod, String>(SelectedPaymentMethod.new);

/// Destination picked on Change Destination, pending fare review.
class PendingDestination extends Notifier<Place?> {
  @override
  Place? build() => null;

  void set(Place? place) => state = place;
}

final pendingDestinationProvider = NotifierProvider<PendingDestination, Place?>(
  PendingDestination.new,
);
