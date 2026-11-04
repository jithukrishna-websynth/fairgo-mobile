import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/url_launcher_dialer.dart';
import '../../domain/emergency_dialer.dart';

final emergencyDialerProvider = Provider<EmergencyDialer>(
  (ref) => UrlLauncherDialer(),
);
