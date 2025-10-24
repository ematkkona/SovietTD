#!/usr/bin/env python3
"""
Generate placeholder audio files for Soviet Tower Defense
These are simple sine wave beeps at different frequencies
Replace with real audio assets when available
"""

import numpy as np
import wave
import struct

def generate_sine_wave(frequency, duration, sample_rate=44100, amplitude=0.3):
    """Generate a sine wave audio signal"""
    t = np.linspace(0, duration, int(sample_rate * duration))
    wave_data = amplitude * np.sin(2 * np.pi * frequency * t)

    # Add envelope (fade in/out) to prevent clicks
    fade_samples = int(sample_rate * 0.01)  # 10ms fade
    wave_data[:fade_samples] *= np.linspace(0, 1, fade_samples)
    wave_data[-fade_samples:] *= np.linspace(1, 0, fade_samples)

    return wave_data

def save_wav(filename, data, sample_rate=44100):
    """Save audio data as WAV file"""
    # Convert to 16-bit PCM
    data_int = np.int16(data * 32767)

    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(data_int.tobytes())

    print(f"✅ Created: {filename}")

def generate_combat_sfx():
    """Generate combat sound effects"""
    # Tower shoot - short high-pitched beep
    save_wav("sfx/combat/tower_shoot.wav",
             generate_sine_wave(880, 0.1, amplitude=0.2))

    # Enemy death - descending tone
    t = np.linspace(0, 0.3, int(44100 * 0.3))
    freq = 440 * np.exp(-5 * t)  # Exponential decay
    death_sound = 0.3 * np.sin(2 * np.pi * freq * t)
    save_wav("sfx/combat/enemy_death.wav", death_sound)

    # Explosion - low rumble with noise
    explosion = generate_sine_wave(110, 0.4, amplitude=0.4)
    noise = np.random.normal(0, 0.1, len(explosion))
    save_wav("sfx/combat/explosion.wav", explosion + noise)

def generate_ui_sfx():
    """Generate UI sound effects"""
    # Button click - short chirp
    save_wav("sfx/ui/button_click.wav",
             generate_sine_wave(1200, 0.05, amplitude=0.15))

    # Wave start - ascending fanfare
    t = np.linspace(0, 0.5, int(44100 * 0.5))
    freq = 440 + 880 * t  # Sweep from 440Hz to 1320Hz
    wave_start = 0.3 * np.sin(2 * np.pi * freq * t)
    save_wav("sfx/ui/wave_start.wav", wave_start)

    # Wave complete - victory chord
    chord = (generate_sine_wave(523, 0.6) +  # C
             generate_sine_wave(659, 0.6) +  # E
             generate_sine_wave(784, 0.6)) / 3  # G
    save_wav("sfx/ui/wave_complete.wav", chord)

def generate_tower_sfx():
    """Generate tower sound effects"""
    # Tower place - construction sound (low to high)
    t = np.linspace(0, 0.3, int(44100 * 0.3))
    freq = 220 + 440 * t  # Sweep up
    tower_place = 0.25 * np.sin(2 * np.pi * freq * t)
    save_wav("sfx/towers/tower_place.wav", tower_place)

def generate_economy_sfx():
    """Generate economy sound effects"""
    # Coin collect - pleasant chime
    coin = (generate_sine_wave(1047, 0.15, amplitude=0.2) +
            generate_sine_wave(1319, 0.15, amplitude=0.15)) / 2
    save_wav("sfx/economy/coin_collect.wav", coin)

    # Not enough funds - error buzz
    t = np.linspace(0, 0.2, int(44100 * 0.2))
    buzz = 0.25 * np.sin(2 * np.pi * 200 * t) * np.sin(2 * np.pi * 30 * t)
    save_wav("sfx/economy/not_enough_funds.wav", buzz)

if __name__ == "__main__":
    print("🎵 Generating placeholder SFX for Soviet Tower Defense...")
    print()

    generate_combat_sfx()
    generate_ui_sfx()
    generate_tower_sfx()
    generate_economy_sfx()

    print()
    print("✨ Done! 8 placeholder audio files created.")
    print("📝 These are simple beeps - replace with real audio when available.")
    print()
    print("To use in Godot:")
    print("1. Import the WAV files (Godot will auto-detect them)")
    print("2. Uncomment the corresponding constants in AudioRegistry.gd")
    print("3. Audio calls will automatically work!")
