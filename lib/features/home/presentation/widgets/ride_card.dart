import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/vehicle.dart';
import '../../../../core/widgets/vehicle_icon.dart';
import '../providers/home_providers.dart';
import 'glass_card.dart';

/// "Choose Your Ride" card plus the start/destination card beneath it.
class RideCard extends StatelessWidget {
  const RideCard({
    super.key,
    required this.destination,
    required this.mode,
    required this.onModeChanged,
    required this.onPlan,
    required this.onBook,
  });

  final RideMode mode;
  final ValueChanged<RideMode> onModeChanged;

  final String destination;
  final VoidCallback onPlan;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 0, 12),
                child: Text(
                  'Choose Your Ride',
                  style: TextStyle(fontSize: 11, color: AppColors.textPrimary),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _ModeTile(
                      key: const Key('mode_ride'),
                      label: 'Ride',
                      iconBuilder: (c) =>
                          VehicleIcon(Vehicle.car, width: 22, color: c),
                      selected: mode == RideMode.ride,
                      onTap: () => onModeChanged(RideMode.ride),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ModeTile(
                      key: const Key('mode_share'),
                      label: 'Share a Ride',
                      iconBuilder: (c) => Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: c,
                      ),
                      selected: mode == RideMode.share,
                      onTap: () => onModeChanged(RideMode.share),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          child: Column(
            children: [
              _Timeline(destination: destination, onTap: onPlan),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton(
                  key: const Key('book_ride'),
                  onPressed: onBook,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Book a Ride',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    super.key,
    required this.label,
    required this.iconBuilder,
    required this.selected,
    required this.onTap,
  });

  final VoidCallback onTap;

  final String label;
  final Widget Function(Color color) iconBuilder;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.lime : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.forest : const Color(0xFFF4F6FB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ),
            iconBuilder(selected ? AppColors.lime : Colors.black54),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.destination, required this.onTap});

  final String destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LocationRow(
          dot: const _StartDot(),
          caption: 'START LOCATION',
          value: 'Your Current Location',
          onTap: onTap,
        ),
        Row(
          children: [
            const SizedBox(
              width: 24,
              height: 14,
              child: Center(
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFC9CDB4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Divider(height: 1, color: Color(0xFFDDE2C6))),
          ],
        ),
        _LocationRow(
          dot: const _DestinationDot(),
          caption: 'YOUR DESTINATION',
          value: destination,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _StartDot extends StatelessWidget {
  const _StartDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF8A8F7A)),
      ),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF6E7360),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DestinationDot extends StatelessWidget {
  const _DestinationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      child: const Icon(Icons.place, size: 18, color: Color(0xFFB7D22A)),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.dot,
    required this.caption,
    required this.value,
    required this.onTap,
  });

  final Widget dot;
  final String caption;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(width: 24, child: Center(child: dot)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
