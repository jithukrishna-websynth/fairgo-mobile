import 'package:flutter/widgets.dart';

class RideOption {
  const RideOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.time,
    required this.price,
    this.seats,
    this.badge,
    this.oldPrice,
    this.hasOffer = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final String time;
  final String price;
  final int? seats;
  final String? badge;
  final String? oldPrice;
  final bool hasOffer;
}
