import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Dark-green round action button with a caption underneath.
class RoundActionButton extends StatelessWidget {
  const RoundActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.forest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}

/// Red SOS button. Opens the Emergency SOS screen.
class SosActionButton extends StatelessWidget {
  const SosActionButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sos_button'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: const Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'SOS',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Shown where a feature has no backend yet.
void showNotAvailable(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what isn\'t available yet.')));
}
