# 🚀 START HERE - BLoC Email Feature

**Ready-to-use Email Feature with BLoC Pattern + Clean Architecture**

## 📦 What You Get

A complete, production-ready email client feature that you can **copy and paste** into your Flutter BLoC project:

✅ **Clean Architecture** (Domain → Data → Presentation)
✅ **BLoC Pattern** for state management
✅ **Inbox & Sent tabs** with Vietnamese labels
✅ **Infinite scroll pagination** (20 emails per page)
✅ **Pull-to-refresh** functionality
✅ **Email operations** (mark read/unread, delete)
✅ **IMAP integration** using enough_mail
✅ **Material Design 3** UI
✅ **Fully documented** with examples

## 🎯 Quick Start (3 Steps)

### 1️⃣ Copy Files

```bash
# Copy entire folder to your project
cp -r bloc_email_feature your_project/lib/features/email
```

### 2️⃣ Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5
  enough_mail: ^2.1.7
  intl: ^0.19.0
```

```bash
flutter pub get
```

### 3️⃣ Navigate to Email Screen

```dart
import 'features/email/presentation/screens/email_list_screen.dart';
import 'features/email/data/email_remote_datasource.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EmailListScreen(
      emailConfig: EmailConfig(
        serverHost: 'mail.tuoitre.com.vn',
        serverPort: 993,
        username: 'your-email@example.com',
        password: 'your-password',
      ),
    ),
  ),
);
```

**That's it!** 🎉

## 📚 Documentation Files

| File | Description |
|------|-------------|
| **README.md** | Complete architecture documentation |
| **INTEGRATION_GUIDE.md** | Step-by-step integration instructions |
| **EXAMPLE_USAGE.dart** | 10 usage examples (basic to advanced) |
| **pubspec_dependencies.yaml** | Exact dependencies to add |

## 📁 File Structure

```
bloc_email_feature/
├── domain/                          # Business Logic
│   ├── email_message.dart          # Email entity (Equatable)
│   ├── email_repository.dart       # Repository interface
│   └── mailbox_type.dart           # Mailbox enum
│
├── data/                           # Data Layer
│   ├── email_remote_datasource.dart # IMAP operations
│   └── email_repository_impl.dart   # Repository implementation
│
├── presentation/                   # UI Layer
│   ├── bloc/
│   │   ├── email_list_bloc.dart    # BLoC logic
│   │   ├── email_list_event.dart   # User events
│   │   └── email_list_state.dart   # UI states
│   ├── screens/
│   │   └── email_list_screen.dart  # Main screen with tabs
│   └── widgets/
│       ├── email_list_view.dart    # Infinite scroll list
│       └── email_list_item.dart    # Email card widget
│
└── utils/
    └── date_formatter.dart         # Date formatting helpers
```

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, BLoC)          │
│                                     │
│  ┌──────────┐      ┌──────────┐   │
│  │  Screens │◄────►│   BLoC   │   │
│  └──────────┘      └─────┬────┘   │
└────────────────────────────┼────────┘
                             │
┌────────────────────────────▼────────┐
│          Domain Layer               │
│  (Entities, Repository Interface)   │
│                                     │
│  ┌──────────┐      ┌──────────┐   │
│  │ Email    │      │Repository│   │
│  │ Message  │      │Interface │   │
│  └──────────┘      └─────┬────┘   │
└────────────────────────────┼────────┘
                             │
┌────────────────────────────▼────────┐
│           Data Layer                │
│  (Repository Impl, Data Sources)    │
│                                     │
│  ┌──────────┐      ┌──────────┐   │
│  │Repository│◄────►│   IMAP   │   │
│  │   Impl   │      │DataSource│   │
│  └──────────┘      └──────────┘   │
└─────────────────────────────────────┘
```

## 🎨 Features Overview

### UI Components

- **Email List Screen** - Tabbed interface (Inbox/Sent)
- **Email List View** - Infinite scroll with pull-to-refresh
- **Email List Item** - Card with avatar, subject, preview, date
- **Empty State** - Shown when no emails
- **Error State** - With retry button
- **Loading States** - Initial load, pagination, refreshing

### BLoC Events

```dart
LoadEmailsEvent()        // Load first page
LoadMoreEmailsEvent()    // Load next page (pagination)
RefreshEmailsEvent()     // Pull-to-refresh
MarkEmailAsReadEvent()   // Mark as read
MarkEmailAsUnreadEvent() // Mark as unread
DeleteEmailEvent()       // Delete email
RetryEvent()            // Retry after error
```

### BLoC States

```dart
EmailListInitial     // Before loading
EmailListLoading     // Loading first page
EmailListLoadingMore // Loading more pages
EmailListLoaded      // Data loaded successfully
EmailListRefreshing  // Pull-to-refresh
EmailListError       // Error occurred
EmailListActionSuccess // Action completed
EmailListActionFailure // Action failed
```

## 💡 Best Practices Included

✅ **Clean Architecture** - Clear layer separation
✅ **SOLID Principles** - Easy to extend and maintain
✅ **Equatable** - Value equality for models and states
✅ **Immutability** - All models are immutable
✅ **Error Handling** - Custom exceptions with codes
✅ **Repository Pattern** - Abstract data access
✅ **Separation of Concerns** - Each file has one responsibility
✅ **Vietnamese Localization** - All UI text in Vietnamese
✅ **Material Design 3** - Modern Flutter UI

## 🧪 Testing Support

Includes testing examples:

```dart
// Unit test BLoC
blocTest<EmailListBloc, EmailListState>(
  'loads emails successfully',
  build: () => EmailListBloc(...),
  act: (bloc) => bloc.add(LoadEmailsEvent(...)),
  expect: () => [
    EmailListLoading(),
    EmailListLoaded(...),
  ],
);
```

## 🔧 Configuration

### Email Server Settings

```dart
EmailConfig(
  serverHost: 'mail.tuoitre.com.vn',  // IMAP server
  serverPort: 993,                     // SSL port
  username: 'your-email@example.com',  // Email
  password: 'your-password',           // Password
  isSecure: true,                      // Use SSL/TLS
)
```

### Customization

- **Page size**: Edit `_pageSize` in `email_list_bloc.dart`
- **Scroll threshold**: Edit `_isBottom` in `email_list_view.dart`
- **UI colors**: Use your app's theme
- **Date format**: Edit `date_formatter.dart`
- **Text labels**: Edit Vietnamese strings

## 📖 Read Next

1. **README.md** - Complete architecture documentation
2. **INTEGRATION_GUIDE.md** - Detailed integration steps
3. **EXAMPLE_USAGE.dart** - 10 code examples

## ✅ Compatibility

- ✅ Flutter 3.0+
- ✅ Dart 3.0+
- ✅ Android & iOS
- ✅ Material Design 3
- ✅ Null safety

## 🆘 Need Help?

### Common Issues

**Import errors?** → Update import paths to match your project structure
**BLoC not working?** → Ensure `BlocProvider` is above widgets
**Connection fails?** → Check email credentials and server settings
**Slow loading?** → Reduce page size or add caching

### Resources

- [BLoC Documentation](https://bloclibrary.dev)
- [enough_mail Package](https://pub.dev/packages/enough_mail)
- [Flutter BLoC Tutorial](https://bloclibrary.dev/#/fluttertodostutorial)

## 🎯 What to Customize

Before using in production:

1. **Email config** - Get from secure storage
2. **Error messages** - Translate if needed
3. **Theme colors** - Match your app
4. **Analytics** - Add tracking events
5. **Logging** - Add your logger
6. **Navigation** - Integrate with your routing

## 🚀 Production Checklist

- [ ] Store passwords securely (flutter_secure_storage)
- [ ] Add error tracking (Sentry, Firebase Crashlytics)
- [ ] Add analytics (Firebase Analytics, Mixpanel)
- [ ] Test with real email accounts
- [ ] Handle poor network conditions
- [ ] Add offline caching (optional)
- [ ] Test on Android and iOS
- [ ] Performance testing with large email lists
- [ ] Accessibility testing (screen readers)
- [ ] Security audit (code review)

## 💬 Questions?

Check the documentation files:

1. Architecture questions → **README.md**
2. Integration questions → **INTEGRATION_GUIDE.md**
3. Code examples → **EXAMPLE_USAGE.dart**

---

## 🎉 Ready to Start!

1. Read **INTEGRATION_GUIDE.md** for step-by-step instructions
2. Copy files to your project
3. Add dependencies
4. Update import paths
5. Test with your email account

**You got this!** 💪

---

Made with ❤️ using Flutter + BLoC + Clean Architecture
