import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_page.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/home/presentation/home_screen.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/code_screen.dart';
import 'package:profitnet/features/onboarding/presentation/consents_screen.dart';
import 'package:profitnet/features/onboarding/presentation/interests_screen.dart';
import 'package:profitnet/features/onboarding/presentation/location_screen.dart';
import 'package:profitnet/features/onboarding/presentation/name_screen.dart';
import 'package:profitnet/features/onboarding/presentation/pending_otp_challenge.dart';
import 'package:profitnet/features/onboarding/presentation/phone_screen.dart';
import 'package:profitnet/features/onboarding/presentation/welcome_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Route locations. The signed-out steps are nested so that "back" walks
/// Code -> Phone -> Welcome; each post-verification step is a root of its
/// own, because a completed step cannot be undone by going back.
abstract final class AppRoutes {
  static const String welcome = '/welcome';
  static const String phone = '/welcome/phone';
  static const String code = '/welcome/phone/code';
  static const String consents = '/onboarding/consents';
  static const String name = '/onboarding/name';
  static const String location = '/onboarding/location';
  static const String interests = '/onboarding/interests';
  static const String home = '/home';

  static String forStep(OnboardingStep step) => switch (step) {
    OnboardingStep.consents => consents,
    OnboardingStep.name => name,
    OnboardingStep.location => location,
    OnboardingStep.interests => interests,
  };
}

/// Decides where the user is allowed to be. Returns the location to
/// redirect to, or `null` to stay at [location].
///
///  * no session -> the Welcome/Phone/Code stack (Code only while a code
///    is waiting to be entered);
///  * session with onboarding completed -> Home;
///  * session with onboarding in progress -> the saved step.
String? resolveRedirect({
  required SessionState session,
  required bool hasPendingOtpChallenge,
  required String location,
}) {
  final String target;
  switch (session) {
    case SignedOut():
      if (location == AppRoutes.welcome || location == AppRoutes.phone) {
        return null;
      }
      if (location == AppRoutes.code) {
        return hasPendingOtpChallenge ? null : AppRoutes.phone;
      }
      target = AppRoutes.welcome;
    case SignedIn(:final OnboardingStep? pendingStep):
      target = pendingStep == null
          ? AppRoutes.home
          : AppRoutes.forStep(pendingStep);
  }
  return location == target ? null : target;
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Re-evaluates the redirect whenever the session or the pending code
  // changes (sign-in, step completed, logout, expired session).
  final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  ref
    ..listen<SessionState>(
      sessionControllerProvider,
      (SessionState? _, SessionState _) => refresh.value++,
    )
    ..listen<OtpChallenge?>(
      pendingOtpChallengeProvider,
      (OtpChallenge? _, OtpChallenge? _) => refresh.value++,
    );

  GoRoute route(
    String path,
    Widget Function(BuildContext context) builder, {
    List<RouteBase> routes = const <RouteBase>[],
  }) => GoRoute(
    path: path,
    routes: routes,
    pageBuilder: (BuildContext context, GoRouterState state) =>
        buildAdaptivePage<void>(
          context: context,
          key: state.pageKey,
          name: state.fullPath,
          child: builder(context),
        ),
  );

  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.welcome,
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) => resolveRedirect(
      session: ref.read(sessionControllerProvider),
      hasPendingOtpChallenge: ref.read(pendingOtpChallengeProvider) != null,
      location: state.matchedLocation,
    ),
    routes: <RouteBase>[
      route(
        AppRoutes.welcome,
        (BuildContext context) =>
            WelcomeScreen(onStart: () => context.go(AppRoutes.phone)),
        routes: <RouteBase>[
          route(
            'phone',
            (BuildContext context) =>
                PhoneScreen(onCodeSent: () => context.go(AppRoutes.code)),
            routes: <RouteBase>[
              route('code', (BuildContext _) => const CodeScreen()),
            ],
          ),
        ],
      ),
      route(AppRoutes.consents, (BuildContext _) => const ConsentsScreen()),
      route(AppRoutes.name, (BuildContext _) => const NameScreen()),
      route(AppRoutes.location, (BuildContext _) => const LocationScreen()),
      route(AppRoutes.interests, (BuildContext _) => const InterestsScreen()),
      route(AppRoutes.home, (BuildContext _) => const HomeScreen()),
    ],
  );
  ref
    ..onDispose(router.dispose)
    ..onDispose(refresh.dispose);
  return router;
}
