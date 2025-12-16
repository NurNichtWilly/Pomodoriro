#!/bin/bash
set -e

APP_NAME="Pomodoriro"
RELEASE_DIR="releases"
APP_BUNDLE="$RELEASE_DIR/$APP_NAME.app"
BINARY_PATH=".build/release/$APP_NAME"
SOURCE_ICON="appicon/Gemini_Generated_Image_t0ohxct0ohxct0oh Background Removed.png"

# Build Release
echo "Building Release..."
swift build -c release

# Clean up previous build
rm -rf "$RELEASE_DIR"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copy Binary
cp "$BINARY_PATH" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

# Generate App Icon
if [ -f "$SOURCE_ICON" ]; then
    echo "Generating App Icon..."
    ICONSET_DIR="$RELEASE_DIR/AppIcon.iconset"
    mkdir -p "$ICONSET_DIR"

    # Resize images
    sips -z 16 16     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_16x16.png"
    sips -z 32 32     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_16x16@2x.png"
    sips -z 32 32     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_32x32.png"
    sips -z 32 32     "$SOURCE_ICON" --out "$ICONSET_DIR/icon_32x32@2x.png"
    sips -z 128 128   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_128x128.png"
    sips -z 256 256   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_128x128@2x.png"
    sips -z 256 256   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_256x256.png"
    sips -z 512 512   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_256x256@2x.png"
    sips -z 512 512   "$SOURCE_ICON" --out "$ICONSET_DIR/icon_512x512.png"
    sips -z 1024 1024 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_512x512@2x.png"

    # Create icns
    iconutil -c icns "$ICONSET_DIR" -o "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
    rm -rf "$ICONSET_DIR"
else
    echo "Warning: Source icon not found at $SOURCE_ICON"
fi

# Create Info.plist
cat > "$APP_BUNDLE/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.wme.$APP_NAME</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleShortVersionString</key>
    <string>0.4.0</string>
    <key>CFBundleVersion</key>
    <string>6</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
EOF


echo "App bundle created at $APP_BUNDLE"

# Code Signing (Ad-hoc)
# Required for Apple Silicon and to avoid some "Damaged" errors, though Notarization is needed for full distribution support.
echo "Signing app bundle..."
codesign --force --deep --sign - "$APP_BUNDLE"


# Create DMG
DMG_NAME="$APP_NAME.dmg"
DMG_PATH="$RELEASE_DIR/$DMG_NAME"

echo "Creating DMG..."
hdiutil create -volname "$APP_NAME" -srcfolder "$APP_BUNDLE" -ov -format UDZO "$DMG_PATH"

echo "DMG created at $DMG_PATH"
