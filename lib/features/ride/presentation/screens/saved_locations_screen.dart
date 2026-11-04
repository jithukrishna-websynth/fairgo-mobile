import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../data/demo_places.dart';
import '../widgets/trip_actions.dart';

enum _Filter { all, home, work, others }

/// Tapping a location pops with its [Place] so the caller can use it.
/// Add New and the per-row menu are inert until saved addresses are editable.
class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  _Filter _filter = _Filter.all;

  bool _matches(SavedLocation l) => switch (_filter) {
    _Filter.all => true,
    _Filter.home => l.category == SavedCategory.home,
    _Filter.work => l.category == SavedCategory.work,
    _Filter.others => l.category == SavedCategory.other,
  };

  @override
  Widget build(BuildContext context) {
    final items = savedLocations.where(_matches).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Saved Locations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  for (final f in _Filter.values) ...[
                    _FilterChip(
                      label: switch (f) {
                        _Filter.all => 'All',
                        _Filter.home => 'Home',
                        _Filter.work => 'Work',
                        _Filter.others => 'Others',
                      },
                      selected: f == _filter,
                      onTap: () => setState(() => _filter = f),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                children: [
                  for (final l in items) ...[
                    _LocationRow(
                      location: l,
                      onTap: () => context.pop(l.place),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: Text('No saved locations')),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: InkWell(
                      key: const Key('add_new_location'),
                      onTap: () =>
                          showNotAvailable(context, 'Adding a location'),
                      child: const Center(
                        child: Text(
                          '+ Add New',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forest,
                          ),
                        ),
                      ),
                    ),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('filter_$label'),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.lime : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.forest : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location, required this.onTap});

  final SavedLocation location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: Key('saved_${location.name}'),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(
                location.icon,
                size: 16,
                color: location.starred
                    ? const Color(0xFFF5A623)
                    : AppColors.forest,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      location.subtitle,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
