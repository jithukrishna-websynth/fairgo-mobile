import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../data/demo_places.dart';
import '../../domain/place.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/place_tile.dart';

class AddStopSearchScreen extends ConsumerStatefulWidget {
  const AddStopSearchScreen({super.key});

  @override
  ConsumerState<AddStopSearchScreen> createState() =>
      _AddStopSearchScreenState();
}

class _AddStopSearchScreenState extends ConsumerState<AddStopSearchScreen> {
  String _query = '';

  void _select(Place place) {
    ref.read(routeStopsProvider.notifier).addStop(place);
    context.pop();
  }

  Future<void> _openSaved() async {
    final place = await context.push<Place>(AppRoutes.savedLocations);
    if (place != null && mounted) _select(place);
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = recentPlaces
        .take(4)
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();

    return MapSheetLayout(
      mapFraction: 0.27,
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          0,
        ),
        child: Column(
          children: [
            const Text(
              'Add a Stops',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24),
            TextField(
              key: const Key('search_destination'),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search destination',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final p in results) ...[
                    PlaceTile(place: p, onTap: () => _select(p)),
                    const SizedBox(height: 8),
                  ],
                  if (results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: Text('No places found')),
                    ),
                  _SavedAddressRow(
                    onTap: () => _select(savedAddress),
                    onMore: _openSaved,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedAddressRow extends StatelessWidget {
  const _SavedAddressRow({required this.onTap, required this.onMore});

  final VoidCallback onTap;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.fieldFill,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.home_rounded, size: 18),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Address',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Palarivattom, Kochi',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                key: const Key('saved_more'),
                onTap: onMore,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.more_horiz, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
