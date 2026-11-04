import 'package:flutter/material.dart';

import '../domain/ride_option.dart';

/// DEMO ONLY: replace with fares from the pricing API.
const rideOptions = [
  RideOption(
    id: 'auto',
    name: 'Auto',
    icon: Icons.electric_rickshaw,
    time: '3:30pm · 2 min',
    price: '₹52.00',
    seats: 3,
    badge: 'Faster',
  ),
  RideOption(
    id: 'bike',
    name: 'Bike Saver',
    icon: Icons.two_wheeler,
    time: '3:31pm · 3 min',
    price: '₹39.00',
    oldPrice: '₹44.00',
    hasOffer: true,
  ),
  RideOption(
    id: 'cab',
    name: 'Go Non AC',
    icon: Icons.directions_car_filled,
    time: '3:33pm · 5 min',
    price: '₹125.90',
  ),
];

const sharedRidePrice = '₹120';

/// Id used in [selectedRideOptionProvider] when Share a Ride is chosen.
const sharedRideId = 'share';
