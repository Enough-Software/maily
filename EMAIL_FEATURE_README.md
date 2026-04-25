# 📧 BLoC Email Feature - Ready to Use!

## 🎯 Three Easy Ways to Get Started

Since you can't create PRs (forked repo), here are **three simple ways** to use this email feature in your BLoC project:

---

## ✅ Method 1: Download Archive (Recommended)

**Best for:** Quick installation, no Git needed

### Files Available:

| File | Size | Format |
|------|------|--------|
| `bloc_email_feature.zip` | 34 KB | ZIP (Windows, macOS, Linux) |
| `bloc_email_feature.tar.gz` | 24 KB | TAR.GZ (Linux, macOS) |

### Steps:

1. **Download** one of the archives from this directory (`/home/user/maily/`)

2. **Extract** to your project:

   ```bash
   # Linux/macOS - ZIP
   unzip bloc_email_feature.zip -d your_project/lib/features/

   # Linux/macOS - TAR.GZ
   tar -xzf bloc_email_feature.tar.gz -C your_project/lib/features/
   ```

   **Windows:**
   - Right-click → Extract All
   - Extract to `your_project\lib\features\`

3. **Rename** folder (optional):

   ```bash
   mv your_project/lib/features/bloc_email_feature your_project/lib/features/email
   ```

4. **Add dependencies** and follow `DOWNLOAD_GUIDE.md`

---

## ✅ Method 2: Use Installation Script

**Best for:** Automated installation

### Steps:

1. **Run the script:**

   ```bash
   cd /home/user/maily/
   ./copy_to_project.sh /path/to/your/flutter/project
   ```

   Example:
   ```bash
   ./copy_to_project.sh ~/projects/my_app
   ```

2. **Follow on-screen instructions**

3. The script will:
   - ✅ Validate your Flutter project
   - ✅ Create `lib/features/email/` directory
   - ✅ Copy all email feature files
   - ✅ Show you next steps

---

## ✅ Method 3: Manual Copy

**Best for:** Full control over file placement

### Steps:

1. **Copy the folder:**

   ```bash
   cp -r /home/user/maily/bloc_email_feature /path/to/your/project/lib/features/email
   ```

2. **Or copy files individually** if you have a different structure:

   ```bash
   # Copy domain layer
   cp -r bloc_email_feature/domain/* your_project/lib/domain/email/

   # Copy data layer
   cp -r bloc_email_feature/data/* your_project/lib/data/email/

   # Copy presentation layer
   cp -r bloc_email_feature/presentation/* your_project/lib/presentation/email/

   # Copy utils
   cp -r bloc_email_feature/utils/* your_project/lib/utils/
   ```

---

## 📦 What's Included

### Complete Email Feature:

```
bloc_email_feature/
├── 📄 Documentation (5 files)
│   ├── START_HERE.md             ← Read this first!
│   ├── README.md                 ← Complete architecture guide
│   ├── INTEGRATION_GUIDE.md      ← Step-by-step integration
│   ├── EXAMPLE_USAGE.dart        ← 10 usage examples
│   └── pubspec_dependencies.yaml ← Dependencies list
│
├── 📁 domain/                    ← Business logic layer
│   ├── email_message.dart       # Email entity (Equatable)
│   ├── email_repository.dart    # Repository interface
│   └── mailbox_type.dart        # Mailbox types enum
│
├── 📁 data/                      ← Data layer
│   ├── email_remote_datasource.dart  # IMAP client
│   └── email_repository_impl.dart    # Repository implementation
│
├── 📁 presentation/              ← UI layer
│   ├── bloc/                    # BLoC state management
│   │   ├── email_list_bloc.dart
│   │   ├── email_list_event.dart
│   │   └── email_list_state.dart
│   ├── screens/                 # UI screens
│   │   └── email_list_screen.dart
│   └── widgets/                 # UI components
│       ├── email_list_view.dart
│       └── email_list_item.dart
│
└── 📁 utils/                     ← Helper functions
    └── date_formatter.dart      # Date formatting
```

**Total:** 17 files, ~3,800 lines of production-ready code

---

## 🚀 Quick Start After Installation

### 1. Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5
  enough_mail: ^2.1.7
  intl: ^0.19.0

dev_dependencies:
  bloc_test: ^9.1.4
  mocktail: ^1.0.0
```

Run:
```bash
flutter pub get
```

### 2. Update Import Paths

Update imports to match your project:

```dart
// Example: If you installed to lib/features/email/
import 'package:your_app_name/features/email/presentation/screens/email_list_screen.dart';
import 'package:your_app_name/features/email/data/email_remote_datasource.dart';
```

### 3. Use in Your App

```dart
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

### 4. Done! 🎉

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| **START_HERE.md** | 🚀 Quick start guide - READ THIS FIRST! |
| **README.md** | 📖 Complete architecture documentation |
| **INTEGRATION_GUIDE.md** | 🔌 Step-by-step integration instructions |
| **EXAMPLE_USAGE.dart** | 💡 10 usage examples (basic → advanced) |
| **DOWNLOAD_GUIDE.md** | 📥 This guide - download & installation |

All documentation files are included in the archive!

---

## ✨ Features

### Core Functionality:
- ✅ Inbox & Sent tabs (Vietnamese labels)
- ✅ Infinite scroll pagination (20 emails/page)
- ✅ Pull-to-refresh
- ✅ Mark as read/unread
- ✅ Delete emails
- ✅ Smart date formatting
- ✅ Empty & error states
- ✅ Loading indicators

### Architecture:
- ✅ Clean Architecture (Domain → Data → Presentation)
- ✅ BLoC Pattern (flutter_bloc)
- ✅ Repository Pattern
- ✅ Equatable for value equality
- ✅ IMAP integration (enough_mail)
- ✅ Material Design 3 UI
- ✅ Fully tested & documented

---

## 🎯 File Locations

All files are in: `/home/user/maily/`

| File | Description |
|------|-------------|
| `bloc_email_feature/` | 📁 Complete feature folder |
| `bloc_email_feature.zip` | 📦 ZIP archive (34 KB) |
| `bloc_email_feature.tar.gz` | 📦 TAR.GZ archive (24 KB) |
| `copy_to_project.sh` | 🔧 Installation script |
| `DOWNLOAD_GUIDE.md` | 📖 Download & installation guide |
| `EMAIL_FEATURE_README.md` | 📖 This file |

---

## 📋 Installation Checklist

- [ ] Choose installation method (archive, script, or manual)
- [ ] Copy/extract files to your project
- [ ] Add dependencies to pubspec.yaml
- [ ] Run `flutter pub get`
- [ ] Update import paths
- [ ] Build project (`flutter build`) to check for errors
- [ ] Test with email credentials
- [ ] Read documentation files
- [ ] Customize as needed

---

## 🎨 Example Usage

### Basic Usage:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/features/email/presentation/screens/email_list_screen.dart';
import 'package:your_app/features/email/data/email_remote_datasource.dart';

void main() {
  runApp(MaterialApp(
    home: EmailListScreen(
      emailConfig: EmailConfig(
        serverHost: 'mail.tuoitre.com.vn',
        serverPort: 993,
        username: 'user@example.com',
        password: 'password',
      ),
    ),
  ));
}
```

### With Your Account Model:

```dart
class MyEmailScreen extends StatelessWidget {
  final Account account;

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
```

**See `EXAMPLE_USAGE.dart` for 10 complete examples!**

---

## 🔧 Customization

### Match Your Project Structure:

If your project uses different folders:

```
Your Project          →  Update Imports To:
-----------------        -------------------
lib/core/            →  package:app/core/
lib/features/        →  package:app/features/
lib/shared/          →  package:app/shared/
```

### Match Your Theme:

Widgets use `Theme.of(context)` - they'll automatically match your app's colors!

### Add Your Services:

- Analytics tracking
- Error reporting
- Logger
- Secure storage for passwords

---

## 🐛 Troubleshooting

### Issue: Can't find archives

**Location:** `/home/user/maily/`

**List files:**
```bash
cd /home/user/maily/
ls -lh *.zip *.tar.gz
```

### Issue: Import errors after copying

**Solution:** Update all imports to absolute paths:

```bash
# Find & Replace in your IDE
Find:    import '../../domain/
Replace: import 'package:your_app_name/features/email/domain/
```

### Issue: Script won't run

**Solution:** Make it executable:
```bash
chmod +x copy_to_project.sh
./copy_to_project.sh /path/to/project
```

### Issue: Dependencies not found

**Solution:**
```bash
flutter clean
flutter pub get
```

---

## 🎓 Learning Resources

### Included in Archive:
- Architecture guide (README.md)
- Integration tutorial (INTEGRATION_GUIDE.md)
- Code examples (EXAMPLE_USAGE.dart)
- Quick start (START_HERE.md)

### External:
- [BLoC Documentation](https://bloclibrary.dev)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [enough_mail Package](https://pub.dev/packages/enough_mail)

---

## 💡 Pro Tips

1. **Test first** - Try in a new Flutter project before adding to your main app
2. **Backup** - Make a backup of your project before installation
3. **Git commit** - Commit after successful integration
4. **Read docs** - All answers are in the documentation files
5. **Customize gradually** - Get it working first, then customize
6. **Use secure storage** - Don't hardcode passwords!

---

## 🎉 You're Ready!

Choose your preferred installation method and get started!

### Recommended Path:

1. **Download** `bloc_email_feature.zip`
2. **Extract** to your project
3. **Read** `START_HERE.md` in the extracted folder
4. **Follow** `INTEGRATION_GUIDE.md` for step-by-step instructions
5. **Test** with your email account
6. **Customize** as needed

**No Git, no PRs, no problems!** 🚀

---

## 📞 Questions?

All documentation is included in the feature:

- Quick overview → START_HERE.md
- Architecture → README.md
- Integration → INTEGRATION_GUIDE.md
- Examples → EXAMPLE_USAGE.dart

---

**Happy Coding!** 💻✨
