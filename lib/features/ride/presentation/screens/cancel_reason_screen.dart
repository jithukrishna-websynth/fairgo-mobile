import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/sheet_header.dart';

const _reasons = [
  (Icons.hourglass_empty, 'Wait time was too long'),
  (Icons.error, 'Requested by accident'),
  (Icons.person_pin_circle_outlined, 'Selected wrong pick-up'),
  (Icons.directions_car_outlined, 'Requested wrong vehicle'),
  (Icons.location_on, 'Selected wrong drop-off'),
  (Icons.more_horiz, 'Other'),
];

/// Picking a reason cancels the trip. The reason is not sent anywhere yet
/// (no backend), so this just returns Home.
class CancelReasonScreen extends StatelessWidget {
  const CancelReasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.28,
      pins: const [],
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            SheetHeader(title: 'Cancel ride?', onClose: () => context.pop()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(
                      'Why do you want to cancel?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (var i = 0; i < _reasons.length; i++)
                    InkWell(
                      key: Key('reason_$i'),
                      onTap: () {
                        final messenger = ScaffoldMessenger.of(context);
                        context.go(AppRoutes.home);
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Your trip was cancelled.'),
                            ),
                          );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: i < _reasons.length - 1
                              ? const Border(
                                  bottom: BorderSide(color: AppColors.border),
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Icon(_reasons[i].$1, size: 15),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _reasons[i].$2,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Keep my trip',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
