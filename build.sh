#!/bin/bash

# RAMWatcher Build Script
# This script compiles RAMWatcher and creates a distributable .dmg

set -e

echo "🚀 Building RAMWatcher..."

# Clean previous builds
rm -rf build
mkdir -p build

# Compile the Swift source
echo "📦 Compiling Swift source..."
swiftc RAMWatcher/MemoryMonitor.swift \
       RAMWatcher/RAMWatcherApp.swift \
       RAMWatcher/StatusItemController.swift \
       RAMWatcher/MemoryPopoverView.swift \
       RAMWatcher/LaunchAtLogin.swift \
       RAMWatcher/ContentView.swift \
       -o build/RAMWatcher \
       -framework AppKit \
       -framework SwiftUI \
       -framework ServiceManagement \
       -O

# Create app bundle
echo "📱 Creating app bundle..."
APP_NAME="RAMWatcher"
APP_BUNDLE="build/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

mkdir -p "$MACOS"
mkdir -p "$RESOURCES"

# Copy Info.plist
cp RAMWatcher/Info.plist "$CONTENTS/"

# Copy executable
cp build/RAMWatcher "$MACOS/"
chmod +x "$MACOS/RAMWatcher"

# Copy assets
cp -r RAMWatcher/Assets.xcassets "$RESOURCES/"

# Create DMG
echo "💿 Creating DMG..."
mkdir -p build/dmg
cp -r "$APP_BUNDLE" build/dmg/
ln -s /Applications build/dmg/Applications

hdiutil create -volname "RAMWatcher" \
               -srcfolder build/dmg \
               -ov \
               -format UDZO \
               build/RAMWatcher.dmg

# Clean up
rm -rf build/dmg

echo "✅ Build complete!"
echo "📍 Output: build/RAMWatcher.dmg"