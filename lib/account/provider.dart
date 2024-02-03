import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// Provides all real email accounts
///
/// This is an example how to define your own account in an app.
@Riverpod(keepAlive: true)
class CustomRealAccounts extends _$CustomRealAccounts implements RealAccounts {
  late AccountStorage _storage;

  @override
  List<RealAccount> build() => [];

  /// Loads the accounts from disk
  @override
  Future<void> init() async {
    _storage = const AccountStorage();
    final accounts = await _storage.loadAccounts();
    if (accounts.isNotEmpty) {
      ref.read(currentAccountProvider.notifier).state = accounts.first;
    }
    state = accounts;
  }

  /// Adds a new account
  @override
  void addAccount(RealAccount account) {
    final cleanState = state.toList()..removeWhere((a) => a.key == account.key);
    state = [...cleanState, account];
    if (state.length == 1) {
      ref.read(currentAccountProvider.notifier).state = account;
    }
    _saveAccounts();
  }

  /// Removes the given [account]
  @override
  void removeAccount(RealAccount account) {
    state = state.where((a) => a.key != account.key).toList();
    if (ref.read(currentAccountProvider) == account) {
      final replacement = state.isEmpty ? null : state.first;
      ref.read(currentAccountProvider.notifier).state = replacement;
    }
    _saveAccounts();
  }

  /// Updates the given [oldAccount] with the given [newAccount]
  @override
  void replaceAccount({
    required RealAccount oldAccount,
    required RealAccount newAccount,
    bool save = true,
  }) {
    final index = state.indexWhere((a) => a.key == oldAccount.key);
    if (index == -1) {
      throw StateError('account not found for ${oldAccount.key}');
    }
    final newState = state.toList()..[index] = newAccount;
    state = newState;
    if (ref.read(currentAccountProvider) == oldAccount) {
      ref.read(currentAccountProvider.notifier).state = newAccount;
    }
    if (save) {
      _saveAccounts();
    }
  }

  /// Changes the order of the accounts
  @override
  void reorderAccounts(List<RealAccount> accounts) {
    state = accounts;
    _saveAccounts();
  }

  /// Saves all data
  @override
  Future<void> updateMailAccount(RealAccount account, MailAccount mailAccount) {
    account.mailAccount = mailAccount;

    return _saveAccounts();
  }

  /// Saves all data
  @override
  Future<void> save() => _saveAccounts();

  Future<void> _saveAccounts() async {
    await _storage.saveAccounts(state);
  }
}
