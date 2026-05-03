// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomSettingsUiElements)
final customSettingsUiElementsProvider = CustomSettingsUiElementsProvider._();

final class CustomSettingsUiElementsProvider
    extends $NotifierProvider<CustomSettingsUiElements, void> {
  CustomSettingsUiElementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customSettingsUiElementsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customSettingsUiElementsHash();

  @$internal
  @override
  CustomSettingsUiElements create() => CustomSettingsUiElements();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$customSettingsUiElementsHash() =>
    r'42b64d585c8670932f61a474c9caa5a3d66fb135';

abstract class _$CustomSettingsUiElements extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
