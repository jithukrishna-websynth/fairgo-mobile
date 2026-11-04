import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';

class _Method {
  const _Method(this.id, this.name, this.mark);

  final String id;
  final String name;
  final Widget mark;
}

const _methods = [
  _Method('gpay', 'UPI (GPay)', _GPayMark()),
  _Method('phonepe', 'PhonePe', _PhonePeMark()),
  _Method('paytm', 'Paytm', _PaytmMark()),
  _Method('card', 'Credit / Debit Card', Icon(Icons.credit_card, size: 16)),
  _Method('cash', 'Cash', Icon(Icons.payments_outlined, size: 16)),
];

/// DEMO: no payment is processed; "Pay" just continues to the receipt.
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _useWallet = true;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedPaymentMethodProvider);
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
                    'Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Safe. Simple. Flexible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _TripFareCard(),
                  const SizedBox(height: 12),
                  _WalletRow(
                    value: _useWallet,
                    onChanged: (v) => setState(() => _useWallet = v),
                  ),
                  const SizedBox(height: 10),
                  for (final m in _methods)
                    _MethodRow(
                      method: m,
                      selected: m.id == selected,
                      onTap: () => ref
                          .read(selectedPaymentMethodProvider.notifier)
                          .select(m.id),
                    ),
                  const Divider(height: 1),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 12, color: AppColors.forest),
                        SizedBox(width: 4),
                        Text(
                          'Add New Payment Method',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              label: 'Pay ₹120',
              onPressed: () => context.push(AppRoutes.tripReceipt),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, size: 10, color: AppColors.forest),
                SizedBox(width: 4),
                Text(
                  'Your payments are secure',
                  style: TextStyle(fontSize: 8, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TripFareCard extends StatelessWidget {
  const _TripFareCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Text(
            '₹120',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
          Text(
            'Trip Fare',
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            size: 13,
            color: AppColors.lime,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use Wallet Balance',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
              Text(
                '₹200 available',
                style: TextStyle(fontSize: 8, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Switch(
          key: const Key('wallet_switch'),
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.forest,
        ),
      ],
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final _Method method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('method_${method.id}'),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.fieldFill : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? null
              : const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            SizedBox(width: 28, child: Center(child: method.mark)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                method.name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            selected
                ? const CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.forest,
                    child: Icon(Icons.check, size: 10, color: Colors.white),
                  )
                : Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD0D0D0)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Simplified brand marks; swap for the official logos when supplied.
class _GPayMark extends StatelessWidget {
  const _GPayMark();

  @override
  Widget build(BuildContext context) => const Text(
    'G Pay',
    style: TextStyle(
      fontSize: 7,
      fontWeight: FontWeight.w700,
      color: Color(0xFF4285F4),
    ),
  );
}

class _PhonePeMark extends StatelessWidget {
  const _PhonePeMark();

  @override
  Widget build(BuildContext context) => Container(
    width: 18,
    height: 18,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: Color(0xFF5F259F),
      shape: BoxShape.circle,
    ),
    child: const Text('पे', style: TextStyle(fontSize: 8, color: Colors.white)),
  );
}

class _PaytmMark extends StatelessWidget {
  const _PaytmMark();

  @override
  Widget build(BuildContext context) => const Text(
    'Paytm',
    style: TextStyle(
      fontSize: 7,
      fontWeight: FontWeight.w800,
      color: Color(0xFF0B3C7D),
    ),
  );
}
