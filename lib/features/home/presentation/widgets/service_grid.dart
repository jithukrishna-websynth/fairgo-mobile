import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../ride/presentation/providers/ride_providers.dart';
import '../../../ride/presentation/widgets/trip_actions.dart';
import '../../../../core/constants/vehicle.dart';
import '../../../../core/widgets/vehicle_icon.dart';
import 'glass_card.dart';

class _Service {
  const _Service(
    this.label,
    this.caption,
    this.icon, {
    this.highlight = false,
    this.rideOptionId,
    this.vehicle,
  });

  /// Drawn instead of [icon] when set.
  final Vehicle? vehicle;

  /// Fare option preselected on Choose a ride; null while the service has no
  /// flow yet (Parcel, Cargo, Book a Driver).
  final String? rideOptionId;

  final String label;
  final String caption;
  final IconData icon;
  final bool highlight;
}

const _services = [
  _Service(
    'Bike',
    '2 mins',
    Icons.two_wheeler,
    rideOptionId: 'bike',
    vehicle: Vehicle.bike,
  ),
  _Service(
    'Auto',
    '3 mins',
    Icons.electric_rickshaw,
    rideOptionId: 'auto',
    vehicle: Vehicle.auto,
  ),
  _Service(
    'Cab',
    '4 mins',
    Icons.directions_car_filled,
    highlight: true,
    rideOptionId: 'cab',
    vehicle: Vehicle.car,
  ),
  _Service('Parcel', 'On-demand', Icons.inventory_2_outlined),
  _Service('Cargo', 'For goods', Icons.local_shipping),
  _Service('Book a Driver', 'Hourly / Per-trip', Icons.person_outline),
];

class ServiceGrid extends ConsumerWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.1,
      children: [
        for (final s in _services)
          _ServiceTile(
            service: s,
            onTap: () {
              final id = s.rideOptionId;
              if (id == null) {
                showNotAvailable(context, '${s.label} booking');
                return;
              }
              ref.read(selectedRideOptionProvider.notifier).select(id);
              context.push(AppRoutes.planRide);
            },
          ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service, required this.onTap});

  final _Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('service_${service.label}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            service.vehicle != null
                ? VehicleIcon(
                    service.vehicle!,
                    width: 34,
                    color: AppColors.forest,
                  )
                : Icon(service.icon, size: 26, color: AppColors.forest),
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
                fontWeight: service.highlight
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: service.highlight
                    ? AppColors.forest
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
