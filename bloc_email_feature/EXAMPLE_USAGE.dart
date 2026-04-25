// ========================================
// EXAMPLE 1: Basic Usage - Minimal Setup
// ========================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import from your project structure
import 'data/email_remote_datasource.dart';
import 'data/email_repository_impl.dart';
import 'domain/mailbox_type.dart';
import 'presentation/bloc/email_list_bloc.dart';
import 'presentation/bloc/email_list_event.dart';
import 'presentation/screens/email_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: EmailListScreen(
        emailConfig: EmailConfig(
          serverHost: 'mail.tuoitre.com.vn',
          serverPort: 993,
          username: 'your-email@tuoitre.com.vn',
          password: 'your-password',
        ),
      ),
    );
  }
}

// ========================================
// EXAMPLE 2: With Navigation Button
// ========================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.email),
          label: const Text('Open Email'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmailListScreen(
                  emailConfig: EmailConfig(
                    serverHost: 'mail.tuoitre.com.vn',
                    serverPort: 993,
                    username: 'your-email@tuoitre.com.vn',
                    password: 'your-password',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ========================================
// EXAMPLE 3: With Account Selection
// ========================================

class AccountModel {
  final String email;
  final String password;
  final String imapServer;
  final int imapPort;

  const AccountModel({
    required this.email,
    required this.password,
    required this.imapServer,
    required this.imapPort,
  });
}

class EmailScreenWithAccount extends StatelessWidget {
  const EmailScreenWithAccount({
    required this.account,
    super.key,
  });

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return EmailListScreen(
      emailConfig: EmailConfig(
        serverHost: account.imapServer,
        serverPort: account.imapPort,
        username: account.email,
        password: account.password,
      ),
    );
  }
}

// ========================================
// EXAMPLE 4: Standalone Inbox (Single Tab)
// ========================================

class InboxOnlyScreen extends StatelessWidget {
  const InboxOnlyScreen({
    required this.emailConfig,
    super.key,
  });

  final EmailConfig emailConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: BlocProvider(
        create: (context) {
          final repository = EmailRepositoryImpl(
            EmailRemoteDataSource(emailConfig),
          );
          return EmailListBloc(
            repository: repository,
            mailboxType: MailboxType.inbox,
          )..add(LoadEmailsEvent(MailboxType.inbox));
        },
        child: const EmailListView(mailboxType: MailboxType.inbox),
      ),
    );
  }
}

// ========================================
// EXAMPLE 5: With Dependency Injection (get_it)
// ========================================

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register email config
  getIt.registerLazySingleton<EmailConfig>(
    () => EmailConfig(
      serverHost: 'mail.tuoitre.com.vn',
      serverPort: 993,
      username: 'your-email@tuoitre.com.vn',
      password: 'your-password',
    ),
  );

  // Register data source
  getIt.registerLazySingleton<EmailRemoteDataSource>(
    () => EmailRemoteDataSource(getIt<EmailConfig>()),
  );

  // Register repository
  getIt.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(getIt<EmailRemoteDataSource>()),
  );
}

class EmailScreenWithDI extends StatelessWidget {
  const EmailScreenWithDI({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Inbox', icon: Icon(Icons.inbox)),
              Tab(text: 'Sent', icon: Icon(Icons.send)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => EmailListBloc(
                repository: getIt<EmailRepository>(),
                mailboxType: MailboxType.inbox,
              )..add(LoadEmailsEvent(MailboxType.inbox)),
              child: const EmailListView(mailboxType: MailboxType.inbox),
            ),
            BlocProvider(
              create: (context) => EmailListBloc(
                repository: getIt<EmailRepository>(),
                mailboxType: MailboxType.sent,
              )..add(LoadEmailsEvent(MailboxType.sent)),
              child: const EmailListView(mailboxType: MailboxType.sent),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// EXAMPLE 6: With Secure Storage
// ========================================

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmailConfigManager {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: 'email_username', value: email);
    await _storage.write(key: 'email_password', value: password);
  }

  static Future<EmailConfig?> loadConfig() async {
    final username = await _storage.read(key: 'email_username');
    final password = await _storage.read(key: 'email_password');

    if (username == null || password == null) {
      return null;
    }

    return EmailConfig(
      serverHost: 'mail.tuoitre.com.vn',
      serverPort: 993,
      username: username,
      password: password,
    );
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: 'email_username');
    await _storage.delete(key: 'email_password');
  }
}

class SecureEmailScreen extends StatefulWidget {
  const SecureEmailScreen({super.key});

  @override
  State<SecureEmailScreen> createState() => _SecureEmailScreenState();
}

class _SecureEmailScreenState extends State<SecureEmailScreen> {
  EmailConfig? _config;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await EmailConfigManager.loadConfig();
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_config == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No email account configured'),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                },
                child: const Text('Add Account'),
              ),
            ],
          ),
        ),
      );
    }

    return EmailListScreen(emailConfig: _config!);
  }
}

// ========================================
// EXAMPLE 7: Custom Email Actions
// ========================================

class CustomEmailListScreen extends StatelessWidget {
  const CustomEmailListScreen({
    required this.emailConfig,
    super.key,
  });

  final EmailConfig emailConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emails'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Trigger refresh
              context.read<EmailListBloc>().add(const RefreshEmailsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<EmailListBloc, EmailListState>(
        listener: (context, state) {
          if (state is EmailListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Custom UI based on state
          if (state is EmailListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final email = state.messages[index];
              return ListTile(
                title: Text(email.subject),
                subtitle: Text(email.from.displayName),
                onTap: () {
                  // Custom action
                  _handleEmailTap(context, email);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _handleEmailTap(BuildContext context, EmailMessage email) {
    // Your custom logic here
    print('Tapped email: ${email.subject}');

    // Mark as read
    context.read<EmailListBloc>().add(MarkEmailAsReadEvent(email.uid));

    // Navigate to detail screen
    // Navigator.push(...);
  }
}

// ========================================
// EXAMPLE 8: With GoRouter Navigation
// ========================================

import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/email',
      builder: (context, state) {
        final emailConfig = state.extra as EmailConfig;
        return EmailListScreen(emailConfig: emailConfig);
      },
    ),
  ],
);

class AppWithGoRouter extends StatelessWidget {
  const AppWithGoRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

// Navigate to email screen
void navigateToEmail(BuildContext context) {
  final emailConfig = EmailConfig(
    serverHost: 'mail.tuoitre.com.vn',
    serverPort: 993,
    username: 'your-email@tuoitre.com.vn',
    password: 'your-password',
  );

  context.push('/email', extra: emailConfig);
}

// ========================================
// EXAMPLE 9: Testing BLoC
// ========================================

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEmailRepository extends Mock implements EmailRepository {}

void main() {
  group('EmailListBloc', () {
    late EmailRepository repository;
    late EmailListBloc bloc;

    setUp(() {
      repository = MockEmailRepository();
      bloc = EmailListBloc(
        repository: repository,
        mailboxType: MailboxType.inbox,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is EmailListInitial', () {
      expect(bloc.state, isA<EmailListInitial>());
    });

    blocTest<EmailListBloc, EmailListState>(
      'emits [loading, loaded] when emails are fetched successfully',
      build: () {
        when(() => repository.connect()).thenAnswer((_) async {});
        when(() => repository.fetchEmails(
              mailboxType: MailboxType.inbox,
              page: 1,
            )).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadEmailsEvent(MailboxType.inbox)),
      expect: () => [
        isA<EmailListLoading>(),
        isA<EmailListLoaded>(),
      ],
    );

    blocTest<EmailListBloc, EmailListState>(
      'emits error state when fetch fails',
      build: () {
        when(() => repository.connect()).thenAnswer((_) async {});
        when(() => repository.fetchEmails(
              mailboxType: MailboxType.inbox,
              page: 1,
            )).thenThrow(EmailException('Connection failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadEmailsEvent(MailboxType.inbox)),
      expect: () => [
        isA<EmailListLoading>(),
        isA<EmailListError>(),
      ],
    );
  });
}

// ========================================
// EXAMPLE 10: Multiple Accounts Support
// ========================================

class MultiAccountEmailScreen extends StatelessWidget {
  const MultiAccountEmailScreen({
    required this.accounts,
    super.key,
  });

  final List<AccountModel> accounts;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: accounts.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Email Accounts'),
          bottom: TabBar(
            isScrollable: true,
            tabs: accounts
                .map((account) => Tab(text: account.email))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: accounts
              .map((account) => EmailListScreen(
                    emailConfig: EmailConfig(
                      serverHost: account.imapServer,
                      serverPort: account.imapPort,
                      username: account.email,
                      password: account.password,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
