#!/usr/bin/env python3
"""
Generate professional-quality SFX for Soviet Tower Defense
Uses advanced synthesis techniques for game-ready audio
"""

import numpy as np
import wave
import struct

SAMPLE_RATE = 44100

def apply_envelope(data, attack=0.01, decay=0.05, sustain_level=0.7, release=0.1):
    """Apply ADSR envelope to audio data"""
    length = len(data)
    envelope = np.ones(length)

    attack_samples = int(SAMPLE_RATE * attack)
    decay_samples = int(SAMPLE_RATE * decay)
    release_samples = int(SAMPLE_RATE * release)

    # Attack
    if attack_samples > 0:
        envelope[:attack_samples] = np.linspace(0, 1, attack_samples)

    # Decay
    if decay_samples > 0:
        envelope[attack_samples:attack_samples + decay_samples] = np.linspace(1, sustain_level, decay_samples)

    # Sustain (keep sustain_level until release)
    sustain_start = attack_samples + decay_samples
    sustain_end = length - release_samples
    if sustain_end > sustain_start:
        envelope[sustain_start:sustain_end] = sustain_level

    # Release
    if release_samples > 0:
        envelope[-release_samples:] = np.linspace(sustain_level, 0, release_samples)

    return data * envelope

def add_harmonics(fundamental_freq, duration, harmonics=[1.0, 0.5, 0.3, 0.2]):
    """Generate sound with harmonics for richer tone"""
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))
    signal = np.zeros_like(t)

    for i, amplitude in enumerate(harmonics):
        freq = fundamental_freq * (i + 1)
        signal += amplitude * np.sin(2 * np.pi * freq * t)

    # Normalize
    signal = signal / np.max(np.abs(signal))
    return signal

def white_noise(duration, amplitude=0.5):
    """Generate white noise"""
    samples = int(SAMPLE_RATE * duration)
    return amplitude * np.random.uniform(-1, 1, samples)

def filtered_noise(duration, amplitude=0.5, cutoff_freq=1000):
    """Generate filtered noise (simple lowpass)"""
    noise = white_noise(duration, amplitude)
    # Simple lowpass: running average
    window = int(SAMPLE_RATE / cutoff_freq)
    return np.convolve(noise, np.ones(window)/window, mode='same')

def save_wav(filename, data, sample_rate=SAMPLE_RATE):
    """Save audio data as 16-bit WAV file"""
    # Normalize to prevent clipping
    data = data / np.max(np.abs(data)) * 0.9

    # Convert to 16-bit PCM
    data_int = np.int16(data * 32767)

    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(data_int.tobytes())

    print(f"✅ Created: {filename}")

# =============================================================================
# COMBAT SFX
# =============================================================================

def generate_tower_shoot():
    """Tower shooting - punchy laser/gun sound"""
    duration = 0.15
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))

    # Frequency sweep down (laser effect)
    start_freq = 1200
    end_freq = 400
    freq = start_freq + (end_freq - start_freq) * (t / duration)

    # Main tone with frequency modulation
    shot = np.sin(2 * np.pi * freq * t)

    # Add punch with short noise burst
    noise_duration = 0.02
    noise_samples = int(SAMPLE_RATE * noise_duration)
    punch = white_noise(noise_duration, 0.3)
    shot[:noise_samples] += punch

    # Apply sharp attack and quick release
    shot = apply_envelope(shot, attack=0.001, decay=0.02, sustain_level=0.6, release=0.05)

    save_wav("sfx/combat/tower_shoot.wav", shot * 0.7)

def generate_enemy_death():
    """Enemy death - descending whoosh with impact"""
    duration = 0.4
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))

    # Descending tone (death fall)
    start_freq = 600
    end_freq = 100
    freq = start_freq * np.exp(-8 * t / duration)
    death_tone = np.sin(2 * np.pi * freq * t)

    # Add metallic clang at start
    clang_freq = 1800
    clang_duration = 0.08
    clang_samples = int(SAMPLE_RATE * clang_duration)
    clang = np.sin(2 * np.pi * clang_freq * t[:clang_samples])
    clang *= np.exp(-15 * t[:clang_samples])

    # Combine
    death = death_tone.copy()
    death[:clang_samples] += clang * 0.5

    # Add noise burst for impact
    impact_noise = filtered_noise(0.1, amplitude=0.2, cutoff_freq=800)
    death[:len(impact_noise)] += impact_noise

    death = apply_envelope(death, attack=0.001, decay=0.1, sustain_level=0.5, release=0.15)

    save_wav("sfx/combat/enemy_death.wav", death * 0.8)

def generate_explosion():
    """Explosion - deep boom with rumble"""
    duration = 0.6

    # Low frequency boom
    boom_freq = 80
    boom_duration = 0.3
    t_boom = np.linspace(0, boom_duration, int(SAMPLE_RATE * boom_duration))
    boom = add_harmonics(boom_freq, boom_duration, [1.0, 0.7, 0.4, 0.2])

    # Add noise for rumble
    rumble = filtered_noise(duration, amplitude=0.4, cutoff_freq=500)

    # Combine with boom at start
    explosion = rumble.copy()
    explosion[:len(boom)] += boom

    # Sharp attack, long decay
    explosion = apply_envelope(explosion, attack=0.002, decay=0.15, sustain_level=0.3, release=0.25)

    save_wav("sfx/combat/explosion.wav", explosion * 0.9)

# =============================================================================
# UI SFX
# =============================================================================

def generate_button_click():
    """Button click - crisp, short click"""
    duration = 0.06
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))

    # Two-tone click (down-up motion)
    click1 = np.sin(2 * np.pi * 1400 * t[:len(t)//2])
    click2 = np.sin(2 * np.pi * 1600 * t[len(t)//2:])
    click = np.concatenate([click1, click2])

    # Very sharp envelope
    click = apply_envelope(click, attack=0.002, decay=0.01, sustain_level=0.3, release=0.02)

    save_wav("sfx/ui/button_click.wav", click * 0.5)

def generate_wave_start():
    """Wave start - dramatic ascending alarm"""
    duration = 0.8
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))

    # Ascending siren sweep
    start_freq = 440
    end_freq = 880
    freq = start_freq + (end_freq - start_freq) * (t / duration)**2  # Accelerating sweep

    siren = np.sin(2 * np.pi * freq * t)

    # Add warble (amplitude modulation)
    warble_freq = 15
    warble = 1 + 0.3 * np.sin(2 * np.pi * warble_freq * t)
    siren *= warble

    # Add urgency with harmonics
    harmonic = 0.3 * np.sin(2 * np.pi * freq * 2 * t)
    siren += harmonic

    siren = apply_envelope(siren, attack=0.02, decay=0.1, sustain_level=0.8, release=0.15)

    save_wav("sfx/ui/wave_start.wav", siren * 0.7)

def generate_wave_complete():
    """Wave complete - triumphant fanfare"""
    duration = 0.7

    # Victory chord: C major (C-E-G) with rhythm
    note_duration = 0.25

    # First chord hit
    c1 = add_harmonics(523, note_duration, [1.0, 0.6, 0.3])  # C5
    e1 = add_harmonics(659, note_duration, [1.0, 0.6, 0.3])  # E5
    g1 = add_harmonics(784, note_duration, [1.0, 0.6, 0.3])  # G5
    chord1 = (c1 + e1 + g1) / 3

    # Second chord hit (higher octave, longer)
    note2_duration = 0.45
    c2 = add_harmonics(1047, note2_duration, [1.0, 0.5, 0.2])  # C6
    e2 = add_harmonics(1319, note2_duration, [1.0, 0.5, 0.2])  # E6
    g2 = add_harmonics(1568, note2_duration, [1.0, 0.5, 0.2])  # G6
    chord2 = (c2 + e2 + g2) / 3

    # Combine with slight gap
    gap_samples = int(SAMPLE_RATE * 0.05)
    gap = np.zeros(gap_samples)
    fanfare = np.concatenate([chord1, gap, chord2])

    # Pad to duration
    if len(fanfare) < int(SAMPLE_RATE * duration):
        padding = np.zeros(int(SAMPLE_RATE * duration) - len(fanfare))
        fanfare = np.concatenate([fanfare, padding])

    # Envelope for each hit
    env1 = apply_envelope(np.ones(len(chord1)), attack=0.005, decay=0.08, sustain_level=0.4, release=0.1)
    env2 = apply_envelope(np.ones(len(chord2)), attack=0.005, decay=0.1, sustain_level=0.5, release=0.2)
    envelope = np.concatenate([env1, np.zeros(gap_samples), env2])

    if len(envelope) < len(fanfare):
        envelope = np.concatenate([envelope, np.zeros(len(fanfare) - len(envelope))])

    fanfare = fanfare * envelope

    save_wav("sfx/ui/wave_complete.wav", fanfare * 0.8)

# =============================================================================
# TOWER SFX
# =============================================================================

def generate_tower_place():
    """Tower placement - construction thud with mechanical sound"""
    duration = 0.35
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))

    # Initial impact (low thud)
    thud_freq = 120
    thud_duration = 0.15
    t_thud = np.linspace(0, thud_duration, int(SAMPLE_RATE * thud_duration))
    thud = add_harmonics(thud_freq, thud_duration, [1.0, 0.6, 0.3])

    # Metallic ringing (construction sound)
    ring_start = int(SAMPLE_RATE * 0.08)
    ring_duration = 0.25
    ring_freq = 2400
    t_ring = np.linspace(0, ring_duration, int(SAMPLE_RATE * ring_duration))
    ring = np.sin(2 * np.pi * ring_freq * t_ring)
    ring *= np.exp(-8 * t_ring)  # Decay

    # Combine
    placement = np.zeros(int(SAMPLE_RATE * duration))
    placement[:len(thud)] += thud
    placement[ring_start:ring_start + len(ring)] += ring * 0.4

    placement = apply_envelope(placement, attack=0.001, decay=0.08, sustain_level=0.3, release=0.15)

    save_wav("sfx/towers/tower_place.wav", placement * 0.75)

# =============================================================================
# ECONOMY SFX
# =============================================================================

def generate_coin_collect():
    """Coin collect - bright, pleasant chime"""
    duration = 0.2

    # Ascending notes for "sparkle" effect
    notes = [1047, 1319, 1568]  # C6, E6, G6
    note_duration = 0.07

    sounds = []
    for freq in notes:
        t = np.linspace(0, note_duration, int(SAMPLE_RATE * note_duration))
        note = np.sin(2 * np.pi * freq * t)
        # Add harmonic for brightness
        note += 0.3 * np.sin(2 * np.pi * freq * 2 * t)
        note = apply_envelope(note, attack=0.002, decay=0.02, sustain_level=0.3, release=0.03)
        sounds.append(note)

    # Overlap notes slightly for "sparkle"
    overlap = int(SAMPLE_RATE * 0.03)
    coin = sounds[0]
    for sound in sounds[1:]:
        start = len(coin) - overlap
        if start < 0:
            start = 0
        # Extend coin array if needed
        needed_length = start + len(sound)
        if needed_length > len(coin):
            coin = np.concatenate([coin, np.zeros(needed_length - len(coin))])
        coin[start:start + len(sound)] += sound

    # Pad to duration
    if len(coin) < int(SAMPLE_RATE * duration):
        coin = np.concatenate([coin, np.zeros(int(SAMPLE_RATE * duration) - len(coin))])

    save_wav("sfx/economy/coin_collect.wav", coin * 0.6)

def generate_not_enough_funds():
    """Insufficient funds - error buzz (not too harsh)"""
    duration = 0.25
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration))

    # Dissonant interval (minor second = tension)
    freq1 = 300
    freq2 = 320  # Intentionally dissonant

    buzz1 = np.sin(2 * np.pi * freq1 * t)
    buzz2 = np.sin(2 * np.pi * freq2 * t)

    # Amplitude modulation for "buzzy" effect
    mod_freq = 25
    modulation = 1 + 0.4 * np.sin(2 * np.pi * mod_freq * t)

    buzz = (buzz1 + buzz2) / 2 * modulation

    # Short, abrupt
    buzz = apply_envelope(buzz, attack=0.005, decay=0.05, sustain_level=0.5, release=0.08)

    save_wav("sfx/economy/not_enough_funds.wav", buzz * 0.65)

# =============================================================================
# MAIN
# =============================================================================

if __name__ == "__main__":
    print("=" * 60)
    print("🎵 Soviet Tower Defense - Professional SFX Generator")
    print("=" * 60)
    print()
    print("Using advanced synthesis techniques:")
    print("  • ADSR envelopes for natural attack/decay")
    print("  • Harmonic synthesis for rich tones")
    print("  • Frequency modulation for dynamic sounds")
    print("  • Filtered noise for realistic impacts")
    print()

    print("Generating Combat SFX...")
    generate_tower_shoot()
    generate_enemy_death()
    generate_explosion()

    print()
    print("Generating UI SFX...")
    generate_button_click()
    generate_wave_start()
    generate_wave_complete()

    print()
    print("Generating Tower SFX...")
    generate_tower_place()

    print()
    print("Generating Economy SFX...")
    generate_coin_collect()
    generate_not_enough_funds()

    print()
    print("=" * 60)
    print("✨ DONE! 9 professional-quality SFX files created")
    print("=" * 60)
    print()
    print("🎧 Preview the sounds:")
    print("  aplay sfx/combat/tower_shoot.wav")
    print("  aplay sfx/economy/coin_collect.wav")
    print()
    print("📝 These sounds feature:")
    print("  ✓ Tower shoot: Punchy laser with frequency sweep")
    print("  ✓ Enemy death: Descending whoosh with metallic impact")
    print("  ✓ Explosion: Deep boom with rumbling noise")
    print("  ✓ Button click: Crisp two-tone click")
    print("  ✓ Wave start: Dramatic ascending siren")
    print("  ✓ Wave complete: Triumphant C major fanfare")
    print("  ✓ Tower place: Construction thud with metallic ring")
    print("  ✓ Coin collect: Bright ascending chime (sparkle)")
    print("  ✓ Not enough funds: Dissonant error buzz")
    print()
    print("🔄 To regenerate with tweaks, edit the functions and run again!")
    print()
