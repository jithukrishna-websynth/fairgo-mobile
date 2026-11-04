import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/vehicle.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/vehicle_icon.dart';
import '../../data/demo_ride_options.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/share_ride_card.dart';

/// Women-only tiers are shown as designed; eligibility is not enforced
/// anywhere yet (that needs verified rider profiles and a backend).
class SelectCabTierScreen extends ConsumerStatefulWidget {
  const SelectCabTierScreen({super.key});

  @override
  ConsumerState<SelectCabTierScreen> createState() =>
      _SelectCabTierScreenState();
}

class _SelectCabTierScreenState extends ConsumerState<SelectCabTierScreen> {
  bool _shareSelected = false;

  @override
  Widget build(BuildContext context) {
    final tierId = ref.watch(selectedCabTierProvider);

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
              'Select a Cab',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ShareRideCard(
                    selected: _shareSelected,
                    onTap: () => setState(() => _shareSelected = true),
                  ),
                  const SizedBox(height: 10),
                  for (final tier in cabTiers) ...[
                    _TierTile(
                      tier: tier,
                      selected: !_shareSelected && tier.id == tierId,
                      onTap: () {
                        setState(() => _shareSelected = false);
                        ref
                            .read(selectedCabTierProvider.notifier)
                            .select(tier.id);
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Continue',
              onPressed: () => context.push(
                _shareSelected ? AppRoutes.sharedRide : AppRoutes.pickupDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierTile extends StatelessWidget {
  const _TierTile({
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  final CabTier tier;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('tier_${tier.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: const BoxConstraints(minHeight: 66),
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
            const SizedBox(
              width: 58,
              child: VehicleIcon(
                Vehicle.car,
                width: 50,
                color: AppColors.forest,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        tier.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (tier.womenOnly)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE3EE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Women only',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD6336C),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '3:33pm · 5 min',
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Text(
              tier.price,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
