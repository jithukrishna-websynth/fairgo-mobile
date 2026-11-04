import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/route_card.dart';
import '../widgets/trip_pin.dart';

/// DEMO content: fare and payment actions are static until payments exist.
class RideDetailsScreen extends ConsumerWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = ref.watch(homeDestinationProvider);

    return MapSheetLayout(
      mapFraction: 0.27,
      pins: const [MapPin('Abees Mess', 0.55, 0.55)],
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.lg,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            const Text(
              'Ride details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  RouteCard(destination: destination.name),
                  const SizedBox(height: 8),
                  const TripPinRow(),
                  const SizedBox(height: 8),
                  const _ActionRow(
                    icon: Icons.person_outline,
                    title: '₹38.30',
                    subtitle: 'Cash',
                    action: 'Pay Online',
                  ),
                  const SizedBox(height: 8),
                  const _ActionRow(
                    icon: Icons.share_outlined,
                    title: 'Share trip status',
                    action: 'Share',
                  ),
                ],
              ),
            ),
            FilledButton(
              key: const Key('cancel_ride'),
              onPressed: () => context.push(AppRoutes.cancelReason),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFCE4E6),
                foregroundColor: AppColors.error,
                minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Cancel ride',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(label: 'Close', onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.action,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              action,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
