# Audacity Audio Automation Scripts for SovietTD

Automated audio processing scripts that follow the SovietTD audio production guidelines to the letter.

## 🎯 Overview

These scripts automate the repetitive audio processing tasks for the game, ensuring consistent quality and mastering across all audio assets while reducing manual workload.

**What these scripts do:**
- **Noise Reduction**: Automatically extract noise profiles and clean recordings
- **Consistent Mastering**: Apply correct normalization levels per audio type
- **Voice Effects**: Add radio static (commander) or loudspeaker effects (propaganda)
- **Batch Processing**: Process entire directories at once
- **Format Conversion**: Export in correct formats (WAV for SFX, OGG for voice/music)

## 📋 Audio Guidelines Reference

These scripts implement the SovietTD audio production standards:

| Type | Format | Sample Rate | Normalization | Notes |
|------|--------|-------------|---------------|-------|
| **SFX** | WAV 16-bit | 44.1kHz | -6dB peak | 0.1-3 seconds length |
| **Voice** | OGG Vorbis | 44.1kHz | -3dB peak | Commander/propaganda effects |
| **Music** | OGG Vorbis | 44.1kHz | -3dB peak | 128-192 kbps, seamless loops |

## 🚀 Quick Setup

### 1. Enable Audacity Scripting

1. Open Audacity
2. Go to **Edit → Preferences** (or **Audacity → Preferences** on Mac)
3. Click **Modules** in the left sidebar
4. Find **mod-script-pipe** and set to **Enabled**
5. Click **OK** and **restart Audacity**

### 2. Verify Setup

After restarting Audacity, verify the pipe is working:

**Linux/Mac:**
```bash
ls /tmp/audacity_script_pipe.to.$(id -u)
# Should show the pipe file
```

**Windows:**
```bash
# The pipe will be at: \\.\pipe\ToSrvPipe
# Just make sure Audacity is running
```

### 3. Make Scripts Executable

```bash
cd assets/audio/automation_scripts
chmod +x *.py
```

## 📝 Scripts Overview

### 1. `process_recorded_sfx.py` - Recorded SFX with Noise Reduction

**Use for:** SFX recorded with microphone (has 2-second silence prefix)

**What it does:**
1. Extracts noise profile from first 2 seconds of silence
2. Applies noise reduction to entire recording
3. Trims the silence prefix
4. Normalizes to -6dB peak
5. Exports as WAV 16-bit 44.1kHz

**Usage:**
```bash
python process_recorded_sfx.py input_raw.wav output_clean.wav
```

**Example:**
```bash
# Record tower shoot sound with 2 seconds of silence first
python process_recorded_sfx.py ~/raw/tower_shoot_raw.wav ../sfx/tower_shoot.wav
```

### 2. `process_recorded_voice.py` - Voice Lines with Effects

**Use for:** Voice recordings with 2-second silence prefix

**What it does:**
1. Noise reduction from silence profile
2. Trims silence prefix
3. Applies voice-specific effects:
   - `--type commander`: Radio static filter
   - `--type propaganda`: Echo + low-pass (loudspeaker effect)
   - `--type enemy`: Clean (no effects)
4. Normalizes to -3dB peak
5. Exports as OGG Vorbis

**Usage:**
```bash
python process_recorded_voice.py input.wav output.ogg --type [commander|propaganda|enemy]
```

**Examples:**
```bash
# Commander voice with radio effect
python process_recorded_voice.py wave_incoming_raw.wav ../voice/wave_incoming.ogg --type commander

# Propaganda tower line
python process_recorded_voice.py propaganda_raw.wav ../voice/propaganda_1.ogg --type propaganda

# Enemy death line (clean)
python process_recorded_voice.py businessman_death.wav ../voice/enemy_death_1.ogg --type enemy
```

### 3. `process_downloaded_audio.py` - External/Downloaded Audio

**Use for:** Audio from external sources (no noise reduction needed)

**What it does:**
1. Trims silence (optional)
2. Applies type-specific processing:
   - `--type sfx`: Normalize to -6dB → Export as WAV
   - `--type music`: Compression + EQ → Normalize to -3dB → Export as OGG
   - `--type voice`: Normalize to -3dB → Export as OGG
3. Maintains clean audio quality

**Usage:**
```bash
python process_downloaded_audio.py input.wav output.wav --type [sfx|music|voice]
```

**Examples:**
```bash
# Downloaded explosion SFX
python process_downloaded_audio.py explosion_source.wav ../sfx/explosion.wav --type sfx

# SID to OGG music conversion
python process_downloaded_audio.py katyusha.wav ../music/katyusha.ogg --type music

# Royalty-free voice line
python process_downloaded_audio.py voice_line.wav ../voice/voice_line.ogg --type voice
```

### 4. `batch_master_audio.py` - Batch Consistency Mastering

**Use for:** Ensuring consistent volume across all game audio

**What it does:**
1. Scans directory for audio files
2. Applies consistent normalization
3. Optional compression for even loudness
4. Creates new files with "_mastered" suffix (preserves originals)

**Usage:**
```bash
python batch_master_audio.py <directory> --type [sfx|music|voice] --target <dB> [--compress]
```

**Examples:**
```bash
# Master all SFX to -6dB
python batch_master_audio.py ../sfx --type sfx --target -6

# Master music with compression
python batch_master_audio.py ../music --type music --target -3 --compress

# Master voice lines
python batch_master_audio.py ../voice --type voice --target -3
```

## 🎙️ Recording Workflow

### For SFX and Voice (with noise reduction)

1. **Setup Recording:**
   - Close windows, turn off fans (reduce background noise)
   - Position microphone consistently
   - Set recording levels (aim for -12dB to -6dB peaks during test)

2. **Record with Silence Prefix:**
   ```
   [2 seconds silence] → [RECORDING] → [stop]
   ```
   - Start recording
   - Wait 2 seconds in silence (capture room noise)
   - Make sound/speak line
   - Stop recording

3. **Save as WAV:**
   - Export as WAV 16-bit 44.1kHz
   - Name with "_raw" suffix: `tower_shoot_raw.wav`

4. **Run Automation Script:**
   ```bash
   # For SFX
   python process_recorded_sfx.py tower_shoot_raw.wav ../sfx/tower_shoot.wav

   # For voice
   python process_recorded_voice.py wave_incoming_raw.wav ../voice/wave_incoming.ogg --type commander
   ```

5. **Test in Game:**
   - Copy to `assets/audio/sfx/` or `assets/audio/voice/`
   - Launch game and verify sound plays correctly

### For Downloaded Audio

1. **Download/Source Audio:**
   - Kenney.nl, OpenGameArt, royalty-free music, SID conversions

2. **Run Automation Script:**
   ```bash
   python process_downloaded_audio.py source.wav output.wav --type sfx
   ```

3. **Done!** No noise reduction needed for clean sources

## 🔧 Troubleshooting

### "Error: Make sure Audacity is running with mod-script-pipe enabled!"

**Solution:**
1. Ensure Audacity is running
2. Verify mod-script-pipe is enabled: Edit → Preferences → Modules
3. Restart Audacity after enabling
4. Check pipe exists:
   - Linux/Mac: `/tmp/audacity_script_pipe.to.$(id -u)`
   - Windows: Should auto-create when Audacity starts

### Script hangs or runs slowly

**Cause:** Audacity processing takes time, especially for long files

**Solution:**
- Be patient (progress is shown in console)
- Avoid running multiple scripts simultaneously
- For batch processing, let each file complete

### Output files are too quiet/loud

**Solution:**
- Check `--target` parameter matches audio guidelines
- For SFX: `-6dB`
- For voice/music: `-3dB`
- Re-run batch master script if needed

### Voice effects sound wrong

**Check:**
- Using correct `--type` parameter?
  - `commander` = radio static (for Soviet commander)
  - `propaganda` = echo + muffled (for loudspeaker)
  - `enemy` = clean (no effects)
- You can manually tweak effects in Audacity if needed

## 📂 Recommended Directory Structure

```
~/SovietTD_Assets/
├── audio_raw/              # Raw recordings (keep these!)
│   ├── sfx/
│   │   ├── tower_shoot_raw.wav
│   │   └── explosion_raw.wav
│   └── voice/
│       ├── wave_incoming_raw.wav
│       └── victory_raw.wav
│
├── audio_export/           # Processed files (ready for game)
│   ├── sfx/               → Copy to game's assets/audio/sfx/
│   ├── music/             → Copy to game's assets/audio/music/
│   └── voice/             → Copy to game's assets/audio/voice/
│
└── audio_sources/          # Downloaded/sourced audio
    ├── kenney_sfx/
    └── music_conversions/
```

## 🎬 Complete Example Session

```bash
# 1. Record 5 SFX sounds (each with 2-second silence prefix)
#    Save as: tower_shoot_raw.wav, explosion_raw.wav, etc.

# 2. Process all recorded SFX
for file in ~/raw/sfx/*_raw.wav; do
    output=$(basename "$file" _raw.wav).wav
    python process_recorded_sfx.py "$file" "../sfx/$output"
done

# 3. Record 3 voice lines (with silence prefix)
#    Save as: wave_incoming_raw.wav, victory_raw.wav, base_damaged_raw.wav

# 4. Process voice lines with effects
python process_recorded_voice.py wave_incoming_raw.wav ../voice/wave_incoming.ogg --type commander
python process_recorded_voice.py victory_raw.wav ../voice/victory.ogg --type commander
python process_recorded_voice.py base_damaged_raw.wav ../voice/base_damaged.ogg --type commander

# 5. Process downloaded music
python process_downloaded_audio.py katyusha_sid.wav ../music/katyusha.ogg --type music

# 6. Final consistency pass (optional)
python batch_master_audio.py ../sfx --type sfx --target -6
python batch_master_audio.py ../voice --type voice --target -3
python batch_master_audio.py ../music --type music --target -3 --compress

# 7. Copy to game directory
cp ../sfx/* ../../assets/audio/sfx/
cp ../voice/* ../../assets/audio/voice/
cp ../music/* ../../assets/audio/music/

# 8. Test in game!
```

## 💡 Pro Tips

1. **Keep Raw Recordings:** Always preserve `_raw.wav` files in case you need to re-process

2. **Record Multiple Takes:** Record 3-5 variations, pick best after processing

3. **Batch Process:** Record all SFX in one session, then batch process

4. **Use Descriptive Names:**
   - Good: `tower_rifle_shoot_raw.wav`
   - Bad: `sound1_raw.wav`

5. **Test Early:** Process one file first, test in game, then batch process the rest

6. **Consistent Recording Setup:** Same mic position, same room, same time of day = consistent noise profile

7. **Version Control:** Commit processed audio with your code changes

## 📚 References

- **SovietTD Audio Guidelines:** `docs/ASSET_PRODUCTION_ROADMAP.md` (Phase 1)
- **Audacity Scripting Docs:** https://manual.audacityteam.org/man/scripting.html
- **mod-script-pipe Guide:** https://manual.audacityteam.org/man/mod_script_pipe.html

---

**Ready to automate, comrade? Start recording with that 2-second silence prefix! 🎙️**
