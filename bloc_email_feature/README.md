# 📧 Email Feature - BLoC + Clean Architecture

A complete, production-ready email feature implementation using **BLoC pattern** and **Clean Architecture** principles for Flutter.

## 🏗️ Architecture Overview

```
bloc_email_feature/
├── core/                  # Core utilities and constants
├── data/                  # Data Layer
│   ├── email_remote_datasource.dart    # IMAP operations
│   └── email_repository_impl.dart      # Repository implementation
├── domain/                # Domain Layer (Business Logic)
│   ├── email_message.dart              # Email entity
│   ├── email_repository.dart           # Repository interface
│   └── mailbox_type.dart               # Mailbox enum
├── presentation/          # Presentation Layer
│   ├── bloc/
│   │   ├── email_list_bloc.dart        # BLoC logic
│   │   ├── email_list_event.dart       # Events
│   │   └── email_list_state.dart       # States
│   ├── screens/
│   │   └── email_list_screen.dart      # Main email screen with tabs
│   └── widgets/
│       ├── email_list_view.dart        # Infinite scroll list
│       └── email_list_item.dart        # Email card widget
└── utils/                 # Utilities
    └── date_formatter.dart             # Date formatting helpers
```

### Clean Architecture Layers

#### 1️⃣ Domain Layer (Business Logic)
- **Pure Dart** - No Flutter dependencies
- Defines entities and repository interfaces
- Independent of frameworks and external dependencies

**Files:**
- `email_message.dart` - Email entity with Equatable
- `email_repository.dart` - Repository interface
- `mailbox_type.dart` - Mailbox type enum

#### 2️⃣ Data Layer
- Implements domain repository interfaces
- Handles external data sources (IMAP)
- Maps external data to domain entities

**Files:**
- `email_remote_datasource.dart` - IMAP client operations
- `email_repository_impl.dart` - Repository implementation

#### 3️⃣ Presentation Layer
- UI components and BLoC state management
- Depends on domain layer only
- Framework-specific code (Flutter widgets)

**Files:**
- **BLoC:**
  - `email_list_bloc.dart` - Business logic controller
  - `email_list_event.dart` - User actions
  - `email_list_state.dart` - UI states
- **UI:**
  - `email_list_screen.dart` - Main screen with tabs
  - `email_list_view.dart` - Scrollable list with infinite scroll
  - `email_list_item.dart` - Individual email card

## ✨ Features

### Core Functionality
- ✅ **Inbox & Sent tabs** with Vietnamese labels
- ✅ **Infinite scroll pagination** (20 emails per page)
- ✅ **Pull-to-refresh** functionality
- ✅ **Mark as read/unread**
- ✅ **Delete emails** with confirmation
- ✅ **Smart date formatting** (Today, Yesterday, weekday, date)
- ✅ **Read/unread visual indicators**
- ✅ **Avatar with initials** from sender name
- ✅ **Attachment and flag icons**
- ✅ **Empty states** and **error handling**
- ✅ **Loading states** (initial load, pagination, refreshing)

### BLoC Pattern Benefits
- 🔄 **Reactive UI** updates automatically
- 🧪 **Testable** business logic
- 📦 **Separation of concerns**
- 🔌 **Easy dependency injection**
- 🎯 **Clear event flow**

## 📦 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5

  # Email
  enough_mail: ^2.1.7

  # Utilities
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.4  # For testing BLoCs
  mocktail: ^1.0.0   # For mocking
```

## 🚀 Quick Start

### 1. Copy Files to Your Project

Copy the entire `bloc_email_feature` folder to your project:

```
your_project/
└── lib/
    └── features/
        └── email/    # Paste bloc_email_feature contents here
```

Or keep your own structure:

```
your_project/
└── lib/
    ├── data/
    │   └── email/    # Copy data layer files
    ├── domain/
    │   └── email/    # Copy domain layer files
    └── presentation/
        └── email/    # Copy presentation layer files
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Email Account

Update your email configuration:

```dart
import 'package:your_app/features/email/data/email_remote_datasource.dart';

final emailConfig = EmailConfig(
  serverHost: 'mail.tuoitre.com.vn',  // Your IMAP server
  serverPort: 993,                     // IMAP SSL port
  username: 'your-email@example.com',  // Email address
  password: 'your-password',           // Email password
  isSecure: true,                      // Use SSL/TLS
);
```

### 4. Navigate to Email Screen

```dart
import 'package:your_app/features/email/presentation/screens/email_list_screen.dart';

// In your navigation code:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EmailListScreen(
      emailConfig: emailConfig,
    ),
  ),
);
```

## 📱 Usage Examples

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'features/email/presentation/screens/email_list_screen.dart';
import 'features/email/data/email_remote_datasource.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmailListScreen(
        emailConfig: EmailConfig(
          serverHost: 'mail.example.com',
          serverPort: 993,
          username: 'user@example.com',
          password: 'password',
        ),
      ),
    );
  }
}
```

### With Dependency Injection

If you use `get_it` or similar:

```dart
// Setup DI
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register email config
  getIt.registerSingleton<EmailConfig>(
    EmailConfig(
      serverHost: 'mail.example.com',
      serverPort: 993,
      username: 'user@example.com',
      password: 'password',
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

// Use in screen
class EmailListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailListBloc(
        repository: getIt<EmailRepository>(),
        mailboxType: MailboxType.inbox,
      )..add(LoadEmailsEvent(MailboxType.inbox)),
      child: EmailListView(mailboxType: MailboxType.inbox),
    );
  }
}
```

### Standalone Email List (Single Mailbox)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class InboxScreen extends StatelessWidget {
  final EmailConfig emailConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inbox')),
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
        child: EmailListView(mailboxType: MailboxType.inbox),
      ),
    );
  }
}
```

## 🎯 BLoC Pattern Explanation

### Events (User Actions)

```dart
// Load first page
context.read<EmailListBloc>().add(LoadEmailsEvent(MailboxType.inbox));

// Load more (pagination)
context.read<EmailListBloc>().add(LoadMoreEmailsEvent());

// Refresh
context.read<EmailListBloc>().add(RefreshEmailsEvent());

// Mark as read
context.read<EmailListBloc>().add(MarkEmailAsReadEvent(emailUid));

// Delete
context.read<EmailListBloc>().add(DeleteEmailEvent(emailUid));
```

### States (UI States)

```dart
BlocBuilder<EmailListBloc, EmailListState>(
  builder: (context, state) {
    if (state is EmailListLoading) {
      return CircularProgressIndicator();
    }

    if (state is EmailListError) {
      return ErrorWidget(error: state.error);
    }

    if (state is EmailListLoaded) {
      return ListView.builder(
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          return EmailListItem(email: state.messages[index]);
        },
      );
    }

    return Container();
  },
)
```

### Event Flow

```
User Action → Event → BLoC → Repository → DataSource → Server
                ↓
              State → UI Update
```

## 🔧 Customization

### Change Page Size

Edit `email_list_bloc.dart`:

```dart
static const int _pageSize = 20;  // Change to 30, 50, etc.
```

### Change Infinite Scroll Threshold

Edit `email_list_view.dart`:

```dart
bool get _isBottom {
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.position.pixels;
  return currentScroll >= (maxScroll - 200);  // Change 200
}
```

### Add More Tabs

Edit `email_list_screen.dart`:

```dart
DefaultTabController(
  length: 3,  // Increase number
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(text: 'Hộp thư đến', icon: Icon(Icons.inbox)),
          Tab(text: 'Thư đã gửi', icon: Icon(Icons.send)),
          Tab(text: 'Thư nháp', icon: Icon(Icons.drafts)),  // Add new
        ],
      ),
    ),
    body: TabBarView(
      children: [
        _buildEmailListTab(context, MailboxType.inbox),
        _buildEmailListTab(context, MailboxType.sent),
        _buildEmailListTab(context, MailboxType.drafts),  // Add new
      ],
    ),
  ),
)
```

### Customize UI Theme

The widgets use Material Design 3 theming. Customize in your app theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  ),
  // ...
)
```

## 🧪 Testing

### Unit Testing BLoC

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

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

    blocTest<EmailListBloc, EmailListState>(
      'emits [loading, loaded] when emails are fetched successfully',
      build: () => bloc,
      act: (bloc) {
        when(() => repository.fetchEmails(
          mailboxType: any(named: 'mailboxType'),
          page: any(named: 'page'),
        )).thenAnswer((_) async => []);
        bloc.add(LoadEmailsEvent(MailboxType.inbox));
      },
      expect: () => [
        isA<EmailListLoading>(),
        isA<EmailListLoaded>(),
      ],
    );
  });
}
```

### Widget Testing

```dart
void main() {
  testWidgets('EmailListItem displays email info', (tester) async {
    final email = EmailMessage(
      uid: 1,
      subject: 'Test Subject',
      from: EmailAddress(email: 'test@example.com', name: 'Test User'),
      to: [],
      date: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmailListItem(
            email: email,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Subject'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
  });
}
```

## 📝 Best Practices Implemented

✅ **Clean Architecture** - Clear separation of concerns
✅ **SOLID Principles** - Single responsibility, dependency inversion
✅ **BLoC Pattern** - Reactive state management
✅ **Repository Pattern** - Abstract data access
✅ **Equatable** - Value equality for models and states
✅ **Immutability** - All models are immutable
✅ **Error Handling** - Custom exceptions with meaningful messages
✅ **Vietnamese Localization** - UI labels in Vietnamese
✅ **Material Design 3** - Modern, accessible UI

## 🐛 Troubleshooting

### IMAP Connection Issues

- Verify server settings (host, port)
- Check if SSL/TLS is required (port 993 = SSL, port 143 = plain)
- Ensure credentials are correct
- Check firewall/network settings
- Some providers require "less secure apps" enabled

### BLoC Not Updating UI

- Ensure you're using `BlocProvider` at the correct level
- Use `context.read<EmailListBloc>()` to access the bloc
- Check that events are being added properly
- Verify states are being emitted

### Performance Issues

- Reduce page size if loading is slow
- Consider implementing local caching
- Use `const` constructors where possible
- Profile with Flutter DevTools

## 🚀 Future Enhancements

Ideas for extending the feature:

- [ ] Email detail view with full HTML rendering
- [ ] Compose/reply/forward functionality
- [ ] Search and filtering
- [ ] Offline support with local database (Hive/SQLite)
- [ ] Attachment download and preview
- [ ] Swipe gestures for quick actions
- [ ] Multiple account management
- [ ] Push notifications for new emails
- [ ] Rich text editor for composing
- [ ] Email threads/conversations
- [ ] Dark mode support
- [ ] Accessibility improvements

## 📚 Additional Resources

- [BLoC Library Documentation](https://bloclibrary.dev)
- [Flutter BLoC Pattern Guide](https://bloclibrary.dev/#/coreconcepts)
- [Clean Architecture in Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [enough_mail Documentation](https://pub.dev/packages/enough_mail)

## 📄 License

This code is provided as-is for your project. Feel free to modify and use it as needed.

## 💡 Tips

1. **Security**: Never hardcode passwords - use secure storage (flutter_secure_storage)
2. **Testing**: Test BLoCs with bloc_test package
3. **Performance**: Monitor memory usage with DevTools
4. **UX**: Add loading skeletons for better perceived performance
5. **Accessibility**: Test with screen readers and large text sizes
6. **Error Handling**: Provide user-friendly error messages
7. **Offline**: Consider caching for offline access

---

Happy coding! 🎉
