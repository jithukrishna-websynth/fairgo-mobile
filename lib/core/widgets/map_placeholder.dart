import 'package:flutter/material.dart';

/// Static stand-in for the live map until a map SDK/API key is integrated.
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.pins = const []});

  /// Labelled pins, positioned by fractional offset within the map.
  final List<MapPin> pins;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          for (final pin in pins)
            Positioned(
              left: pin.dx * c.maxWidth,
              top: pin.dy * c.maxHeight,
              child: _PinChip(label: pin.label),
            ),
        ],
      ),
    );
  }
}

class MapPin {
  const MapPin(this.label, this.dx, this.dy);

  final String label;
  final double dx;
  final double dy;
}

class _PinChip extends StatelessWidget {
  const _PinChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.chevron_right, size: 13),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE9E6DD),
    );
    final block = Paint()..color = const Color(0xFFF1EEE4);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 5;
    final thin = Paint()
      ..color = const Color(0xFFFAF9F4)
      ..strokeWidth = 2;
    for (var x = -20.0; x < size.width + 40; x += 46) {
      canvas.drawLine(Offset(x, 0), Offset(x + 40, size.height), road);
    }
    for (var y = 6.0; y < size.height; y += 38) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 22), thin);
    }
    for (var y = 20.0; y < size.height; y += 76) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 18), block);
    }
    canvas.drawCircle(
      Offset(size.width * 0.62, size.height * 0.52),
      size.shortestSide * 0.16,
      Paint()..color = const Color(0xFFCFE6B8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
