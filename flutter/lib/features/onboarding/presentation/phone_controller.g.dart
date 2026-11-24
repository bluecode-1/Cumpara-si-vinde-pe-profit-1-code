// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Step 2: validates the number and requests the SMS code.

@ProviderFor(PhoneController)
final phoneControllerProvider = PhoneControllerProvider._();

/// Step 2: validates the number and requests the SMS code.
final class PhoneControllerProvider
    extends $NotifierProvider<PhoneController, PhoneState> {
  /// Step 2: validates the number and requests the SMS code.
  PhoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneControllerHash();

  @$internal
  @override
  PhoneController create() => PhoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneState>(value),
    );
  }
}

String _$phoneControllerHash() => r'1472ef5e37fe671560faeaaa4c37a6f27f2ba407';

/// Step 2: validates the number and requests the SMS code.

abstract class _$PhoneController extends $Notifier<PhoneState> {
  PhoneState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PhoneState, PhoneState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhoneState, PhoneState>,
              PhoneState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
