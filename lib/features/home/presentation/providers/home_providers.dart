import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RideMode { ride, share }

/// Which of the two booking modes is highlighted on Home.
class HomeRideMode extends Notifier<RideMode> {
  @override
  RideMode build() => RideMode.share;

  void select(RideMode mode) => state = mode;
}

final homeRideModeProvider = NotifierProvider<HomeRideMode, RideMode>(
  HomeRideMode.new,
);
