import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'glass_card.dart';

class _Service {
  const _Service(this.label, this.caption, this.icon, {this.highlight = false});

  final String label;
  final String caption;
  final IconData icon;
  final bool highlight;
}

const _services = [
  _Service('Bike', '2 mins', Icons.two_wheeler),
  _Service('Auto', '3 mins', Icons.electric_rickshaw),
  _Service('Cab', '4 mins', Icons.directions_car_filled, highlight: true),
  _Service('Parcel', 'On-demand', Icons.inventory_2_outlined),
  _Service('Cargo', 'For goods', Icons.local_shipping),
  _Service('Book a Driver', 'Hourly / Per-trip', Icons.person_outline),
];

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.1,
      children: [for (final s in _services) _ServiceTile(service: s)],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final _Service service;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(service.icon, size: 26, color: AppColors.forest),
          const SizedBox(height: 10),
          Text(
            service.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            service.caption,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: service.highlight ? FontWeight.w600 : FontWeight.w400,
              color: service.highlight
                  ? AppColors.forest
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
