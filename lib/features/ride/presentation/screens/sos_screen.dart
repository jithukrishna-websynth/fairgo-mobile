import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/sheet_header.dart';

/// Flip to true only once SOS really alerts emergency contacts and the safety
/// team. Until then the screen is visibly marked as a demo, so nobody is told
/// help is coming when no alert has been sent.
const sosIntegrated = false;

const _sosRed = Color(0xFFE53935);

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.18,
      pins: const [],
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            SheetHeader(title: 'Emergency SOS', onClose: () => context.pop()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 14),
                  const Center(child: _Pulse()),
                  const SizedBox(height: 14),
                  const Text(
                    'SOS Activated',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Help is on the way',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Color(0xFFF08A8A)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'We are sharing your live location with\n'
                    'emergency contacts and our safety team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8,
                      height: 1.4,
                      color: Color(0xFFF08A8A),
                    ),
                  ),
                  if (!sosIntegrated) ...[
                    const SizedBox(height: 10),
                    Container(
                      key: const Key('sos_demo_notice'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'DEMO ONLY: no alert has been sent. '
                        'In an emergency call your local emergency number.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: Color(0xFF8A5A00)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  InkWell(
                    key: const Key('safety_row'),
                    onTap: () => context.push(AppRoutes.safety),
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
                      child: const Text(
                        'Safety & Emergency',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: FilledButton.icon(
                key: const Key('cancel_sos'),
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, size: 14, color: Colors.white),
                label: const Text(
                  'Cancel SOS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _sosRed,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pulse extends StatelessWidget {
  const _Pulse();

  @override
  Widget build(BuildContext context) {
    Widget ring(double size, double alpha) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _sosRed.withValues(alpha: alpha),
      ),
    );
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ring(120, 0.10),
          ring(94, 0.18),
          ring(68, 0.30),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _sosRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications,
              size: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
