// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides all real email accounts
///
/// This is an example how to define your own account in an app.

@ProviderFor(CustomRealAccounts)
final customRealAccountsProvider = CustomRealAccountsProvider._();

/// Provides all real email accounts
///
/// This is an example how to define your own account in an app.
final class CustomRealAccountsProvider
    extends $NotifierProvider<CustomRealAccounts, List<RealAccount>> {
  /// Provides all real email accounts
  ///
  /// This is an example how to define your own account in an app.
  CustomRealAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customRealAccountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customRealAccountsHash();

  @$internal
  @override
  CustomRealAccounts create() => CustomRealAccounts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RealAccount> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RealAccount>>(value),
    );
  }
}

String _$customRealAccountsHash() =>
    r'd3172f2a38695b5d6b0d9ccd1dd04590d91470ff';

/// Provides all real email accounts
///
/// This is an example how to define your own account in an app.

abstract class _$CustomRealAccounts extends $Notifier<List<RealAccount>> {
  List<RealAccount> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<RealAccount>, List<RealAccount>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<RealAccount>, List<RealAccount>>,
              List<RealAccount>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
