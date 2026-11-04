import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight - 4,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SizedBox(width: 18, height: 18, child: icon),
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
