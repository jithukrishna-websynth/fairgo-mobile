import 'package:url_launcher/url_launcher.dart';

import '../domain/emergency_dialer.dart';

/// Opens the dialer with the number filled in; the user still presses call.
class UrlLauncherDialer implements EmergencyDialer {
  @override
  Future<bool> dial(String number) async {
    try {
      return await launchUrl(Uri(scheme: 'tel', path: number));
    } catch (_) {
      return false;
    }
  }
}
