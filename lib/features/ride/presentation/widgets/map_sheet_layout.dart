import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/map_placeholder.dart';

/// Map on top with a back button, rounded white sheet below.
class MapSheetLayout extends StatelessWidget {
  const MapSheetLayout({
    super.key,
    required this.sheet,
    this.mapFraction = 0.3,
    this.pins = defaultPins,
    this.mapOverlay,
  });

  final Widget sheet;
  final double mapFraction;
  final List<MapPin> pins;

  /// Drawn over the map area (e.g. a centre pin), below the sheet.
  final Widget? mapOverlay;

  static const defaultPins = [
    MapPin('Castle Restaurant', 0.2, 0.28),
    MapPin('Abees Mess', 0.56, 0.52),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: height * (mapFraction + 0.05),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MapPlaceholder(pins: pins),
                ?mapOverlay,
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 1,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => context.pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.chevron_left, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: height * mapFraction,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(child: sheet),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
