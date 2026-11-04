import '../../../core/constants/vehicle.dart';

class RideOption {
  const RideOption({
    required this.id,
    required this.name,
    required this.shortName,
    required this.vehicle,
    required this.time,
    required this.price,
    this.seats,
    this.badge,
    this.oldPrice,
    this.hasOffer = false,
  });

  final String id;
  final String name;

  /// Used in the bottom button, as in "Choose Cab".
  final String shortName;
  final Vehicle vehicle;
  final String time;
  final String price;
  final int? seats;
  final String? badge;
  final String? oldPrice;
  final bool hasOffer;
}
