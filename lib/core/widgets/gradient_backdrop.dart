import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// White screen with the soft lime glow from the top-right corner.
class GradientBackdrop extends StatelessWidget {
  const GradientBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.1,
          colors: [Color(0xFFE3EE9A), AppColors.background],
          stops: [0, 0.7],
        ),
      ),
      child: child,
    );
  }
}
