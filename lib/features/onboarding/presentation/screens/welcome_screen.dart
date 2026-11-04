import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _imageTopFraction = 0.28;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          // Car photo fills the lower part of the screen (cropped to fit),
          // fading into white beneath the heading.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.sizeOf(context).height * _imageTopFraction,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/welcome_car.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(-0.7, 0),
                  errorBuilder: (_, error, _) {
                    debugPrint('Welcome image failed to load: $error');
                    return const SizedBox.shrink();
                  },
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0, -0.4),
                      colors: [Colors.white, Color(0x00FFFFFF)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text.rich(
                    const TextSpan(
                      children: [
                        TextSpan(text: 'Request '),
                        TextSpan(
                          text: 'Your',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(text: '\nRide in Seconds'),
                      ],
                    ),
                    style: textTheme.headlineSmall?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Ride smarter with fast pickups, real-time tracking, '
                    'and smooth travel anywhere in the city.',
                    style: textTheme.bodySmall,
                  ),
                  const Spacer(),
                  _SwipeToStart(
                    onCompleted: () => context.go(AppRoutes.language),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Slide-to-continue bar: drag the arrow to the right end to proceed.
class _SwipeToStart extends StatefulWidget {
  const _SwipeToStart({required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<_SwipeToStart> createState() => _SwipeToStartState();
}

class _SwipeToStartState extends State<_SwipeToStart> {
  static const _height = 56.0;
  static const _thumb = 40.0;
  static const _inset = 8.0;
  static const _completeAt = 0.7;

  double _dx = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDx = constraints.maxWidth - _thumb - _inset * 2;
        final progress = maxDx <= 0 ? 0.0 : (_dx / maxDx).clamp(0.0, 1.0);

        // The whole bar listens for the drag, so the arrow is easy to move.
        return GestureDetector(
          key: const Key('swipe_to_start'),
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) => setState(() => _dragging = true),
          onHorizontalDragUpdate: (d) =>
              setState(() => _dx = (_dx + d.delta.dx).clamp(0.0, maxDx)),
          onHorizontalDragEnd: (_) {
            final done = maxDx > 0 && _dx / maxDx >= _completeAt;
            setState(() {
              _dragging = false;
              _dx = done ? maxDx : 0;
            });
            if (done) widget.onCompleted();
          },
          onHorizontalDragCancel: () => setState(() {
            _dragging = false;
            _dx = 0;
          }),
          child: Container(
            height: _height,
            decoration: BoxDecoration(
              color: AppColors.forest,
              borderRadius: BorderRadius.circular(_height),
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 1 - progress,
                    child: const Text(
                      'Swipe to Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  key: const Key('swipe_thumb'),
                  duration: _dragging
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  left: _inset + _dx,
                  top: (_height - _thumb) / 2,
                  child: Container(
                    width: _thumb,
                    height: _thumb,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: AppColors.forest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
