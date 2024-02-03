// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customRealAccountsHash() =>
    r'd3172f2a38695b5d6b0d9ccd1dd04590d91470ff';

/// Provides all real email accounts
///
/// This is an example how to define your own account in an app.
///
/// Copied from [CustomRealAccounts].
@ProviderFor(CustomRealAccounts)
final customRealAccountsProvider =
    NotifierProvider<CustomRealAccounts, List<RealAccount>>.internal(
  CustomRealAccounts.new,
  name: r'customRealAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customRealAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomRealAccounts = Notifier<List<RealAccount>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
