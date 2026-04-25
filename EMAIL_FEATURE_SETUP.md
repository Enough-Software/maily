# Email Feature Setup Guide

## 🎉 Implementation Complete!

The email feature has been implemented with clean architecture, including:
- ✅ Inbox and Sent tabs
- ✅ Infinite scroll pagination
- ✅ Pull-to-refresh
- ✅ Mark as read/unread
- ✅ Delete emails
- ✅ Vietnamese localization

## 📋 Next Steps

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

Run the code generator to create the necessary Freezed and Riverpod files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or use watch mode during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 3. Configure Email Account

Update the email configuration in `lib/email/presentation/providers/email_repository_provider.dart`:

```dart
@riverpod
EmailConfig emailConfig(EmailConfigRef ref) {
  // TODO: Replace with actual account data from your storage
  final allAccounts = await _mailStorage.getAllAccounts();
  final personalAccount = allAccounts.where((acc) => acc.type == 'personal').firstOrNull;

  return EmailConfig(
    serverHost: 'mail.tuoitre.com.vn',
    serverPort: 993,
    username: personalAccount?.email ?? 'your-email@tuoitre.com.vn',
    password: personalAccount?.password ?? 'your-password',
  );
}
```

### 4. Integrate into Your App

Add the email screen to your navigation:

```dart
import 'package:maily/email/presentation/screens/email_list_screen.dart';

// Navigate to email screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const EmailListScreen()),
);
```

Or use it as the home screen:

```dart
MaterialApp(
  home: const EmailListScreen(),
)
```

## 📁 Project Structure

```
lib/email/
├── domain/
│   ├── models/
│   │   ├── email_message.dart           # Email entity model
│   │   ├── mailbox_type.dart            # Mailbox enum (Inbox, Sent, etc.)
│   │   └── pagination_state.dart        # Pagination state model
│   └── repositories/
│       └── email_repository.dart        # Repository interface
│
├── data/
│   ├── datasources/
│   │   └── email_remote_datasource.dart # IMAP operations
│   └── repositories/
│       └── email_repository_impl.dart   # Repository implementation
│
└── presentation/
    ├── providers/
    │   ├── email_repository_provider.dart # DI providers
    │   └── email_list_provider.dart       # State management
    ├── screens/
    │   └── email_list_screen.dart         # Main email screen
    └── widgets/
        ├── email_list_item.dart           # Email card widget
        └── email_list_view.dart           # Scrollable email list

├── README.md          # Detailed documentation
└── example_usage.dart # Usage examples
```

## 🎨 Features

### Tabs
- **Hộp thư đến** (Inbox)
- **Thư đã gửi** (Sent)

### Email List
- Infinite scroll (automatically loads more emails as you scroll)
- Pull-to-refresh to sync new emails
- Smart date formatting (Today, Yesterday, weekday, date)
- Read/unread visual indicators
- Attachment and flag icons

### Actions
- Tap to open email (marks as read)
- Long-press for context menu:
  - Mark as read/unread
  - Delete email

### UI/UX
- Material Design 3
- Vietnamese localization
- Smooth animations
- Loading states
- Empty states
- Error handling

## 🔧 Customization

### Change Page Size

Edit `lib/email/presentation/providers/email_list_provider.dart`:

```dart
static const int _pageSize = 20; // Change to 30, 50, etc.
```

### Change Scroll Trigger Distance

Edit `lib/email/presentation/widgets/email_list_view.dart`:

```dart
if (scrollController.position.pixels >=
    scrollController.position.maxScrollExtent - 200) { // Change 200
  emailListNotifier.loadMore();
}
```

### Add More Mailbox Tabs

Edit `lib/email/presentation/screens/email_list_screen.dart`:

```dart
DefaultTabController(
  length: 3, // Increase number
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(text: 'Hộp thư đến', icon: Icon(Icons.inbox)),
          Tab(text: 'Thư đã gửi', icon: Icon(Icons.send)),
          Tab(text: 'Thư nháp', icon: Icon(Icons.drafts)), // Add new tab
        ],
      ),
    ),
    body: TabBarView(
      children: [
        EmailListView(mailboxType: MailboxType.inbox),
        EmailListView(mailboxType: MailboxType.sent),
        EmailListView(mailboxType: MailboxType.drafts), // Add new view
      ],
    ),
  ),
)
```

## 🐛 Troubleshooting

### Code Generation Errors

If you get errors during code generation:

1. Delete generated files:
   ```bash
   find . -name "*.g.dart" -delete
   find . -name "*.freezed.dart" -delete
   ```

2. Clean and regenerate:
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### IMAP Connection Issues

- Verify server settings (host, port)
- Check if SSL/TLS is required (port 993 = SSL, port 143 = plain)
- Ensure credentials are correct
- Check firewall/network settings

### Performance Issues

- Reduce page size if loading is slow
- Consider implementing local caching
- Use connection pooling for multiple mailboxes

## 📚 Learn More

See `lib/email/README.md` for detailed architecture documentation.
See `lib/email/example_usage.dart` for code examples.

## 🚀 Future Enhancements

Ideas for extending the feature:
- [ ] Email detail view with full content
- [ ] Compose/reply/forward emails
- [ ] Search and filter
- [ ] Offline support with local database
- [ ] Attachment download and preview
- [ ] Swipe gestures for quick actions
- [ ] Multiple account management
- [ ] Push notifications
- [ ] Rich text editor for composing

## 💡 Tips

1. **Testing**: Test with a real email account first before production
2. **Security**: Never hardcode passwords - use secure storage
3. **Performance**: Monitor memory usage with large email lists
4. **UX**: Add loading skeletons for better perceived performance
5. **Accessibility**: Test with screen readers and large text sizes

---

Happy coding! 🎊
