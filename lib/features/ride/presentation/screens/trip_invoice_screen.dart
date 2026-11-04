import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/vehicle.dart';
import '../../../../core/widgets/fair_go_logo.dart';
import '../../../../core/widgets/vehicle_icon.dart';
import '../widgets/trip_actions.dart';

/// DEMO content copied from the design; the figures do not add up
/// (320 + 20 + 10 - 50 is 300, not 340), so confirm them with the pricing
/// rules before using real data. Downloading is not implemented.
class TripInvoiceScreen extends StatelessWidget {
  const TripInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Trip Receipt',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    children: [
                      _Header(),
                      SizedBox(height: 10),
                      _TripDetailsCard(),
                      SizedBox(height: 10),
                      _FareCard(),
                      SizedBox(height: 10),
                      _PaymentCard(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: FilledButton.icon(
                  key: const Key('download_invoice'),
                  onPressed: () =>
                      showNotAvailable(context, 'Invoice download'),
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text(
                    'Download Invoice',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        FairGoLogo(width: 76),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '15 Oct 2026',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
            ),
            Text(
              '09:42 AM',
              style: TextStyle(fontSize: 8, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _TripDetailsCard extends StatelessWidget {
  const _TripDetailsCard();

  @override
  Widget build(BuildContext context) {
    Widget stop(Color color, String name, String time) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 9, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 9))),
          Text(
            time,
            style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
          ),
        ],
      ),
    );

    return _Section(
      title: 'Trip Details',
      child: Column(
        children: [
          stop(const Color(0xFF1DB77A), 'Kaloor, Kochi', '09:15 AM'),
          stop(const Color(0xFFE53935), 'Lulu Mall, Edapally', '09:42 AM'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                VehicleIcon(Vehicle.car, width: 36, color: AppColors.forest),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maruti Swift',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'KL 07 AB 1234',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FareCard extends StatelessWidget {
  const _FareCard();

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value, {Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: color ?? AppColors.textSecondary,
              fontWeight: color == null ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );

    return _Section(
      title: 'Fare Details',
      child: Column(
        children: [
          row('Base Fare', '₹320'),
          row('Distance (8.4 km)', '₹20'),
          row('Time Charge (22 mins)', '₹10'),
          row('Coupon Discount', '- ₹50', color: AppColors.forestLight),
          const Divider(height: 16),
          const Row(
            children: [
              Text(
                'Total Paid',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
              ),
              Spacer(),
              Text(
                '₹340',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return const _Section(
      title: 'Payment Method',
      child: Row(
        children: [
          Text(
            'G',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4285F4),
            ),
          ),
          SizedBox(width: 10),
          Text('UPI (Google Pay)', style: TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}
