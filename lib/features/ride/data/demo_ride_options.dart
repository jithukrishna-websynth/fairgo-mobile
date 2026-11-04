import '../../../core/constants/vehicle.dart';

import '../domain/ride_option.dart';

/// DEMO ONLY: replace with fares from the pricing API.
const rideOptions = [
  RideOption(
    id: 'auto',
    name: 'Auto',
    shortName: 'Auto',
    vehicle: Vehicle.auto,
    time: '3:30pm · 2 min',
    price: '₹52.00',
    seats: 3,
    badge: 'Faster',
  ),
  RideOption(
    id: 'bike',
    name: 'Bike Saver',
    shortName: 'Bike Saver',
    vehicle: Vehicle.bike,
    time: '3:31pm · 3 min',
    price: '₹39.00',
    oldPrice: '₹44.00',
    hasOffer: true,
  ),
  RideOption(
    id: 'cab',
    name: 'Cab Non AC',
    shortName: 'Cab',
    vehicle: Vehicle.car,
    time: '3:33pm · 5 min',
    price: '₹125.90',
  ),
];

const sharedRidePrice = '₹120';

class CabTier {
  const CabTier({
    required this.id,
    required this.name,
    required this.price,
    this.womenOnly = false,
  });

  final String id;
  final String name;
  final String price;
  final bool womenOnly;
}

/// DEMO ONLY: replace with live tiers and fares from the pricing API.
const cabTiers = [
  CabTier(id: 'mini', name: 'Mini', price: '₹125- ₹300'),
  CabTier(id: 'sedan', name: 'Sedan', price: '₹125- ₹400', womenOnly: true),
  CabTier(id: 'suv', name: 'SUV', price: '₹125- ₹250', womenOnly: true),
];

/// Id used in [selectedRideOptionProvider] when Share a Ride is chosen.
const sharedRideId = 'share';
