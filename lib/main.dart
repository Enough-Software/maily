import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'account/provider.dart';
import 'settings/provider.dart';
import 'settings/ui/provider.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        realAccountsProvider.overrideWith(CustomRealAccounts.new),
        settingsUiElementsProvider.overrideWith(CustomSettingsUiElements.new),
        settingsProvider.overrideWith(CustomSettingsNotifier.new),
      ],
      child: const EnoughMailApp(),
    ),
  );
}
