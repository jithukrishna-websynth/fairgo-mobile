import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Start / destination card. [onDestinationTap] makes the destination row
/// tappable (used to change the destination mid-trip).
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.destination,
    this.onDestinationTap,
  });

  final String destination;
  final VoidCallback? onDestinationTap;

  @override
  Widget build(BuildContext context) {
    Widget row(Widget dot, String caption, String value) => Row(
      children: [
        SizedBox(width: 16, child: Center(child: dot)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          row(
            const Icon(Icons.circle, size: 8),
            'START LOCATION',
            'Your Current Location',
          ),
          const Divider(height: 18),
          InkWell(
            key: const Key('route_destination'),
            onTap: onDestinationTap,
            child: row(
              const Icon(Icons.place, size: 14, color: Color(0xFFB7D22A)),
              'YOUR DESTINATION',
              destination,
            ),
          ),
        ],
      ),
    );
  }
}
