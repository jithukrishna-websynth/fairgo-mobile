import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// DEMO PIN until the backend issues one per trip.
const demoTripPin = '0281';

class TripPinRow extends StatelessWidget {
  const TripPinRow({super.key, this.pin = demoTripPin});

  final String pin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text(
            'PIN for this trip',
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
          const Spacer(),
          for (final digit in pin.split('')) ...[
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1F5BFF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                digit,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
