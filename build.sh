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

# Copy and process Info.plist (replace placeholder variables)
sed 's/$(EXECUTABLE_NAME)/RAMWatcher/g; s/$(PRODUCT_BUNDLE_IDENTIFIER)/com.local.RAMWatcher/g; s/$(PRODUCT_NAME)/RAMWatcher/g; s/$(DEVELOPMENT_LANGUAGE)/en/g; s/$(MARKETING_VERSION)/1.0.0/g; s/$(CURRENT_PROJECT_VERSION)/1/g; s/$(MACOSX_DEPLOYMENT_TARGET)/11.0/g' RAMWatcher/Info.plist > "$CONTENTS/Info.plist"

# Copy executable
cp build/RAMWatcher "$MACOS/"
chmod +x "$MACOS/RAMWatcher"

# Copy assets
cp -r RAMWatcher/Assets.xcassets "$RESOURCES/"

# Code sign the app (create self-signed cert if needed)
echo "🔐 Code signing..."

# Check for existing Developer ID
SIGNING_IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -1 | sed 's/.*") \([^"]*\)".*/\1/' || echo "")

# If no Developer ID, check for self-signed cert
if [ -z "$SIGNING_IDENTITY" ]; then
    SIGNING_IDENTITY=$(security find-identity -v -p codesigning | grep "RAMWatcher Local Development" | head -1 | sed 's/.*") \([^"]*\)".*/\1/' || echo "")
fi

# Create self-signed certificate if none exists
if [ -z "$SIGNING_IDENTITY" ]; then
    echo "📋 Creating self-signed certificate for local development..."
    
    # Create a simple self-signed certificate using ad-hoc signing
    echo "Using ad-hoc signing (self-signed) for local development..."
    SIGNING_IDENTITY="-"
fi

if [ -n "$SIGNING_IDENTITY" ]; then
    echo "Using signing identity: $SIGNING_IDENTITY"
    codesign --force --sign "$SIGNING_IDENTITY" "$APP_BUNDLE"
    echo "✅ App signed successfully"
else
    echo "⚠️  Unable to create signing certificate. App will be unsigned."
    echo "   The app may trigger Gatekeeper warnings."
fi

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