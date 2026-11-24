// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consents_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Step 4: collects the required and optional consents.

@ProviderFor(ConsentsController)
final consentsControllerProvider = ConsentsControllerProvider._();

/// Step 4: collects the required and optional consents.
final class ConsentsControllerProvider
    extends $NotifierProvider<ConsentsController, ConsentsState> {
  /// Step 4: collects the required and optional consents.
  ConsentsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consentsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consentsControllerHash();

  @$internal
  @override
  ConsentsController create() => ConsentsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsentsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsentsState>(value),
    );
  }
}

String _$consentsControllerHash() =>
    r'336235061d46a4cc2cc33c3a49f3c3a9d4eff23a';

/// Step 4: collects the required and optional consents.

abstract class _$ConsentsController extends $Notifier<ConsentsState> {
  ConsentsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ConsentsState, ConsentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConsentsState, ConsentsState>,
              ConsentsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
