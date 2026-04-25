// Example: How to integrate the email feature into your app

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'presentation/screens/email_list_screen.dart';

/// Example 1: Basic usage - just show the email screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Maily Email',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const EmailListScreen(),
      ),
    );
  }
}

/// Example 2: Custom email configuration
///
/// Before using the email feature, you need to configure the email account.
/// Update the emailConfigProvider in:
/// lib/email/presentation/providers/email_repository_provider.dart
///
/// ```dart
/// @riverpod
/// EmailConfig emailConfig(EmailConfigRef ref) {
///   // Get from your account storage
///   final account = ref.watch(currentAccountProvider);
///
///   return EmailConfig(
///     serverHost: account.incoming.serverName,
///     serverPort: account.incoming.serverPort,
///     username: account.email,
///     password: account.password, // From secure storage
///   );
/// }
/// ```

/// Example 3: Navigating to the email screen from another screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmailListScreen()),
            );
          },
          child: const Text('Open Email'),
        ),
      ),
    );
  }
}

/// Example 4: Using individual mailbox views
///
/// You can also use individual EmailListView widgets for specific mailboxes:
///
/// ```dart
/// import 'package:maily/email/domain/models/mailbox_type.dart';
/// import 'package:maily/email/presentation/widgets/email_list_view.dart';
///
/// class InboxOnlyScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Inbox')),
///       body: EmailListView(mailboxType: MailboxType.inbox),
///     );
///   }
/// }
/// ```

/// Example 5: Accessing email state programmatically
///
/// ```dart
/// class EmailStatsWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final inboxState = ref.watch(emailListProvider(MailboxType.inbox));
///     final sentState = ref.watch(emailListProvider(MailboxType.sent));
///
///     return Column(
///       children: [
///         Text('Inbox: ${inboxState.messages.length} emails'),
///         Text('Sent: ${sentState.messages.length} emails'),
///         if (inboxState.isLoading) CircularProgressIndicator(),
///       ],
///     );
///   }
/// }
/// ```

/// Example 6: Manual email operations
///
/// ```dart
/// class EmailActionsExample extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final emailList = ref.watch(emailListProvider(MailboxType.inbox).notifier);
///
///     return Column(
///       children: [
///         ElevatedButton(
///           onPressed: () => emailList.refresh(),
///           child: Text('Refresh Emails'),
///         ),
///         ElevatedButton(
///           onPressed: () => emailList.markAsRead(12345), // Use actual UID
///           child: Text('Mark Email as Read'),
///         ),
///         ElevatedButton(
///           onPressed: () => emailList.deleteEmail(12345), // Use actual UID
///           child: Text('Delete Email'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
