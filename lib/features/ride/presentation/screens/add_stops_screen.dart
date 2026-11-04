import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/ride_providers.dart';
import '../widgets/map_sheet_layout.dart';

class AddStopsScreen extends ConsumerWidget {
  const AddStopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stops = ref.watch(routeStopsProvider);
    final last = stops.length - 1;

    return MapSheetLayout(
      mapFraction: 0.34,
      sheet: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            const Text(
              'Add Stops',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24),
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: stops.length,
                // onReorder works on every supported Flutter; newer ones deprecate it.
                // ignore: deprecated_member_use
                onReorder: (oldIndex, newIndex) => ref
                    .read(routeStopsProvider.notifier)
                    .reorder(
                      oldIndex,
                      newIndex > oldIndex ? newIndex - 1 : newIndex,
                    ),
                itemBuilder: (_, i) {
                  final isLast = i == last;
                  return Column(
                    key: ValueKey('stop_$i${stops[i].name}'),
                    children: [
                      if (isLast) ...[
                        _AddAnotherStop(
                          onTap: () => context.push(AppRoutes.addStop),
                        ),
                        const SizedBox(height: 8),
                      ],
                      _StopRow(
                        index: i,
                        label: stops[i].name,
                        isDropOff: isLast,
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
            const _InfoBox(),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Done',
              onPressed: () {
                ref.read(homeDestinationProvider.notifier).set(stops.last);
                context.push(AppRoutes.chooseRide);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.index,
    required this.label,
    required this.isDropOff,
  });

  final int index;
  final String label;
  final bool isDropOff;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 11,
            backgroundColor: isDropOff ? AppColors.limeTint : AppColors.forest,
            child: isDropOff
                ? const Icon(
                    Icons.place,
                    size: 13,
                    color: AppColors.forestLight,
                  )
                : Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          ReorderableDragStartListener(
            index: index,
            child: const Icon(
              Icons.drag_handle,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddAnotherStop extends StatelessWidget {
  const _AddAnotherStop({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('add_another_stop'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.forest,
                child: Icon(Icons.add, size: 14, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text(
                'Add another stop',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      );
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 8) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.limeTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, size: 14, color: AppColors.forestLight),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You can add multiple stops.',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                Text(
                  'The driver will follow the order you set.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
