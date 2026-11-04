import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/driver_card.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/sheet_header.dart';
import '../widgets/trip_actions.dart';

/// Calls are not masked or routed yet: that needs a telephony backend.
class ContactDriverScreen extends StatelessWidget {
  const ContactDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.2,
      pins: const [],
      sheet: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        children: [
          SheetHeader(
            title: 'Contact Driver Details',
            onClose: () => context.pop(),
          ),
          const SizedBox(height: 6),
          const DriverCard(),
          const SizedBox(height: 14),
          const _ProtectedBanner(),
          const SizedBox(height: 6),
          _MenuRow(
            icon: Icons.person_outline,
            label: 'View Profile',
            onTap: () => showNotAvailable(context, 'Driver profile'),
          ),
          _MenuRow(
            icon: Icons.share_outlined,
            label: 'Share Trip',
            onTap: () => context.push(AppRoutes.shareTrip),
          ),
          _MenuRow(
            icon: Icons.warning_amber_rounded,
            label: 'Report Issue',
            onTap: () => showNotAvailable(context, 'Issue reporting'),
          ),
          _MenuRow(
            key: const Key('cancel_ride_row'),
            icon: Icons.cancel_outlined,
            label: 'Cancel Ride',
            color: AppColors.error,
            showDivider: false,
            onTap: () => context.push(AppRoutes.cancelReason),
          ),
        ],
      ),
    );
  }
}

class _ProtectedBanner extends StatelessWidget {
  const _ProtectedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCDE8D2)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.forest,
            child: Icon(Icons.shield_outlined, size: 13, color: AppColors.lime),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your number is protected',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
              ),
              Text(
                'Calls are masked for your safety',
                style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
