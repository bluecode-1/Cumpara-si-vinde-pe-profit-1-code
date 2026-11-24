import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interests_controller.freezed.dart';
part 'interests_controller.g.dart';

@freezed
abstract class InterestsState with _$InterestsState {
  const factory InterestsState({
    /// `null` until the categories have been loaded.
    List<InterestCategory>? categories,
    AppError? loadError,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(false) bool isSubmitting,
    AppError? submitError,
  }) = _InterestsState;

  const InterestsState._();

  bool get isLoading => categories == null && loadError == null;
}

/// Step 7: optional multi-selection of top-level categories; finishing (or
/// skipping) completes onboarding.
@riverpod
class InterestsController extends _$InterestsController {
  @override
  InterestsState build() {
    // Deferred: the state may only be modified once build() has returned.
    unawaited(Future<void>.microtask(_load));
    return const InterestsState();
  }

  Future<void> retryLoad() {
    state = state.copyWith(loadError: null);
    return _load();
  }

  void toggle(String categoryId) {
    if (state.isSubmitting) {
      return;
    }
    state = state.copyWith(
      selectedIds: state.selectedIds.contains(categoryId)
          ? state.selectedIds.difference(<String>{categoryId})
          : <String>{...state.selectedIds, categoryId},
      submitError: null,
    );
  }

  /// Saves the current selection and completes onboarding.
  Future<void> finish() => _complete(state.selectedIds);

  /// Completes onboarding without any interest.
  Future<void> skip() => _complete(const <String>{});

  Future<void> _load() async {
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    try {
      final List<InterestCategory> categories = await repository
          .topLevelCategories();
      if (ref.mounted) {
        state = state.copyWith(categories: categories, loadError: null);
      }
    } on AppError catch (error) {
      if (ref.mounted) {
        state = state.copyWith(loadError: error);
      }
    }
  }

  Future<void> _complete(Set<String> interestCategoryIds) async {
    if (state.isSubmitting) {
      return;
    }
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final SessionController session = ref.read(
      sessionControllerProvider.notifier,
    );
    state = state.copyWith(isSubmitting: true, submitError: null);
    try {
      await repository.completeOnboarding(interestCategoryIds);
      await session.completeOnboarding();
    } on AppError catch (error) {
      if (ref.mounted) {
        state = state.copyWith(isSubmitting: false, submitError: error);
      }
    }
  }
}
