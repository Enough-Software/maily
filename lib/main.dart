import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MailyApp(),
    ),
  );
}
