# Email Feature - Clean Architecture Implementation

This email feature implements a complete email client with clean architecture principles, including inbox/sent tabs and infinite scroll pagination.

## 🏗️ Architecture

The feature follows **Clean Architecture** with three distinct layers:

```
email/
├── domain/              # Business Logic Layer
│   ├── models/         # Entity models (EmailMessage, MailboxType, PaginationState)
│   └── repositories/   # Repository interfaces (contracts)
│
├── data/               # Data Layer
│   ├── datasources/    # Remote data sources (IMAP operations)
│   └── repositories/   # Repository implementations
│
└── presentation/       # Presentation Layer
    ├── providers/      # Riverpod state management
    ├── screens/        # Full-page screens
    └── widgets/        # Reusable UI components
```

### Layer Responsibilities

#### 1. Domain Layer (Business Logic)
- **Pure Dart** - no Flutter dependencies
- Defines data models and business rules
- Contains repository interfaces (contracts)
- Independent of external frameworks

#### 2. Data Layer
- Implements repository interfaces
- Handles IMAP protocol communication via `enough_mail`
- Manages data fetching, caching, and error handling
- Converts external data to domain models

#### 3. Presentation Layer
- **UI Components** - Screens and widgets
- **State Management** - Riverpod providers
- Consumes repositories through dependency injection
- Handles user interactions and displays data

## 📦 Key Components

### Domain Models

#### `EmailMessage`
Represents an email with all metadata:
- UID, subject, sender, recipients
- Date, read status, flags
- Preview text, attachments indicator

#### `MailboxType` (Enum)
Supported mailbox types:
- 📥 Inbox (`Hộp thư đến`)
- 📤 Sent (`Thư đã gửi`)
- 📝 Drafts (`Thư nháp`)
- 🗑️ Trash (`Thùng rác`)
- ⚠️ Spam (`Thư rác`)
- 📁 Archive (`Lưu trữ`)

#### `PaginationState`
Tracks pagination state:
- List of messages
- Loading flags (first load vs. load more)
- Current page and hasMore indicator
- Error state

### Repository Pattern

**Interface** (`EmailRepository`):
```dart
abstract class EmailRepository {
  Future<List<EmailMessage>> fetchEmails({
    required MailboxType mailboxType,
    required int page,
    int pageSize = 20,
  });

  Future<void> markAsRead({required MailboxType mailboxType, required int uid});
  Future<void> markAsUnread({required MailboxType mailboxType, required int uid});
  Future<void> deleteEmail({required MailboxType mailboxType, required int uid});
  Future<int> getEmailCount(MailboxType mailboxType);
}
```

**Implementation** (`EmailRepositoryImpl`):
- Uses `EmailRemoteDataSource` for IMAP operations
- Handles error mapping and exception translation
- Provides clean separation between data and domain

### State Management (Riverpod)

#### Providers

1. **`emailConfigProvider`** - Email account configuration
2. **`emailRemoteDataSourceProvider`** - IMAP data source instance
3. **`emailRepositoryProvider`** - Repository with auto-cleanup
4. **`emailListProvider(MailboxType)`** - Paginated email list state
5. **`unreadCountProvider(MailboxType)`** - Unread email counter

#### `EmailList` Notifier
Manages email list state with methods:
- `loadMore()` - Infinite scroll pagination
- `refresh()` - Pull-to-refresh
- `markAsRead(uid)` - Mark email as read
- `markAsUnread(uid)` - Mark email as unread
- `deleteEmail(uid)` - Delete email

## 🎨 UI Components

### `EmailListScreen`
Main screen with:
- Tab navigation (Inbox / Sent)
- Search button (TODO)
- Compose FAB (TODO)
- More options menu

### `EmailListView`
Scrollable list with:
- ✅ Infinite scroll (loads more at 200px from bottom)
- 🔄 Pull-to-refresh
- 📭 Empty state
- ⏳ Loading indicators (initial and pagination)
- Long-press context menu

### `EmailListItem`
Individual email card displaying:
- Sender avatar with initials
- Sender name and email
- Subject and preview (2 lines max)
- Date/time (smart formatting)
- Read/unread indicator (background color + bold text)
- Attachment and flag icons

## 🚀 Usage

### 1. Configure Email Account

Update `emailConfigProvider` in `email_repository_provider.dart`:

```dart
@riverpod
EmailConfig emailConfig(EmailConfigRef ref) {
  // TODO: Get from your account storage
  final account = ref.watch(yourAccountProvider);

  return EmailConfig(
    serverHost: 'mail.tuoitre.com.vn',
    serverPort: 993,
    username: account.email,
    password: account.password,
  );
}
```

### 2. Add to Your App

```dart
import 'package:maily/email/presentation/screens/email_list_screen.dart';

// Navigate to email screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const EmailListScreen()),
);
```

### 3. Use Individual Components

```dart
import 'package:maily/email/presentation/widgets/email_list_view.dart';
import 'package:maily/email/domain/models/mailbox_type.dart';

// Show only inbox
EmailListView(mailboxType: MailboxType.inbox)

// Show only sent
EmailListView(mailboxType: MailboxType.sent)
```

## 🔧 Configuration

### Pagination Settings

Adjust page size in `EmailList` provider (`email_list_provider.dart`):

```dart
static const int _pageSize = 20; // Change this value
```

### Infinite Scroll Trigger

Modify scroll threshold in `EmailListView` (`email_list_view.dart`):

```dart
if (scrollController.position.pixels >=
    scrollController.position.maxScrollExtent - 200) { // Change 200
  emailListNotifier.loadMore();
}
```

## 📝 TODO / Future Enhancements

- [ ] Email detail view (full message body)
- [ ] Compose email screen
- [ ] Search functionality
- [ ] Offline caching with local database
- [ ] Email attachments download/preview
- [ ] Swipe actions (archive, delete)
- [ ] Multiple account support
- [ ] Push notifications for new emails
- [ ] Rich text email composer

## 🧪 Testing

The architecture makes testing straightforward:

1. **Unit Tests** - Test domain models and repository interfaces
2. **Integration Tests** - Test repository implementations with mock IMAP
3. **Widget Tests** - Test UI components in isolation
4. **Provider Tests** - Test state management logic

## 📚 Dependencies

- `enough_mail` - IMAP/SMTP protocol implementation
- `freezed` - Immutable model generation
- `riverpod` - State management
- `flutter_hooks` - React-like hooks for Flutter
- `intl` - Date/time formatting and localization

## 🎯 Best Practices Implemented

✅ **Clean Architecture** - Clear separation of concerns
✅ **SOLID Principles** - Single responsibility, dependency inversion
✅ **Repository Pattern** - Abstract data access
✅ **Provider Pattern** - Dependency injection via Riverpod
✅ **Immutability** - Freezed models prevent accidental mutations
✅ **Error Handling** - Custom exceptions with meaningful messages
✅ **Code Generation** - Reduce boilerplate with build_runner
✅ **Vietnamese Localization** - UI labels in Vietnamese
✅ **Material Design 3** - Modern, accessible UI components

## 📖 Code Generation

After making changes to models or providers, run:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

Or for continuous generation during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```
