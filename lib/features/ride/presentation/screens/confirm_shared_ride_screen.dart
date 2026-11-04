import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/map_sheet_layout.dart';

/// DEMO content: co-riders and fares are static until the sharing API exists.
class ConfirmSharedRideScreen extends StatelessWidget {
  const ConfirmSharedRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.25,
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.sm,
        ),
        child: Column(
          children: [
            const Text(
              'Confirm Shared Ride',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  _SharingCard(),
                  SizedBox(height: 14),
                  Text(
                    'Payment',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  _FareRow(label: 'Total Fare', value: '₹360'),
                  SizedBox(height: 8),
                  _YourShareRow(),
                  SizedBox(height: 12),
                  _PaymentMethodRow(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Confirm & Share Ride',
              onPressed: () => context.push(AppRoutes.pickupDetails),
            ),
            const SizedBox(height: 6),
            const Text(
              "You'll save ₹70 on this ride",
              style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _SharingCard extends StatelessWidget {
  const _SharingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Text(
                'Sharing with',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                'View route',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _RiderRow(
            name: 'You',
            subtitle: 'Joined',
            subtitleColor: AppColors.forestLight,
            top: 'Pickup at your location',
          ),
          SizedBox(height: 12),
          _RiderRow(
            name: 'Arjun',
            rating: '4.8',
            top: 'Same route',
            bottom: 'Pickup in 2 min',
          ),
          SizedBox(height: 12),
          _RiderRow(
            name: 'Meera',
            rating: '4.9',
            top: 'Same route',
            bottom: 'Pickup in 4 min',
          ),
        ],
      ),
    );
  }
}

class _RiderRow extends StatelessWidget {
  const _RiderRow({
    required this.name,
    required this.top,
    this.subtitle,
    this.subtitleColor,
    this.rating,
    this.bottom,
  });

  final String name;
  final String top;
  final String? subtitle;
  final Color? subtitleColor;
  final String? rating;
  final String? bottom;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.border,
          child: Text(
            name[0],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.forest,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                ),
              if (rating != null)
                Row(
                  children: [
                    Text(rating!, style: const TextStyle(fontSize: 9)),
                    const Icon(Icons.star, size: 10, color: Color(0xFFF5A623)),
                  ],
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              top,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
            if (bottom != null)
              Text(
                bottom!,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E7A),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 10)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _YourShareRow extends StatelessWidget {
  const _YourShareRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Your Share',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        const Text(
          '₹120',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFDFF2E3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '50% less',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: AppColors.forestLight,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const _GPayDots(),
          const SizedBox(width: 8),
          const Text(
            'UPI (GPay)',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.forest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Change',
              style: TextStyle(fontSize: 9, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _GPayDots extends StatelessWidget {
  const _GPayDots();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c) => Container(
      width: 5,
      height: 5,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );
    return Row(
      children: [
        dot(const Color(0xFF4285F4)),
        dot(const Color(0xFFEA4335)),
        dot(const Color(0xFF34A853)),
      ],
    );
  }
}
