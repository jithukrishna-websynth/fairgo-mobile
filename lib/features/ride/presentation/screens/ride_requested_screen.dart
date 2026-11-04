import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/map_spot_pin.dart';

/// How long the demo "finding drivers" state lasts before a driver is found.
const findingDriverDuration = Duration(seconds: 4);

class RideRequestedScreen extends StatefulWidget {
  const RideRequestedScreen({super.key});

  @override
  State<RideRequestedScreen> createState() => _RideRequestedScreenState();
}

class _RideRequestedScreenState extends State<RideRequestedScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // DEMO: pretend a driver accepts. Replace with a real dispatch listener.
    _arm(findingDriverDuration);
  }

  /// Waits [delay], then moves on once this screen is visible again (the
  /// cancel confirmation may be open on top of it).
  void _arm(Duration delay) {
    _timer = Timer(delay, () {
      if (!mounted) return;
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        context.pushReplacement(AppRoutes.rideTracking);
      } else {
        _arm(const Duration(seconds: 1));
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
      mapFraction: 0.53,
      pins: const [],
      mapOverlay: const Align(
        alignment: Alignment(0.0, 0.25),
        child: MapSpotPin(label: 'Abees Mess'),
      ),
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.lg,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ride requested',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Finding drivers nearby',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.05, end: 1),
                duration: findingDriverDuration,
                builder: (_, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 3,
                  color: const Color(0xFF1F5BFF),
                  backgroundColor: AppColors.border,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _AutoDetailsCard(),
            const Spacer(),
            FilledButton(
              key: const Key('cancel_request'),
              onPressed: () => context.push(AppRoutes.cancelRequest),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.fieldFill,
                foregroundColor: AppColors.error,
                minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Cancel request',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoDetailsCard extends StatelessWidget {
  const _AutoDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Auto details',
                  style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Meet at your pick-up spot on\n3rd Cross Road',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFF2E3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 11,
                        color: AppColors.forestLight,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Cash',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.more_horiz, size: 16),
          ),
        ],
      ),
    );
  }
}
