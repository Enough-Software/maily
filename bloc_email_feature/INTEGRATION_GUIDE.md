# 🔌 Integration Guide - Copy & Paste to Your BLoC Project

This guide shows you **exactly** how to integrate the email feature into your existing Flutter BLoC project.

## 📋 Prerequisites

Your project should have:
- ✅ Flutter BLoC already set up
- ✅ A feature-based or layered folder structure
- ✅ Basic navigation set up

## 🎯 Step-by-Step Integration

### Step 1: Copy Files to Your Project

Choose the structure that matches your project:

#### Option A: Feature-Based Structure (Recommended)

If your project looks like this:

```
lib/
├── features/
│   ├── auth/
│   ├── profile/
│   └── ...
```

Copy files like this:

```bash
# Copy the entire email feature
cp -r bloc_email_feature/* your_project/lib/features/email/
```

Your structure will be:

```
lib/
└── features/
    └── email/
        ├── data/
        ├── domain/
        ├── presentation/
        └── utils/
```

#### Option B: Layer-Based Structure

If your project looks like this:

```
lib/
├── data/
├── domain/
├── presentation/
└── utils/
```

Copy files like this:

```bash
# Copy data layer
cp -r bloc_email_feature/data/* your_project/lib/data/email/

# Copy domain layer
cp -r bloc_email_feature/domain/* your_project/lib/domain/email/

# Copy presentation layer
cp -r bloc_email_feature/presentation/* your_project/lib/presentation/email/

# Copy utils
cp -r bloc_email_feature/utils/* your_project/lib/utils/
```

### Step 2: Update Import Paths

After copying, update import paths to match your project structure.

**Example:** If you used Option A (feature-based), update imports:

```dart
// Old import (in copied files)
import '../../domain/email_message.dart';

// New import (update to your structure)
import 'package:your_app_name/features/email/domain/email_message.dart';
```

**Search and replace pattern:**

```bash
# Find all Dart files in email feature
find lib/features/email -name "*.dart" -type f

# Use your IDE to search/replace relative imports with absolute imports
```

### Step 3: Add Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  # ... your existing dependencies

  # Email feature dependencies
  flutter_bloc: ^8.1.3      # If not already added
  bloc: ^8.1.2              # If not already added
  equatable: ^2.0.5         # If not already added
  enough_mail: ^2.1.7       # IMAP/SMTP library
  intl: ^0.19.0             # Date formatting

dev_dependencies:
  # ... your existing dev dependencies

  bloc_test: ^9.1.4         # For BLoC testing
  mocktail: ^1.0.0          # For mocking (if not added)
```

Install dependencies:

```bash
flutter pub get
```

### Step 4: Configure Email Account

Create a configuration file in your project:

**File:** `lib/config/email_config.dart` (or wherever you keep configs)

```dart
import 'package:your_app_name/features/email/data/email_remote_datasource.dart';

class AppEmailConfig {
  static EmailConfig get config {
    // TODO: Get these from secure storage or environment variables
    return EmailConfig(
      serverHost: 'mail.tuoitre.com.vn',
      serverPort: 993,
      username: 'your-email@example.com',
      password: 'your-password',
      isSecure: true,
    );
  }

  // Better: Get from account storage
  static EmailConfig fromAccount(YourAccountModel account) {
    return EmailConfig(
      serverHost: account.emailServer,
      serverPort: account.emailPort,
      username: account.email,
      password: account.password,
      isSecure: true,
    );
  }
}
```

### Step 5: Add Navigation Route

Add email screen to your routing:

#### If using GoRouter:

```dart
import 'package:your_app_name/features/email/presentation/screens/email_list_screen.dart';
import 'package:your_app_name/config/email_config.dart';

final router = GoRouter(
  routes: [
    // ... your existing routes

    GoRoute(
      path: '/email',
      builder: (context, state) => EmailListScreen(
        emailConfig: AppEmailConfig.config,
      ),
    ),
  ],
);
```

#### If using Navigator:

```dart
// Navigate to email screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EmailListScreen(
      emailConfig: AppEmailConfig.config,
    ),
  ),
);
```

#### If using Named Routes:

```dart
// In your routes
class AppRoutes {
  static const email = '/email';
}

// In MaterialApp
MaterialApp(
  routes: {
    AppRoutes.email: (context) => EmailListScreen(
      emailConfig: AppEmailConfig.config,
    ),
  },
);

// Navigate
Navigator.pushNamed(context, AppRoutes.email);
```

### Step 6: Add Navigation Button

Add a button in your app to navigate to emails:

**Example: In a drawer or bottom navigation:**

```dart
ListTile(
  leading: Icon(Icons.email),
  title: Text('Email'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailListScreen(
          emailConfig: AppEmailConfig.config,
        ),
      ),
    );
  },
)
```

### Step 7: Test the Integration

1. Run your app:

```bash
flutter run
```

2. Navigate to the email screen
3. Check that emails load correctly
4. Test infinite scroll, refresh, and email actions

## 🏗️ Advanced Integration

### Using Dependency Injection (get_it)

If you use `get_it` for DI:

**File:** `lib/core/di/injection.dart` (or your DI setup file)

```dart
import 'package:get_it/get_it.dart';
import 'package:your_app_name/features/email/data/email_remote_datasource.dart';
import 'package:your_app_name/features/email/data/email_repository_impl.dart';
import 'package:your_app_name/features/email/domain/email_repository.dart';

final getIt = GetIt.instance;

void setupEmailDependencies() {
  // Email config
  getIt.registerSingleton<EmailConfig>(
    EmailConfig(
      serverHost: 'mail.tuoitre.com.vn',
      serverPort: 993,
      username: 'your-email@example.com',
      password: 'your-password',
    ),
  );

  // Data source
  getIt.registerLazySingleton<EmailRemoteDataSource>(
    () => EmailRemoteDataSource(getIt<EmailConfig>()),
  );

  // Repository
  getIt.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(getIt<EmailRemoteDataSource>()),
  );
}

// Call in main.dart
void main() {
  setupEmailDependencies();
  runApp(MyApp());
}
```

**Update EmailListScreen:**

```dart
class EmailListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Email'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Hộp thư đến', icon: Icon(Icons.inbox)),
              Tab(text: 'Thư đã gửi', icon: Icon(Icons.send)),
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
              child: EmailListView(mailboxType: MailboxType.inbox),
            ),
            BlocProvider(
              create: (context) => EmailListBloc(
                repository: getIt<EmailRepository>(),
                mailboxType: MailboxType.sent,
              )..add(LoadEmailsEvent(MailboxType.sent)),
              child: EmailListView(mailboxType: MailboxType.sent),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Using with Multiple Email Accounts

If your app supports multiple email accounts:

**File:** `lib/features/email/presentation/screens/email_list_screen.dart`

Modify to accept account parameter:

```dart
class EmailListScreen extends StatelessWidget {
  const EmailListScreen({
    required this.account,
    super.key,
  });

  final YourAccountModel account;

  @override
  Widget build(BuildContext context) {
    final emailConfig = EmailConfig(
      serverHost: account.imapServer,
      serverPort: account.imapPort,
      username: account.email,
      password: account.password,
      isSecure: true,
    );

    // ... rest of the implementation
  }
}
```

### Integrating with Your Existing State Management

If you have a global BLoC for app state, you can emit events from email feature:

```dart
// In your email BLoC
class EmailListBloc extends Bloc<EmailListEvent, EmailListState> {
  EmailListBloc({
    required EmailRepository repository,
    required MailboxType mailboxType,
    this.appBloc, // Add optional app BLoC
  }) : _repository = repository,
       _mailboxType = mailboxType,
       super(EmailListInitial(mailboxType)) {
    // ... event handlers
  }

  final AppBloc? appBloc;

  Future<void> _onLoadEmails(...) async {
    // ... load emails

    // Notify app BLoC
    appBloc?.add(EmailsLoadedEvent(emails.length));
  }
}
```

## 🔧 Customization for Your Project

### Matching Your App Theme

Update widget colors to match your theme:

```dart
// In EmailListItem
Material(
  color: isUnread
      ? Theme.of(context).primaryColor.withOpacity(0.1)  // Use your theme
      : Colors.transparent,
  // ...
)
```

### Adding Your Error Handling

Replace the error handling with your app's error handling:

```dart
// In EmailListBloc
try {
  // ... operation
} on EmailException catch (e) {
  // Use your error handler
  YourErrorHandler.handle(e);

  emit(EmailListError(
    mailboxType: _mailboxType,
    error: YourErrorHandler.getUserMessage(e),
  ));
}
```

### Using Your Analytics

Add analytics tracking:

```dart
// In EmailListBloc
Future<void> _onLoadEmails(...) async {
  YourAnalytics.logEvent('email_list_loaded');

  // ... rest of the code
}
```

### Using Your Logger

Add logging:

```dart
import 'package:your_app/core/logger.dart';

// In EmailListBloc
Future<void> _onLoadEmails(...) async {
  logger.info('Loading emails from ${_mailboxType.displayName}');

  try {
    // ... load emails
    logger.info('Loaded ${emails.length} emails');
  } catch (e) {
    logger.error('Failed to load emails', e);
  }
}
```

## 🎨 UI Customization

### Update Vietnamese Text

If you want different text, update in:

1. **`domain/mailbox_type.dart`** - Folder names
2. **`presentation/screens/email_list_screen.dart`** - Tab labels, menu items
3. **`presentation/widgets/email_list_view.dart`** - Empty state, error messages
4. **`utils/date_formatter.dart`** - Date labels

### Change Email Item Design

Edit **`presentation/widgets/email_list_item.dart`**:

```dart
@override
Widget build(BuildContext context) {
  // Customize the layout, colors, fonts here
  return Material(
    color: isUnread ? Colors.blue[50] : Colors.transparent,  // Your color
    child: InkWell(
      // ... customize as needed
    ),
  );
}
```

## ✅ Checklist

After integration, verify:

- [ ] All files copied to your project
- [ ] Import paths updated
- [ ] Dependencies added and installed
- [ ] Email config created
- [ ] Navigation route added
- [ ] App builds without errors
- [ ] Can navigate to email screen
- [ ] Emails load successfully
- [ ] Infinite scroll works
- [ ] Pull-to-refresh works
- [ ] Can mark as read/unread
- [ ] Can delete emails
- [ ] Error handling works
- [ ] UI matches your app theme

## 🐛 Common Issues

### Issue: Import errors after copying

**Solution:** Update all relative imports to absolute imports matching your project structure.

```bash
# Use Find & Replace in your IDE
Find:    import '../../domain/
Replace: import 'package:your_app_name/features/email/domain/
```

### Issue: BLoC not updating UI

**Solution:** Make sure `BlocProvider` is above the widgets that need the BLoC:

```dart
BlocProvider(
  create: (context) => EmailListBloc(...),
  child: EmailListView(...),  // This can access the BLoC
)
```

### Issue: "Package not found" errors

**Solution:** Run `flutter pub get` and restart your IDE.

### Issue: IMAP connection fails

**Solution:**
1. Verify email credentials
2. Check server host and port
3. Ensure SSL is enabled (port 993 for IMAP SSL)
4. Check if provider requires "less secure apps" enabled

### Issue: Slow loading

**Solution:**
1. Reduce page size in `EmailListBloc` (from 20 to 10)
2. Add progress indicators
3. Consider caching with local database

## 📞 Need Help?

If you encounter issues:

1. Check the README.md for detailed documentation
2. Review the code comments
3. Test with a simple IMAP account first
4. Use Flutter DevTools to debug BLoC states
5. Check the enough_mail package documentation

## 🎉 You're Done!

Your email feature is now integrated! Test thoroughly and customize as needed for your specific use case.

---

**Pro Tip:** Start with basic integration, get it working, then add customizations one by one. This makes debugging much easier!
