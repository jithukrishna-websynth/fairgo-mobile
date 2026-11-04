import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/sheet_header.dart';

/// DEMO fares: replace with the re-priced estimate from the pricing API.
class ReviewFareScreen extends ConsumerWidget {
  const ReviewFareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapSheetLayout(
      mapFraction: 0.15,
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
            SheetHeader(
              title: 'Review Updated Fare',
              onClose: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(height: 92, child: MapPlaceholder()),
                  ),
                  const SizedBox(height: 12),
                  const _FareCard(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Confirm & Continue',
              onPressed: () {
                final next = ref.read(pendingDestinationProvider);
                if (next != null) {
                  ref.read(homeDestinationProvider.notifier).set(next);
                }
                ref.read(pendingDestinationProvider.notifier).set(null);
                // Back to the ride: close Review Updated Fare and Change Destination.
                context.pop();
                context.pop();
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: OutlinedButton(
                key: const Key('keep_original_route'),
                onPressed: () {
                  ref.read(pendingDestinationProvider.notifier).set(null);
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text(
                  'Keep Original Route',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FareCard extends StatelessWidget {
  const _FareCard();

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fare Details',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          row('Base Fare', '₹320'),
          row('Distance & Time Charges', '₹40'),
          const Divider(height: 22),
          Row(
            children: [
              const Text(
                'Total Fare',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              const Text(
                '₹380',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '↑ ₹60 higher than previous estimate',
              style: TextStyle(fontSize: 8, color: AppColors.error),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Color(0xFF1F5BFF)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Route is 6 mins longer due to traffic.',
                    style: TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
