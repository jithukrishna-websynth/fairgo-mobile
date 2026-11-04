import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../providers/ride_providers.dart';
import '../widgets/driver_card.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/route_card.dart';
import '../widgets/trip_actions.dart';
import '../widgets/trip_pin.dart';

/// DEMO: how long the active ride lasts before it "completes".
const activeRideDemoDuration = Duration(seconds: 30);

class ActiveRideScreen extends ConsumerStatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  ConsumerState<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends ConsumerState<ActiveRideScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // DEMO: replace with a trip-completed event from the backend.
    _timer = Timer(activeRideDemoDuration, () {
      if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
        context.pushReplacement(AppRoutes.tripCompleted);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destination = ref.watch(homeDestinationProvider);

    return MapSheetLayout(
      mapFraction: 0.17,
      pins: const [
        MapPin('Castle Restaurant', 0.22, 0.28),
        MapPin('Abees Mess', 0.36, 0.5),
      ],
      sheet: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        children: [
          const Text(
            'Enjoy the ride',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kakkanad  ·  Lulu Mall',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          RouteCard(
            destination: destination.name,
            onDestinationTap: () => context.push(AppRoutes.changeDestination),
          ),
          const SizedBox(height: 8),
          const TripPinRow(),
          const SizedBox(height: 8),
          InkWell(
            key: const Key('open_live_ride'),
            onTap: () => context.push(AppRoutes.liveRide),
            borderRadius: BorderRadius.circular(12),
            child: const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.schedule,
                    value: '23 min',
                    caption: 'Time left',
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.route,
                    value: '12.4 km',
                    caption: 'Distance',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const DriverCard(),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundActionButton(
                icon: Icons.share,
                label: 'Share Trip',
                onTap: () => context.push(AppRoutes.shareTrip),
              ),
              SosActionButton(onTap: () => context.push(AppRoutes.sos)),
              RoundActionButton(
                icon: Icons.phone,
                label: 'Contact',
                onTap: () => context.push(AppRoutes.contactDriver),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.fieldFill,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
