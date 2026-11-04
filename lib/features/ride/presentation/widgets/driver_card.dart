import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// DEMO content: driver and vehicle details are static until dispatch exists.
class DriverCard extends StatelessWidget {
  const DriverCard({super.key, this.showActions = true});

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.border,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  const Text('☆ 4.86', style: TextStyle(fontSize: 8)),
                  const SizedBox(height: 4),
                  const Text(
                    'NAGARAJA',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'AP03AS2058',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Red Yamaha Crux',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '4,111 trips',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _ActionButton(icon: Icons.message, label: 'Message'),
                ),
                SizedBox(width: 8),
                _ActionButton(icon: Icons.phone, square: true),
                SizedBox(width: 8),
                _ActionButton(icon: Icons.more_horiz, square: true),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Message/call/more are inert until chat and calling are integrated.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, this.label, this.square = false});

  final IconData icon;
  final String? label;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: square ? 40 : null,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}
