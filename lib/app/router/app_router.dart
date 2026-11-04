import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/otp_screen.dart';
import '../../features/authentication/presentation/screens/phone_login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/language_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/ride/presentation/screens/cancel_reason_screen.dart';
import '../../features/ride/presentation/screens/cancel_request_screen.dart';
import '../../features/ride/presentation/screens/change_destination_screen.dart';
import '../../features/ride/presentation/screens/contact_driver_screen.dart';
import '../../features/ride/presentation/screens/live_ride_screen.dart';
import '../../features/ride/presentation/screens/review_fare_screen.dart';
import '../../features/ride/presentation/screens/saved_locations_screen.dart';
import '../../features/ride/presentation/screens/share_trip_screen.dart';
import '../../features/ride/presentation/screens/sos_screen.dart';
import '../../features/ride/presentation/screens/trip_invoice_screen.dart';
import '../../features/ride/presentation/screens/active_ride_screen.dart';
import '../../features/ride/presentation/screens/add_stop_search_screen.dart';
import '../../features/ride/presentation/screens/add_stops_screen.dart';
import '../../features/ride/presentation/screens/choose_ride_screen.dart';
import '../../features/ride/presentation/screens/confirm_pickup_spot_screen.dart';
import '../../features/ride/presentation/screens/confirm_shared_ride_screen.dart';
import '../../features/ride/presentation/screens/payment_screen.dart';
import '../../features/ride/presentation/screens/pickup_details_screen.dart';
import '../../features/ride/presentation/screens/plan_ride_screen.dart';
import '../../features/ride/presentation/screens/ride_details_screen.dart';
import '../../features/ride/presentation/screens/ride_requested_screen.dart';
import '../../features/ride/presentation/screens/ride_tracking_screen.dart';
import '../../features/ride/presentation/screens/trip_completed_screen.dart';
import '../../features/ride/presentation/screens/trip_receipt_screen.dart';
import '../../features/safety/presentation/screens/safety_emergency_screen.dart';
import '../../features/profile/presentation/screens/profile_setup_screen.dart';
import 'app_routes.dart';

GoRouter createRouter({String initialLocation = AppRoutes.splash}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
    GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomeScreen()),
    GoRoute(
      path: AppRoutes.language,
      builder: (_, _) => const LanguageScreen(),
    ),
    GoRoute(path: AppRoutes.login, builder: (_, _) => const PhoneLoginScreen()),
    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) =>
          OtpScreen(phoneNumber: state.uri.queryParameters['phone'] ?? ''),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (_, _) => const ProfileSetupScreen(),
    ),
    GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
    GoRoute(
      path: AppRoutes.planRide,
      builder: (_, _) => const PlanRideScreen(),
    ),
    GoRoute(path: AppRoutes.stops, builder: (_, _) => const AddStopsScreen()),
    GoRoute(
      path: AppRoutes.addStop,
      builder: (_, _) => const AddStopSearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.chooseRide,
      builder: (_, _) => const ChooseRideScreen(),
    ),
    GoRoute(
      path: AppRoutes.sharedRide,
      builder: (_, _) => const ConfirmSharedRideScreen(),
    ),
    GoRoute(
      path: AppRoutes.pickupDetails,
      builder: (_, _) => const PickupDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.rideRequested,
      builder: (_, _) => const RideRequestedScreen(),
    ),
    GoRoute(
      path: AppRoutes.rideTracking,
      builder: (_, _) => const RideTrackingScreen(),
    ),
    GoRoute(
      path: AppRoutes.rideDetails,
      builder: (_, _) => const RideDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.activeRide,
      builder: (_, _) => const ActiveRideScreen(),
    ),
    GoRoute(
      path: AppRoutes.tripCompleted,
      builder: (_, _) => const TripCompletedScreen(),
    ),
    GoRoute(path: AppRoutes.payment, builder: (_, _) => const PaymentScreen()),
    GoRoute(
      path: AppRoutes.tripReceipt,
      builder: (_, _) => const TripReceiptScreen(),
    ),
    GoRoute(
      path: AppRoutes.tripInvoice,
      builder: (_, _) => const TripInvoiceScreen(),
    ),
    GoRoute(
      path: AppRoutes.savedLocations,
      builder: (_, _) => const SavedLocationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.liveRide,
      builder: (_, _) => const LiveRideScreen(),
    ),
    GoRoute(
      path: AppRoutes.contactDriver,
      builder: (_, _) => const ContactDriverScreen(),
    ),
    GoRoute(
      path: AppRoutes.shareTrip,
      builder: (_, _) => const ShareTripScreen(),
    ),
    GoRoute(
      path: AppRoutes.changeDestination,
      builder: (_, _) => const ChangeDestinationScreen(),
    ),
    GoRoute(
      path: AppRoutes.reviewFare,
      builder: (_, _) => const ReviewFareScreen(),
    ),
    GoRoute(path: AppRoutes.sos, builder: (_, _) => const SosScreen()),
    GoRoute(
      path: AppRoutes.cancelRequest,
      builder: (_, _) => const CancelRequestScreen(),
    ),
    GoRoute(
      path: AppRoutes.cancelReason,
      builder: (_, _) => const CancelReasonScreen(),
    ),
    GoRoute(
      path: AppRoutes.safety,
      builder: (_, _) => const SafetyEmergencyScreen(),
    ),
    GoRoute(
      path: AppRoutes.pickupSpot,
      builder: (_, _) => const ConfirmPickupSpotScreen(),
    ),
  ],
);
