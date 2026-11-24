// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Step 6: sets the approximate home area, from the device location or
/// from a manually chosen city.

@ProviderFor(LocationController)
final locationControllerProvider = LocationControllerProvider._();

/// Step 6: sets the approximate home area, from the device location or
/// from a manually chosen city.
final class LocationControllerProvider
    extends $NotifierProvider<LocationController, LocationState> {
  /// Step 6: sets the approximate home area, from the device location or
  /// from a manually chosen city.
  LocationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationControllerHash();

  @$internal
  @override
  LocationController create() => LocationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationState>(value),
    );
  }
}

String _$locationControllerHash() =>
    r'aa829bf23ad8a9c759a6bff22ccff832adf2f924';

/// Step 6: sets the approximate home area, from the device location or
/// from a manually chosen city.

abstract class _$LocationController extends $Notifier<LocationState> {
  LocationState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LocationState, LocationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocationState, LocationState>,
              LocationState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
