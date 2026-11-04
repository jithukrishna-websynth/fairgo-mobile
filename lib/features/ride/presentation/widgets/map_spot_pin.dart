import 'package:flutter/material.dart';

/// Black map pin with a name label underneath.
class MapSpotPin extends StatelessWidget {
  const MapSpotPin({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on, size: 26, color: Colors.black),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 4),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
