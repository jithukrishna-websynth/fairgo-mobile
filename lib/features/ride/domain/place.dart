class Place {
  const Place({required this.name, required this.address, this.distanceKm});

  final String name;
  final String address;
  final double? distanceKm;

  /// "4.6 km", or "18 km" for whole numbers.
  String? get distanceLabel {
    final km = distanceKm;
    if (km == null) return null;
    return '${km == km.roundToDouble() ? km.toInt() : km} km';
  }
}
