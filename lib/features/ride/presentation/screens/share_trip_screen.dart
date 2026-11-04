import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../providers/ride_providers.dart';
import '../widgets/driver_card.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/route_card.dart';
import '../widgets/sheet_header.dart';
import '../widgets/trip_actions.dart';

/// Sharing is not connected: there is no share link or share-sheet integration
/// yet, so each option just says so.
class ShareTripScreen extends ConsumerWidget {
  const ShareTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = ref.watch(homeDestinationProvider);

    return MapSheetLayout(
      mapFraction: 0.12,
      pins: const [],
      sheet: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        children: [
          SheetHeader(title: 'Share Your Trip', onClose: () => context.pop()),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const SizedBox(height: 84, child: MapPlaceholder()),
          ),
          const SizedBox(height: 12),
          const DriverCard(showActions: false),
          const SizedBox(height: 10),
          RouteCard(destination: destination.name),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.circle, size: 8, color: Color(0xFF1DB77A)),
              SizedBox(width: 8),
              Text(
                'ETA:',
                style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
              ),
              SizedBox(width: 18),
              Text(
                '12 mins',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Share via',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShareOption(
                label: 'WhatsApp',
                icon: Icons.chat,
                color: const Color(0xFF25D366),
                onTap: () => showNotAvailable(context, 'Sharing via WhatsApp'),
              ),
              _ShareOption(
                label: 'Messages',
                icon: Icons.sms_outlined,
                color: const Color(0xFF14B8A6),
                onTap: () => showNotAvailable(context, 'Sharing via Messages'),
              ),
              _ShareOption(
                label: 'Copy Link',
                icon: Icons.link,
                color: const Color(0xFF6B7280),
                onTap: () => showNotAvailable(context, 'Copying a trip link'),
              ),
              _ShareOption(
                label: 'More',
                icon: Icons.more_horiz,
                color: const Color(0xFF374151),
                onTap: () => showNotAvailable(context, 'Sharing'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('share_$label'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 8)),
          ],
        ),
      ),
    );
  }
}
