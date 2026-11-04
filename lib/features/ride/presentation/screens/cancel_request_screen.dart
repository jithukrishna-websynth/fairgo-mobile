import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/map_spot_pin.dart';
import '../widgets/sheet_header.dart';

/// Shown while a driver is still being found. Nothing is sent to a backend
/// yet: cancelling just returns Home.
class CancelRequestScreen extends StatelessWidget {
  const CancelRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.5,
      pins: const [],
      mapOverlay: const Align(
        alignment: Alignment(0.0, 0.0),
        child: MapSpotPin(label: 'Abees Mess'),
      ),
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetHeader(title: 'Cancel ride?', onClose: () => context.pop()),
            const SizedBox(height: 6),
            const Text(
              'Are you sure you want to cancel?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'This trip has been offered to a driver right now, and should '
              'be confirmed within seconds.',
              style: TextStyle(
                fontSize: 10,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            FilledButton(
              key: const Key('confirm_cancel_request'),
              onPressed: () => context.go(AppRoutes.home),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFCE4E6),
                foregroundColor: AppColors.error,
                minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Cancel request',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Wait for driver',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
