import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/demo_places.dart';
import '../../domain/place.dart';
import '../providers/ride_providers.dart';
import '../widgets/place_tile.dart';

class ChangeDestinationScreen extends ConsumerStatefulWidget {
  const ChangeDestinationScreen({super.key});

  @override
  ConsumerState<ChangeDestinationScreen> createState() =>
      _ChangeDestinationScreenState();
}

class _ChangeDestinationScreenState
    extends ConsumerState<ChangeDestinationScreen> {
  Place? _selected;

  void _confirm() {
    final current = ref.read(homeDestinationProvider);
    ref.read(pendingDestinationProvider.notifier).set(_selected ?? current);
    context.push(AppRoutes.reviewFare);
  }

  @override
  Widget build(BuildContext context) {
    final destination = ref.watch(homeDestinationProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const Text(
                    'Change Destination',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(child: _RouteSummary(destination: destination.name)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    key: const Key('add_stop_circle'),
                    onTap: () => context.push(AppRoutes.addStop),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.add, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                itemCount: recentPlaces.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final place = recentPlaces[i];
                  return PlaceTile(
                    place: place,
                    selected: identical(place, _selected),
                    onTap: () => setState(() => _selected = place),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: PrimaryButton(
                label: 'Confirm New Destination',
                onPressed: _confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary({required this.destination});

  final String destination;

  @override
  Widget build(BuildContext context) {
    Widget row(Widget dot, String caption, String value) => Row(
      children: [
        SizedBox(width: 14, child: Center(child: dot)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 7,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          row(
            const Icon(Icons.circle, size: 8),
            'START LOCATION',
            'Your Current Location',
          ),
          const Divider(height: 16),
          row(
            const Icon(Icons.place, size: 13, color: Color(0xFFB7D22A)),
            'YOUR DESTINATION',
            destination,
          ),
        ],
      ),
    );
  }
}
