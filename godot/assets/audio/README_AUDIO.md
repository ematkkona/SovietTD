# Audio Assets - Placeholder Information

## Current Status
The AudioManager is fully implemented and ready to play audio files, but **no audio files exist yet**.

## What Happens Without Audio Files
- AudioManager will print error messages: `❌ Music track not found` or `❌ SFX not found`
- Game will run silently (no crashes)
- All audio function calls are safe (they check for file existence)

## Quick Setup: Get Audio Files

### Option 1: Use Free Asset Packs (Fastest)
Download from [Kenney.nl - Tower Defense Assets](https://kenney.nl/assets/tower-defense-kit):
- Complete sound effect pack
- Includes explosions, shots, UI sounds
- Public domain (CC0)

### Option 2: Generate Placeholder Sounds
Use online tools to create basic sound effects:
- [SFXR](http://www.drpetter.se/project_sfxr.html) - Classic retro game sound generator
- [ChipTone](https://sfbgames.itch.io/chiptone) - Advanced chiptune sound maker
- [Beepbox](https://www.beepbox.co/) - Simple music creation

### Option 3: Record Your Own
- Use Audacity (free) to record simple sounds
- Mouth sounds work surprisingly well for prototyping!
- Convert to OGG or WAV format

## Required File Locations

Place audio files in these directories for the game to find them:

### Music (OGG format recommended)
```
assets/audio/music/
├── main_theme.ogg
├── menu_music.ogg
└── victory_fanfare.ogg
```

### Sound Effects (WAV or OGG)
```
assets/audio/sfx/
├── tower_shoot.wav
├── enemy_death.wav
├── explosion.wav
├── tower_place.wav
├── button_click.wav
├── coin_collect.wav
└── wave_start.wav
```

### Voice (OGG format recommended)
```
assets/audio/voice/
├── wave_incoming.ogg
├── tower_built.ogg
└── base_damaged.ogg
```

## How to Add Audio to Your Game

### Playing Music
```gdscript
AudioManager.play_music("res://assets/audio/music/main_theme.ogg", true)
```

### Playing Sound Effects
```gdscript
AudioManager.play_sfx("res://assets/audio/sfx/tower_shoot.wav")
```

### Connecting to Game Events
Already set up in the code! Audio will automatically play when:
- Towers shoot (needs: tower_shoot.wav)
- Enemies die (needs: enemy_death.wav)
- Waves start (needs: wave_start.wav)
- UI buttons clicked (needs: button_click.wav)

## Audio Format Guide

### Music Files
- **Format**: OGG Vorbis (best) or MP3
- **Sample Rate**: 44.1kHz
- **Bitrate**: 128-192 kbps (music quality)
- **Loop**: Must loop seamlessly (fade in/out or perfect loop point)

### Sound Effects
- **Format**: WAV (16-bit) or OGG Vorbis
- **Sample Rate**: 44.1kHz
- **Length**: 0.1 - 3 seconds (short and snappy)
- **Volume**: Normalize to -3dB to prevent clipping

## Volume Controls

The game has built-in volume controls:
- Master Volume: 0.0 - 1.0 (default: 1.0)
- Music Volume: 0.0 - 1.0 (default: 0.7)
- SFX Volume: 0.0 - 1.0 (default: 0.8)

Adjust in-game via settings menu (when implemented) or via code:
```gdscript
AudioManager.set_master_volume(0.8)
AudioManager.set_music_volume(0.5)
AudioManager.set_sfx_volume(1.0)
```

## For Now: Silent Game is OK!

The game is fully playable without audio. Add sounds when you're ready to polish!
