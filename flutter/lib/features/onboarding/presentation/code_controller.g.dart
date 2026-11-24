// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Step 3: verifies the 6-digit code and owns the resend countdown.

@ProviderFor(CodeController)
final codeControllerProvider = CodeControllerProvider._();

/// Step 3: verifies the 6-digit code and owns the resend countdown.
final class CodeControllerProvider
    extends $NotifierProvider<CodeController, CodeState> {
  /// Step 3: verifies the 6-digit code and owns the resend countdown.
  CodeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeControllerHash();

  @$internal
  @override
  CodeController create() => CodeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodeState>(value),
    );
  }
}

String _$codeControllerHash() => r'29c533ad77a5ff157b646c15a4c46d8fd0108c8f';

/// Step 3: verifies the 6-digit code and owns the resend countdown.

abstract class _$CodeController extends $Notifier<CodeState> {
  CodeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CodeState, CodeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CodeState, CodeState>,
              CodeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
