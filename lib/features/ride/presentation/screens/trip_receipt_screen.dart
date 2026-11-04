import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';

/// DEMO content: receipt data is static until the trip API exists.
/// Download Invoice and Get Help are inert until those features are built.
class TripReceiptScreen extends ConsumerWidget {
  const TripReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method =
        paymentMethodLabels[ref.watch(selectedPaymentMethodProvider)]!;
    return MapSheetLayout(
      mapFraction: 0.12,
      pins: const [],
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.lg,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Text(
                    'Trip Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Divider(height: 22),
                  Row(
                    children: [
                      const Text(
                        '12 Jan 2026, 09:42 AM',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFF2E3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Shared Ride',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(height: 108, child: MapPlaceholder()),
                  ),
                  const SizedBox(height: 12),
                  _FareDetails(paymentMethod: method),
                  const SizedBox(height: 10),
                  _LinkRow(
                    key: const Key('open_invoice'),
                    icon: Icons.file_download_outlined,
                    title: 'Download Invoice',
                    subtitle: 'GST compliant invoice',
                    onTap: () => context.push(AppRoutes.tripInvoice),
                  ),
                  const SizedBox(height: 8),
                  const _LinkRow(
                    icon: Icons.help_outline,
                    title: 'Get Help',
                    subtitle: "Need support? We're here.",
                  ),
                  const SizedBox(height: 8),
                  _LinkRow(
                    key: const Key('book_again'),
                    icon: Icons.sms_outlined,
                    title: 'Book Again',
                    subtitle: 'Same route, easier next time.',
                    onTap: () {
                      // Home underneath, then the fare choice for the same route.
                      final router = GoRouter.of(context);
                      router.go(AppRoutes.home);
                      router.push(AppRoutes.chooseRide);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Book a New Ride',
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}

class _FareDetails extends StatelessWidget {
  const _FareDetails({required this.paymentMethod});

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value, {Color? valueColor}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fare Details',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          row('Total Fare', '₹120'),
          row('Your Share', '₹60'),
          row('Saved Amount', '- ₹60', valueColor: AppColors.forestLight),
          row('Payment Method', paymentMethod),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final VoidCallback? onTap;

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
