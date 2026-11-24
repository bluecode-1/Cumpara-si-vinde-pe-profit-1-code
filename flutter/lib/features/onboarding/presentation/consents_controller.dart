import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consents_controller.freezed.dart';
part 'consents_controller.g.dart';

@freezed
abstract class ConsentsState with _$ConsentsState {
  const factory ConsentsState({
    /// Nothing is pre-selected: consent cannot be presumed (GDPR).
    @Default(<ConsentPurpose>{}) Set<ConsentPurpose> granted,
    @Default(false) bool isSubmitting,
    AppError? error,
  }) = _ConsentsState;

  const ConsentsState._();

  /// Both required consents (Terms, Privacy) are ticked.
  bool get canContinue =>
      granted.contains(ConsentPurpose.terms) &&
      granted.contains(ConsentPurpose.privacy);
}

/// Step 4: collects the required and optional consents.
@riverpod
class ConsentsController extends _$ConsentsController {
  /// The purposes decided on this screen, in display order. `LOCATION` is
  /// decided on the Location step.
  static const List<ConsentPurpose> purposes = <ConsentPurpose>[
    ConsentPurpose.terms,
    ConsentPurpose.privacy,
    ConsentPurpose.marketing,
    ConsentPurpose.analytics,
    ConsentPurpose.aiPhotoProcessing,
  ];

  @override
  ConsentsState build() => const ConsentsState();

  void setGranted(ConsentPurpose purpose, {required bool granted}) {
    if (state.isSubmitting) {
      return;
    }
    state = state.copyWith(
      granted: granted
          ? <ConsentPurpose>{...state.granted, purpose}
          : state.granted.difference(<ConsentPurpose>{purpose}),
      error: null,
    );
  }

  Future<void> submit() async {
    if (state.isSubmitting || !state.canContinue) {
      return;
    }
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final SessionController session = ref.read(
      sessionControllerProvider.notifier,
    );
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await repository.saveConsents(<ConsentDecision>[
        for (final ConsentPurpose purpose in purposes)
          ConsentDecision(
            purpose: purpose,
            granted: state.granted.contains(purpose),
          ),
      ]);
      await session.advanceTo(OnboardingStep.name);
    } on AppError catch (error) {
      if (ref.mounted) {
        state = state.copyWith(isSubmitting: false, error: error);
      }
    }
  }
}
