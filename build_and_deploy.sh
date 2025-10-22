#!/bin/bash
# ===========================================
# Soviet Tower Defense - Build & Deploy Script
# Automates: Godot Export → Google Drive → Device
# ===========================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="/home/eetu/Dev/tddSOVIET"
EXPORT_PRESET="Android"  # Name from export_presets.cfg
JAVA_HOME="/usr/lib/jvm/java-17-openjdk"  # Java 17 for Android export
GODOT_FLATPAK="flatpak run --env=JAVA_HOME=$JAVA_HOME org.godotengine.Godot"
GDRIVE_FOLDER_ID=""  # Set this to your Google Drive folder ID (leave empty for root)

# Build mode: "debug" (no signing) or "release" (requires keystore)
BUILD_MODE="${1:-debug}"  # Default to debug, pass "release" as first argument

# Get version from GameManager.gd
get_version() {
    grep "const VERSION_STRING" "$PROJECT_DIR/scripts/autoloads/GameManager.gd" | sed 's/.*"\(.*\)".*/\1/' | tr -d ' '
}

VERSION=$(get_version)
APK_NAME="SovietTD-${VERSION}-${BUILD_MODE}.apk"
APK_PATH="$PROJECT_DIR/$APK_NAME"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Soviet Tower Defense - Build & Deploy${NC}"
echo -e "${BLUE}  Version: ${VERSION} (${BUILD_MODE})${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Step 1: Build APK with Godot
echo -e "${YELLOW}[1/4] Building APK with Godot...${NC}"
cd "$PROJECT_DIR"

# Check if Godot flatpak is available
if ! flatpak list | grep -q "org.godotengine.Godot"; then
    echo -e "${RED}❌ Godot flatpak not found!${NC}"
    echo -e "${YELLOW}Install with: flatpak install flathub org.godotengine.Godot${NC}"
    exit 1
fi

# Check if Java 17 is available
if [ ! -d "$JAVA_HOME" ]; then
    echo -e "${RED}❌ Java 17 not found at $JAVA_HOME!${NC}"
    echo -e "${YELLOW}Install with: sudo pacman -S jdk17-openjdk${NC}"
    exit 1
fi

# Export APK (headless mode with Java 17)
echo -e "${BLUE}Using Java: $JAVA_HOME${NC}"
if [ "$BUILD_MODE" = "release" ]; then
    echo -e "${BLUE}Building RELEASE APK (signed)${NC}"
    EXPORT_CMD="--export-release"
else
    echo -e "${BLUE}Building DEBUG APK (unsigned)${NC}"
    EXPORT_CMD="--export-debug"
fi

$GODOT_FLATPAK --headless $EXPORT_CMD "$EXPORT_PRESET" "$APK_PATH" 2>&1 | grep -E "(Exporting|Writing|ERROR|export)" || true

if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo -e "${GREEN}✅ APK built successfully: $APK_NAME ($APK_SIZE)${NC}"
else
    echo -e "${RED}❌ APK build failed!${NC}"
    exit 1
fi

echo ""

# Step 2: Upload to Google Drive
echo -e "${YELLOW}[2/4] Uploading to Google Drive...${NC}"

# Check if gdrive is installed
if ! command -v gdrive &> /dev/null; then
    echo -e "${RED}❌ gdrive not found in PATH!${NC}"
    echo -e "${YELLOW}Install gdrive first: go install github.com/glotlabs/gdrive/drive@latest${NC}"
    echo -e "${YELLOW}Or download from: https://github.com/glotlabs/gdrive/releases${NC}"
    echo ""
    echo -e "${BLUE}ℹ️  APK built at: $APK_PATH${NC}"
    echo -e "${BLUE}ℹ️  You can manually upload to Drive${NC}"
    exit 1
fi

# Upload to Drive (replace existing file with same name if exists)
if [ -z "$GDRIVE_FOLDER_ID" ]; then
    # Upload to root
    UPLOAD_OUTPUT=$(gdrive files upload "$APK_PATH" 2>&1)
else
    # Upload to specific folder
    UPLOAD_OUTPUT=$(gdrive files upload "$APK_PATH" --parent "$GDRIVE_FOLDER_ID" 2>&1)
fi

# Extract file ID from output
FILE_ID=$(echo "$UPLOAD_OUTPUT" | grep -oP 'Id: \K[a-zA-Z0-9_-]+' | head -1)

if [ -z "$FILE_ID" ]; then
    echo -e "${RED}❌ Upload failed!${NC}"
    echo -e "${YELLOW}$UPLOAD_OUTPUT${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Uploaded to Google Drive${NC}"
echo -e "${BLUE}   File ID: $FILE_ID${NC}"
echo ""

# Step 3: Make file publicly accessible
echo -e "${YELLOW}[3/4] Generating shareable link...${NC}"

# Share file (make it accessible to anyone with link)
gdrive permissions share "$FILE_ID" > /dev/null 2>&1

# Generate direct download link
SHARE_LINK="https://drive.google.com/uc?export=download&id=$FILE_ID"
VIEW_LINK="https://drive.google.com/file/d/$FILE_ID/view"

echo -e "${GREEN}✅ File is now publicly accessible${NC}"
echo ""

# Step 4: Display results
echo -e "${YELLOW}[4/4] Deployment complete!${NC}"
echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  📦 APK Ready for Download${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${BLUE}File:${NC} $APK_NAME"
echo -e "${BLUE}Size:${NC} $APK_SIZE"
echo ""
echo -e "${BLUE}View in Drive:${NC}"
echo -e "${VIEW_LINK}"
echo ""
echo -e "${BLUE}Direct Download:${NC}"
echo -e "${SHARE_LINK}"
echo ""

# Optional: Generate QR code for easy mobile access
if command -v qrencode &> /dev/null; then
    QR_FILE="$PROJECT_DIR/download_qr.png"
    qrencode -o "$QR_FILE" "$SHARE_LINK" 2>/dev/null
    echo -e "${GREEN}✅ QR Code generated: $QR_FILE${NC}"
    echo -e "${BLUE}   Scan with phone to download instantly!${NC}"
    echo ""
fi

# Save link to file for easy access
echo "$SHARE_LINK" > "$PROJECT_DIR/latest_apk_link.txt"
echo -e "${BLUE}ℹ️  Download link saved to: latest_apk_link.txt${NC}"
echo ""

# Optional: Copy link to clipboard (if xclip available)
if command -v xclip &> /dev/null; then
    echo -n "$SHARE_LINK" | xclip -selection clipboard
    echo -e "${GREEN}✅ Link copied to clipboard!${NC}"
fi

echo ""
echo -e "${GREEN}🎉 All done! Share the link or QR code with your device${NC}"
echo ""
