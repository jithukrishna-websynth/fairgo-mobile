/// Opens the phone's dialer. Kept behind an interface so tests can fake it.
abstract interface class EmergencyDialer {
  /// Returns false when no dialer could be opened.
  Future<bool> dial(String number);
}
