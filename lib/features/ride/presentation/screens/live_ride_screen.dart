import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/driver_card.dart';
import '../widgets/map_sheet_layout.dart';
import '../widgets/trip_actions.dart';

/// DEMO content: live-track times and fare range are static until the trip
/// API exists. Chat is inert until messaging is integrated.
class LiveRideScreen extends StatelessWidget {
  const LiveRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapSheetLayout(
      mapFraction: 0.2,
      pins: const [],
      mapOverlay: const _OnTheWayBanner(),
      sheet: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              children: [
                const Text(
                  'Active Ride',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Divider(height: 22),
                const DriverCard(),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundActionButton(
                      icon: Icons.phone,
                      label: 'Contact',
                      onTap: () => context.push(AppRoutes.contactDriver),
                    ),
                    RoundActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onTap: () => showNotAvailable(context, 'Chat'),
                    ),
                    SosActionButton(onTap: () => context.push(AppRoutes.sos)),
                  ],
                ),
                const SizedBox(height: 14),
                const _LiveTrack(),
              ],
            ),
          ),
          const _EstimatedFareBar(),
        ],
      ),
    );
  }
}

class _OnTheWayBanner extends StatelessWidget {
  const _OnTheWayBanner();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(56, 12, 16, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.forest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: Color(0xFF1E5A3D),
                  child: Icon(
                    Icons.navigation,
                    size: 10,
                    color: AppColors.lime,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'On the way to destination',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '12 mins • 4.8 km',
                      style: TextStyle(color: Color(0xFFB8C9BE), fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveTrack extends StatelessWidget {
  const _LiveTrack();

  @override
  Widget build(BuildContext context) {
    Widget step({
      required Widget dot,
      required String title,
      required String subtitle,
      String? time,
    }) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 14, child: Center(child: dot)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (time != null)
          Text(
            time,
            style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
          ),
      ],
    );

    Widget dot(Color color, {bool hollow = false}) => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: hollow ? Colors.white : color,
        shape: BoxShape.circle,
        border: hollow ? Border.all(color: color, width: 1.5) : null,
      ),
    );

    const green = Color(0xFF1DB77A);
    const red = Color(0xFFE53935);
    const line = SizedBox(
      width: 14,
      height: 16,
      child: Center(
        child: VerticalDivider(
          width: 1,
          thickness: 1,
          color: Color(0xFF9ED9BF),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Track',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          step(
            dot: dot(green),
            title: 'Pickup',
            subtitle: 'Kaloor, Kochi',
            time: '09:15 AM',
          ),
          Align(alignment: Alignment.centerLeft, child: line),
          step(
            dot: dot(green, hollow: true),
            title: 'On the way',
            subtitle: '12 mins • 4.8 km',
          ),
          Align(alignment: Alignment.centerLeft, child: line),
          step(
            dot: dot(red),
            title: 'Drop',
            subtitle: 'Lulu Mall, Edapally',
            time: '09:38 AM',
          ),
        ],
      ),
    );
  }
}

class _EstimatedFareBar extends StatelessWidget {
  const _EstimatedFareBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        10,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTIMATED FARE',
                style: TextStyle(
                  fontSize: 7,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹320 - ₹360',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            key: const Key('live_share_trip'),
            onPressed: () => context.push(AppRoutes.shareTrip),
            icon: const Icon(Icons.share, size: 12, color: AppColors.lime),
            label: const Text(
              'Share Trip',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.lime,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.forest,
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
