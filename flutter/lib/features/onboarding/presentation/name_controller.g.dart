// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Step 5: validates and saves the display name.

@ProviderFor(NameController)
final nameControllerProvider = NameControllerProvider._();

/// Step 5: validates and saves the display name.
final class NameControllerProvider
    extends $NotifierProvider<NameController, NameState> {
  /// Step 5: validates and saves the display name.
  NameControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nameControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nameControllerHash();

  @$internal
  @override
  NameController create() => NameController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NameState>(value),
    );
  }
}

String _$nameControllerHash() => r'0c0b95768973b5bbcad7a9fa18d144a88cb7e0c3';

/// Step 5: validates and saves the display name.

abstract class _$NameController extends $Notifier<NameState> {
  NameState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NameState, NameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NameState, NameState>,
              NameState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
