import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../ride/presentation/providers/ride_providers.dart';
import '../widgets/arriving_banner.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/ride_card.dart';
import '../widgets/service_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = ref.watch(homeDestinationProvider);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE4EE9C), Color(0xFFF0F5CE), Colors.white],
            stops: [0, 0.6, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HomeHeader(),
                      const SizedBox(height: 12),
                      RideCard(
                        destination: destination.name,
                        onPlan: () => context.push(AppRoutes.planRide),
                        onBook: () => context.push(AppRoutes.planRide),
                      ),
                      const SizedBox(height: 18),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Choose a service',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const ServiceGrid(),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: ArrivingBanner(),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 0, 14, 8),
                child: HomeBottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4),
        const Icon(Icons.location_on_outlined, size: 20),
        const SizedBox(width: 6),
        const Text(
          '39/93, Annur Rd',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const Icon(Icons.keyboard_arrow_down, size: 18),
        const Spacer(),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications_none, size: 18),
        ),
      ],
    );
  }
}
