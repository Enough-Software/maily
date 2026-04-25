#!/bin/bash

# ========================================
# Email Feature Installation Script
# ========================================
# This script copies the email feature to your Flutter project

echo "================================================"
echo "  Email Feature Installation Script"
echo "================================================"
echo ""

# Check if target path is provided
if [ -z "$1" ]; then
    echo "❌ Error: Please provide your Flutter project path"
    echo ""
    echo "Usage:"
    echo "  ./copy_to_project.sh /path/to/your/flutter/project"
    echo ""
    echo "Example:"
    echo "  ./copy_to_project.sh ~/projects/my_flutter_app"
    echo ""
    exit 1
fi

TARGET_PROJECT="$1"
TARGET_DIR="$TARGET_PROJECT/lib/features/email"

# Check if target project exists
if [ ! -d "$TARGET_PROJECT" ]; then
    echo "❌ Error: Project directory not found: $TARGET_PROJECT"
    exit 1
fi

# Check if it's a Flutter project
if [ ! -f "$TARGET_PROJECT/pubspec.yaml" ]; then
    echo "❌ Error: Not a Flutter project (pubspec.yaml not found)"
    exit 1
fi

echo "✅ Found Flutter project: $TARGET_PROJECT"
echo ""

# Create features directory if it doesn't exist
if [ ! -d "$TARGET_PROJECT/lib/features" ]; then
    echo "📁 Creating features directory..."
    mkdir -p "$TARGET_PROJECT/lib/features"
fi

# Check if email feature already exists
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: Email feature already exists at: $TARGET_DIR"
    echo ""
    read -p "Do you want to overwrite? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled"
        exit 1
    fi
    echo "🗑️  Removing existing email feature..."
    rm -rf "$TARGET_DIR"
fi

# Copy email feature
echo "📦 Copying email feature..."
cp -r bloc_email_feature "$TARGET_DIR"

# Check if copy was successful
if [ $? -eq 0 ]; then
    echo "✅ Email feature copied successfully!"
    echo ""
    echo "📂 Location: $TARGET_DIR"
    echo ""
    echo "📋 Next Steps:"
    echo ""
    echo "1. Add dependencies to pubspec.yaml:"
    echo "   - flutter_bloc: ^8.1.3"
    echo "   - bloc: ^8.1.2"
    echo "   - equatable: ^2.0.5"
    echo "   - enough_mail: ^2.1.7"
    echo "   - intl: ^0.19.0"
    echo ""
    echo "2. Run: flutter pub get"
    echo ""
    echo "3. Update import paths to match your project structure"
    echo ""
    echo "4. Read the documentation:"
    echo "   - $TARGET_DIR/START_HERE.md"
    echo "   - $TARGET_DIR/INTEGRATION_GUIDE.md"
    echo ""
    echo "🎉 Installation complete!"
else
    echo "❌ Error: Failed to copy email feature"
    exit 1
fi
