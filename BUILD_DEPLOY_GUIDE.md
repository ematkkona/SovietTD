# 🚀 Build & Deploy Automation Guide

## Quick Start

```bash
# Build APK and upload to Google Drive
./build_and_deploy.sh
```

## What It Does

1. **Reads version** from `GameManager.gd` automatically
2. **Builds APK** using Godot headless mode (`SovietTD-v0.2(Alpha).apk`)
3. **Uploads to Google Drive** using gdrive CLI
4. **Generates shareable link** for instant download
5. **Creates QR code** (optional) for easy mobile access
6. **Copies link to clipboard** for quick sharing

## Prerequisites

### Required
- **Godot 4.5+** installed and in PATH
- **gdrive** CLI tool (install instructions below)

### Optional (but useful)
- **qrencode** - Generates QR codes for mobile scanning
- **xclip** - Auto-copies download link to clipboard

## Installation

### 1. Install gdrive CLI

**Via Go:**
```bash
go install github.com/glotlabs/gdrive/drive@latest
export PATH=$PATH:$(go env GOPATH)/bin
```

**Via Binary:**
```bash
wget https://github.com/glotlabs/gdrive/releases/latest/download/gdrive-linux-x64
chmod +x gdrive-linux-x64
sudo mv gdrive-linux-x64 /usr/local/bin/gdrive
```

### 2. Authenticate gdrive

```bash
# First time only - authenticate with Google
gdrive account add

# Follow the OAuth flow in browser
# Grant access to your Google Drive
```

### 3. Optional Tools

```bash
# QR code generation
sudo pacman -S qrencode

# Clipboard support
sudo pacman -S xclip
```

## Configuration

### Set Upload Folder (Optional)

By default, uploads to Google Drive root. To upload to specific folder:

1. **Find your folder ID:**
   ```bash
   gdrive files list
   # Copy the ID of your desired folder
   ```

2. **Edit script:**
   ```bash
   nano build_and_deploy.sh
   # Set: GDRIVE_FOLDER_ID="your_folder_id_here"
   ```

### Custom Godot Path

If Godot isn't in PATH:

```bash
nano build_and_deploy.sh
# Set: GODOT_BINARY="/path/to/godot"
```

## Usage Examples

### Basic Build & Deploy
```bash
./build_and_deploy.sh
```

### View Latest Link
```bash
cat latest_apk_link.txt
```

### Share via QR Code
```bash
# If qrencode is installed, script auto-generates download_qr.png
display download_qr.png  # View QR code
```

### Manual Upload (if gdrive not ready)
```bash
# Script will build APK and stop at upload step
# You can manually drag SovietTD-v0.2(Alpha).apk to Drive
```

## Workflow Integration

### After Version Bump
```bash
# 1. Update version in GameManager.gd
# 2. Build and deploy
./build_and_deploy.sh

# 3. Script auto-detects new version
# Output: SovietTD-v0.3(Alpha).apk
```

### Combined with Git
```bash
# After committing version changes
git add .
git commit -m "Bump version to 0.3"
./build_and_deploy.sh
git push
```

## Output

Successful run produces:
```
================================================
  Soviet Tower Defense - Build & Deploy
  Version: v0.2 (Alpha)
================================================

[1/4] Building APK with Godot...
✅ APK built successfully: SovietTD-v0.2(Alpha).apk (42M)

[2/4] Uploading to Google Drive...
✅ Uploaded to Google Drive
   File ID: 1abc...xyz

[3/4] Generating shareable link...
✅ File is now publicly accessible

[4/4] Deployment complete!

================================================
  📦 APK Ready for Download
================================================

File: SovietTD-v0.2(Alpha).apk
Size: 42M

View in Drive:
https://drive.google.com/file/d/1abc...xyz/view

Direct Download:
https://drive.google.com/uc?export=download&id=1abc...xyz

✅ QR Code generated: download_qr.png
   Scan with phone to download instantly!

ℹ️  Download link saved to: latest_apk_link.txt

✅ Link copied to clipboard!

🎉 All done! Share the link or QR code with your device
```

## Mobile Installation Flow

### With QR Code (Fastest)
1. Run `./build_and_deploy.sh`
2. Open `download_qr.png`
3. Scan with phone camera
4. Download and install APK

### With Link
1. Run `./build_and_deploy.sh`
2. Link auto-copied to clipboard
3. Send to phone (Telegram, Signal, etc.)
4. Open link on phone
5. Download and install

### No USB Required! 🎉

## Troubleshooting

### "Godot not found"
```bash
# Add Godot to PATH or set full path in script
which godot  # Check if installed
```

### "gdrive not found"
```bash
# Verify installation
gdrive version

# If not in PATH, add it:
export PATH=$PATH:$(go env GOPATH)/bin
```

### "Upload failed"
```bash
# Re-authenticate
gdrive account list
gdrive account add  # Add account if missing
```

### Permission Errors
```bash
# Make script executable
chmod +x build_and_deploy.sh
```

## Tips

- **Version auto-detected** from `GameManager.gd` - no manual editing!
- **Old APKs remain in Drive** - delete manually if needed
- **QR codes expire** when you upload new version (different file ID)
- **Use clipboard link** to quickly share with yourself via messaging apps

---

*No more USB cables! Deploy instantly from desktop to mobile.* 📱
