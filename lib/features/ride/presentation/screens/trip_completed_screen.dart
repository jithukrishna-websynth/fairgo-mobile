import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/map_sheet_layout.dart';

/// DEMO content: fares and savings are static until the trip API exists.
class TripCompletedScreen extends StatefulWidget {
  const TripCompletedScreen({super.key});

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  int _rating = 0;
  final _feedback = TextEditingController();

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.25,
      pins: const [
        MapPin('Castle Restaurant', 0.27, 0.3),
        MapPin('Abees Mess', 0.55, 0.52),
      ],
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
                    'Trip Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Thank you for choosing Fairgo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _FareSummary(),
                  const SizedBox(height: 10),
                  InkWell(
                    key: const Key('trip_details_row'),
                    onTap: () => context.push(AppRoutes.tripReceipt),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 22),
                          Text(
                            'Trip Details',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'How was your ride?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        GestureDetector(
                          key: Key('star_$i'),
                          onTap: () => setState(() => _rating = i),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.star_rounded,
                              size: 22,
                              color: i <= _rating
                                  ? const Color(0xFFF5A623)
                                  : const Color(0xFFD9D9D9),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: const Key('feedback_field'),
                    controller: _feedback,
                    minLines: 3,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Share your experience (optional)',
                      hintStyle: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Payment',
              onPressed: () => context.push(AppRoutes.payment),
            ),
          ],
        ),
      ),
    );
  }
}

class _FareSummary extends StatelessWidget {
  const _FareSummary();

  @override
  Widget build(BuildContext context) {
    Widget column(String value, String caption, [String? extra]) => Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          caption,
          style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
        ),
        if (extra != null)
          Text(
            extra,
            style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
          ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          column('₹120', 'Total Fare'),
          column('₹60', 'Your Share', '(Shared Ride)'),
        ],
      ),
    );
  }
}
