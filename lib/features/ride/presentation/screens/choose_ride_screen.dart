import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/vehicle_icon.dart';
import '../../data/demo_ride_options.dart';
import '../../domain/ride_option.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/share_ride_card.dart';

const _mutedIcon = Color(0xFF59636F);

class ChooseRideScreen extends ConsumerWidget {
  const ChooseRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedRideOptionProvider);
    final isShared = selectedId == sharedRideId;
    final label = isShared
        ? 'Choose Share a Ride'
        : 'Choose ${rideOptions.firstWhere((o) => o.id == selectedId).shortName}';

    return MapSheetLayout(
      mapFraction: 0.25,
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            const Text(
              'Choose a ride',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ShareRideCard(
                    selected: isShared,
                    onTap: () => ref
                        .read(selectedRideOptionProvider.notifier)
                        .select(sharedRideId),
                  ),
                  const SizedBox(height: 10),
                  for (final option in rideOptions) ...[
                    _RideOptionTile(
                      option: option,
                      selected: option.id == selectedId,
                      onTap: () => ref
                          .read(selectedRideOptionProvider.notifier)
                          .select(option.id),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: label,
              onPressed: () => context.push(
                isShared
                    ? AppRoutes.sharedRide
                    : selectedId == 'cab'
                    ? AppRoutes.cabTier
                    : AppRoutes.pickupDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RideOptionTile extends StatelessWidget {
  const _RideOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final RideOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('ride_${option.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: const BoxConstraints(minHeight: 78),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.forest : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              child: VehicleIcon(
                option.vehicle,
                width: 50,
                color: selected ? AppColors.forest : _mutedIcon,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          option.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (option.seats != null) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.person, size: 13),
                        Text(
                          '${option.seats}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (option.hasOffer) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.access_time_filled, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.time,
                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                  if (option.badge != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt,
                            size: 12,
                            color: AppColors.lime,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            option.badge!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.hasOffer)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.local_offer,
                          size: 13,
                          color: AppColors.error,
                        ),
                      ),
                    Text(
                      option.price,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (option.oldPrice != null)
                  Text(
                    option.oldPrice!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
