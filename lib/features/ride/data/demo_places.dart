import 'package:flutter/material.dart';

import '../domain/place.dart';

/// DEMO ONLY: replace with a places/search API.
const recentPlaces = [
  Place(
    name: 'The Rameshwaram Cafe @ JP Nagar',
    address: '52, Outer Ring Rd, 2nd Phase, J. P. Nagar, Bengaluru',
    distanceKm: 4.6,
  ),
  Place(
    name: 'Castle Restaurant',
    address: '11/7, Maruti nagar, 1st Cross Rd, Zuzuvadi, Mangaluru',
    distanceKm: 1.5,
  ),
  Place(
    name: 'Rameshwaram cafe food truck',
    address: '2JWC+4CC, MS Ramaiah North City, Manayata Tech Park',
    distanceKm: 18,
  ),
  Place(
    name: 'SUPERCODE®',
    address: 'Second Floor, J K Embassy, 3, Sunderamurthy Nagar',
    distanceKm: 10,
  ),
  Place(
    name: 'Savoury Business Hotel',
    address: '84, Hosur main road, Near Federal Bank AT, Bengaluru',
    distanceKm: 1.7,
  ),
  Place(
    name: 'Rameshwaram cafe food truck',
    address: '2JWC+4CC, MS Ramaiah North City, Manayata Tech Park',
    distanceKm: 18,
  ),
  Place(
    name: 'Rameshwaram cafe food truck',
    address: '2JWC+4CC, MS Ramaiah North City, Manayata Tech Park',
    distanceKm: 18,
  ),
];

const savedAddress = Place(
  name: 'Saved Address',
  address: 'Palarivattom, Kochi',
);

const demoStopKaloor = Place(name: 'Kaloor, Kochi', address: 'Kaloor, Kochi');
const demoStopLulu = Place(
  name: 'Lulu Mall, Edapally',
  address: 'Lulu Mall, Edapally',
);
const demoHomeDestination = Place(
  name: 'Aloha Cafe, 758B 5 Star Hotel',
  address: 'Aloha Cafe, 758B 5 Star Hotel',
);

enum SavedCategory { home, work, other }

class SavedLocation {
  const SavedLocation(
    this.name,
    this.subtitle,
    this.category,
    this.icon, {
    this.starred = false,
  });

  final String name;
  final String subtitle;
  final SavedCategory category;
  final IconData icon;
  final bool starred;

  Place get place => Place(name: name, address: subtitle);
}

/// DEMO ONLY: replace with the user's saved addresses from the backend.
const savedLocations = [
  SavedLocation(
    'Home',
    'Palarivattom, Kochi',
    SavedCategory.home,
    Icons.home_rounded,
  ),
  SavedLocation(
    'Work',
    'Infopark, Kochi',
    SavedCategory.work,
    Icons.work_rounded,
  ),
  SavedLocation(
    'Lulu Mall',
    'Edapally, Kochi',
    SavedCategory.other,
    Icons.star_rounded,
    starred: true,
  ),
  SavedLocation(
    'Airport (COK)',
    'Nedumbassery, Kochi',
    SavedCategory.other,
    Icons.star_rounded,
    starred: true,
  ),
  SavedLocation(
    'Marine Drive',
    'Kochi, Kerala',
    SavedCategory.other,
    Icons.star_rounded,
    starred: true,
  ),
  SavedLocation(
    'Friend\'s House',
    'Kadavanthra, Kochi',
    SavedCategory.other,
    Icons.location_on,
  ),
];
