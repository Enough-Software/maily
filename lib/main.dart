import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'account/provider.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        realAccountsProvider.overrideWith(CustomRealAccounts.new),
      ],
      child: const MailyApp(),
    ),
  );
}
