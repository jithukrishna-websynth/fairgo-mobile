import 'package:flutter/material.dart';

/// Centred sheet title with an optional close (X) button on the right.
class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.title, this.onClose});

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onClose != null)
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    key: const Key('sheet_close'),
                    behavior: HitTestBehavior.opaque,
                    onTap: onClose,
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 18),
      ],
    );
  }
}
