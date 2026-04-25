# 📥 Download & Installation Guide

## 🎯 Easy Installation - No Git Required!

Since you forked this repo and can't create PRs, I've created **standalone archives** that you can download and use directly in your BLoC project.

---

## 📦 Available Downloads

Two archive formats (same content):

| Format | File | Size | Best For |
|--------|------|------|----------|
| **ZIP** | `bloc_email_feature.zip` | 34 KB | Windows, macOS, Linux |
| **TAR.GZ** | `bloc_email_feature.tar.gz` | 24 KB | Linux, macOS |

**Location:** `/home/user/maily/` (this directory)

---

## 🚀 Installation Steps

### Option 1: Extract Archive to Your Project

#### Step 1: Download the Archive

```bash
# If you have access to this directory
cd /home/user/maily/

# Copy to your location
cp bloc_email_feature.zip /path/to/your/project/
```

Or manually download `bloc_email_feature.zip` from this directory.

#### Step 2: Extract to Your Project

**On Linux/macOS:**

```bash
# Navigate to your project
cd /path/to/your/flutter/project/

# Extract ZIP
unzip bloc_email_feature.zip -d lib/features/

# Or extract TAR.GZ
tar -xzf bloc_email_feature.tar.gz -C lib/features/
```

**On Windows:**

1. Right-click `bloc_email_feature.zip`
2. Select "Extract All..."
3. Extract to `your_project/lib/features/`

Your structure will be:

```
your_project/
└── lib/
    └── features/
        └── bloc_email_feature/
            ├── domain/
            ├── data/
            ├── presentation/
            ├── utils/
            └── *.md (documentation)
```

#### Step 3: Rename Folder (Optional)

```bash
cd lib/features/
mv bloc_email_feature email
```

Now you have:

```
your_project/
└── lib/
    └── features/
        └── email/
```

---

### Option 2: Manual File Copy

If you prefer, you can manually copy files from `bloc_email_feature/` folder to your project:

```bash
# Copy all files
cp -r bloc_email_feature/* your_project/lib/features/email/
```

---

## 🔧 Post-Installation Steps

### 1. Add Dependencies

Add to your `pubspec.yaml`:

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

Then run:

```bash
flutter pub get
```

### 2. Update Import Paths

Update imports to match your project structure.

**Example:** If you extracted to `lib/features/email/`:

**Find & Replace in all email feature files:**

```
Find:    import '../
Replace: import 'package:your_app_name/features/email/
```

Or keep relative imports if your structure matches.

### 3. Test the Integration

Create a test file to verify:

```dart
// test_email_feature.dart
import 'package:flutter/material.dart';
import 'package:your_app_name/features/email/presentation/screens/email_list_screen.dart';
import 'package:your_app_name/features/email/data/email_remote_datasource.dart';

void main() {
  runApp(MaterialApp(
    home: EmailListScreen(
      emailConfig: EmailConfig(
        serverHost: 'mail.tuoitre.com.vn',
        serverPort: 993,
        username: 'test@example.com',
        password: 'password',
      ),
    ),
  ));
}
```

Run:

```bash
flutter run
```

---

## 📂 What's Included in the Archive

```
bloc_email_feature/
├── 📄 START_HERE.md               # Quick start guide
├── 📄 README.md                   # Complete documentation
├── 📄 INTEGRATION_GUIDE.md        # Step-by-step integration
├── 📄 EXAMPLE_USAGE.dart          # 10 usage examples
├── 📄 pubspec_dependencies.yaml   # Dependencies list
│
├── 📁 domain/                     # Business Logic Layer
│   ├── email_message.dart        # Email entity
│   ├── email_repository.dart     # Repository interface
│   └── mailbox_type.dart         # Mailbox types enum
│
├── 📁 data/                       # Data Layer
│   ├── email_remote_datasource.dart  # IMAP operations
│   └── email_repository_impl.dart    # Repository implementation
│
├── 📁 presentation/               # UI Layer
│   ├── 📁 bloc/
│   │   ├── email_list_bloc.dart
│   │   ├── email_list_event.dart
│   │   └── email_list_state.dart
│   ├── 📁 screens/
│   │   └── email_list_screen.dart
│   └── 📁 widgets/
│       ├── email_list_view.dart
│       └── email_list_item.dart
│
└── 📁 utils/
    └── date_formatter.dart
```

**Total:** 17 files, ~3,800 lines of code

---

## 🎯 Quick Start After Installation

### 1. Import in Your Code

```dart
import 'package:your_app_name/features/email/presentation/screens/email_list_screen.dart';
import 'package:your_app_name/features/email/data/email_remote_datasource.dart';
```

### 2. Navigate to Email Screen

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

### 3. Done! 🎉

Your email feature is now integrated!

---

## 🔄 Alternative: Clone from Current Directory

If you have command-line access to this repo location:

```bash
# Copy entire folder to your project
cp -r /home/user/maily/bloc_email_feature /path/to/your/project/lib/features/email

# Or create a symbolic link (for development)
ln -s /home/user/maily/bloc_email_feature /path/to/your/project/lib/features/email
```

---

## 📋 Verification Checklist

After installation, verify:

- [ ] All files extracted to your project
- [ ] Dependencies added to pubspec.yaml
- [ ] `flutter pub get` completed successfully
- [ ] Import paths updated (if needed)
- [ ] Project builds without errors (`flutter build`)
- [ ] Can import email screen in your code
- [ ] Can navigate to email screen
- [ ] Email feature works with test credentials

---

## 🐛 Troubleshooting

### Issue: "Package not found" errors

**Solution:**
```bash
flutter clean
flutter pub get
```

### Issue: Import errors

**Solution:** Update all imports to match your project structure.

```dart
// Instead of relative imports:
import '../../domain/email_message.dart';

// Use absolute imports:
import 'package:your_app_name/features/email/domain/email_message.dart';
```

### Issue: Archive won't extract

**Solution:**
- **Windows:** Use 7-Zip or WinRAR
- **macOS:** Use built-in Archive Utility or `unzip` command
- **Linux:** Use `unzip` or `tar -xzf` command

### Issue: Files in wrong location

**Solution:** Make sure you extract to `lib/features/` or adjust import paths accordingly.

---

## 📖 Next Steps

1. **Read START_HERE.md** - Quick overview
2. **Read INTEGRATION_GUIDE.md** - Detailed integration steps
3. **Read EXAMPLE_USAGE.dart** - Code examples
4. **Read README.md** - Complete architecture documentation

---

## 🎁 Bonus: Create Your Own Archive

If you make modifications and want to create your own archive:

```bash
# Create ZIP
zip -r my_email_feature.zip lib/features/email/

# Create TAR.GZ
tar -czf my_email_feature.tar.gz lib/features/email/
```

---

## 💡 Pro Tips

1. **Backup first** - Make a backup of your project before extracting
2. **Test in isolation** - Test the email feature in a new Flutter project first
3. **Git ignore** - Add to `.gitignore` if testing:
   ```
   *.zip
   *.tar.gz
   ```
4. **Version control** - Commit after successful integration
5. **Document changes** - Note any customizations you make

---

## 📞 Need Help?

All documentation is included in the archive:

- **Quick Start:** START_HERE.md
- **Architecture:** README.md
- **Integration:** INTEGRATION_GUIDE.md
- **Examples:** EXAMPLE_USAGE.dart

---

## ✅ You're All Set!

The email feature is packaged and ready to use. Simply:

1. Download/extract the archive
2. Add dependencies
3. Update imports
4. Start using!

**No Git, no PRs, no problems!** 🚀

---

**Archive Location:**
- `bloc_email_feature.zip` (34 KB)
- `bloc_email_feature.tar.gz` (24 KB)

Both in: `/home/user/maily/`
