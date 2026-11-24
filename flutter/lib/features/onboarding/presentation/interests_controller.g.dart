// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Step 7: optional multi-selection of top-level categories; finishing (or
/// skipping) completes onboarding.

@ProviderFor(InterestsController)
final interestsControllerProvider = InterestsControllerProvider._();

/// Step 7: optional multi-selection of top-level categories; finishing (or
/// skipping) completes onboarding.
final class InterestsControllerProvider
    extends $NotifierProvider<InterestsController, InterestsState> {
  /// Step 7: optional multi-selection of top-level categories; finishing (or
  /// skipping) completes onboarding.
  InterestsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestsControllerHash();

  @$internal
  @override
  InterestsController create() => InterestsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterestsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterestsState>(value),
    );
  }
}

String _$interestsControllerHash() =>
    r'38f9d3b06662b6065b831b0a149715be033359d7';

/// Step 7: optional multi-selection of top-level categories; finishing (or
/// skipping) completes onboarding.

abstract class _$InterestsController extends $Notifier<InterestsState> {
  InterestsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InterestsState, InterestsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InterestsState, InterestsState>,
              InterestsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
