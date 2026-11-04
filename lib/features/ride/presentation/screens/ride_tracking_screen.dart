import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../widgets/driver_card.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/trip_pin.dart';

/// DEMO content: driver and vehicle details are static until dispatch exists.
class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

/// DEMO: how long until the driver "arrives" and the ride starts.
const driverArrivalDemoDuration = Duration(seconds: 8);

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  bool _showHelmetTip = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // DEMO: replace with a trip-started event from the backend.
    _timer = Timer(driverArrivalDemoDuration, () {
      if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
        context.pushReplacement(AppRoutes.activeRide);
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
    return MapSheetLayout(
      mapFraction: 0.375,
      pins: const [MapPin('Abees Mess', 0.52, 0.5)],
      sheet: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.lg,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        children: [
          const Text(
            'Pick-up in 7 min',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Finded driver nearby you',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          if (_showHelmetTip) ...[
            _HelmetTip(onClose: () => setState(() => _showHelmetTip = false)),
            const SizedBox(height: 8),
          ],
          InkWell(
            key: const Key('trip_details'),
            onTap: () => context.push(AppRoutes.rideDetails),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 22),
                  Text(
                    'Trip Details',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const TripPinRow(),
          const SizedBox(height: 12),
          const DriverCard(),
        ],
      ),
    );
  }
}

class _HelmetTip extends StatelessWidget {
  const _HelmetTip({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.sports_motorsports,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Remember to wear a helmet\nthroughout your ride',
              style: TextStyle(fontSize: 9, height: 1.3),
            ),
          ),
          IconButton(
            key: const Key('close_helmet_tip'),
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 14),
          ),
        ],
      ),
    );
  }
}
