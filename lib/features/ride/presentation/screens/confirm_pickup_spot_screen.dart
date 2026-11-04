import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/map_spot_pin.dart';

class ConfirmPickupSpotScreen extends ConsumerWidget {
  const ConfirmPickupSpotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spot = ref.watch(pickupSpotProvider);

    return MapSheetLayout(
      mapFraction: 0.66,
      pins: const [],
      mapOverlay: const Align(
        alignment: Alignment(0.2, -0.1),
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
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Confirm the pickup spot',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.search, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    spot.subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Confirm pickup',
              onPressed: () {
                // Reset the stack to Home + the live trip, so Back from any
                // trip screen never returns to the booking screens.
                final router = GoRouter.of(context);
                router.go(AppRoutes.home);
                router.push(AppRoutes.rideRequested);
              },
            ),
          ],
        ),
      ),
    );
  }
}
