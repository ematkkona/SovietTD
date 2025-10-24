#!/usr/bin/env python3
"""
Audacity Automation Script: Process Downloaded/Sourced Audio
=============================================================

Purpose: Process audio from external sources (no recording noise)
- For downloaded SFX, music conversions, royalty-free sounds
- No noise reduction (not needed for clean sources)
- Trim silence
- Optional EQ/compression
- Normalize to target level
- Export in specified format

Usage:
python process_downloaded_audio.py input.wav output.wav --type sfx
python process_downloaded_audio.py input.wav output.ogg --type music
python process_downloaded_audio.py input.wav output.ogg --type voice

Audio Types:
- sfx: Export as WAV 16-bit 44.1kHz, normalize to -6dB
- music: Export as OGG Vorbis, normalize to -3dB, compress
- voice: Export as OGG Vorbis, normalize to -3dB
"""

import sys
import os
import time
import argparse

def send_command(command):
    """Send command to Audacity via named pipe."""
    if sys.platform == 'win32':
        pipe_path = '\\\\.\\pipe\\ToSrvPipe'
        response_pipe_path = '\\\\.\\pipe\\FromSrvPipe'
    else:
        pipe_path = '/tmp/audacity_script_pipe.to.' + str(os.getuid())
        response_pipe_path = '/tmp/audacity_script_pipe.from.' + str(os.getuid())

    try:
        with open(pipe_path, 'w') as pipe:
            pipe.write(command + '\n')

        with open(response_pipe_path, 'r') as response_pipe:
            response = response_pipe.read()

        return response
    except Exception as e:
        print(f"Error: {e}")
        print("Make sure Audacity is running with mod-script-pipe enabled!")
        sys.exit(1)

def process_downloaded_audio(input_file, output_file, audio_type='sfx'):
    """Process downloaded/sourced audio without noise reduction."""

    print(f"Processing: {input_file}")
    print(f"Audio Type: {audio_type}")
    print(f"Output: {output_file}")
    print("-" * 50)

    # 1. Import audio file
    print("1. Importing audio file...")
    send_command(f'Import2: Filename="{input_file}"')
    time.sleep(0.5)

    # 2. Trim silence at start and end (optional but recommended)
    if audio_type != 'music':  # Don't auto-trim music
        print("2. Trimming silence...")
        send_command('SelectAll:')
        threshold = -40 if audio_type == 'sfx' else -35
        send_command(f'TruncateSilence: Action="Truncate Detected Silence" Compress=50 Independent=0 Minimum=0.1 Threshold={threshold} Truncate=0.3')
        time.sleep(0.5)

    # 3. Apply processing based on type
    if audio_type == 'music':
        print("3. Applying music mastering...")
        send_command('SelectAll:')

        # Compress dynamics for consistent volume
        send_command('Compressor: Threshold=-12 NoiseFloor=-40 Ratio=3 AttackTime=0.2 ReleaseTime=1 MakeupGain="Yes"')
        time.sleep(0.5)

        # Gentle EQ to enhance clarity
        send_command('Equalization: FilterLength=4001 InterpolateLin=0 InterpolateDB=0 Curve="Bass Boost"')
        time.sleep(0.3)

        # Normalize to -3dB (leave headroom)
        print("4. Normalizing to -3dB...")
        send_command('Normalize: PeakLevel=-3 RemoveDcOffset="Yes" ApplyGain="Yes"')
        time.sleep(0.5)

    elif audio_type == 'sfx':
        print("3. Processing SFX...")
        send_command('SelectAll:')

        # Remove DC offset
        send_command('Normalize: PeakLevel=-6 RemoveDcOffset="Yes" ApplyGain="No"')
        time.sleep(0.3)

        # Normalize to -6dB (per SovietTD SFX guidelines)
        print("4. Normalizing to -6dB...")
        send_command('Normalize: PeakLevel=-6 RemoveDcOffset="Yes" ApplyGain="Yes"')
        time.sleep(0.5)

    elif audio_type == 'voice':
        print("3. Processing voice...")
        send_command('SelectAll:')

        # Remove DC offset
        send_command('Normalize: PeakLevel=-3 RemoveDcOffset="Yes" ApplyGain="No"')
        time.sleep(0.3)

        # Normalize to -3dB
        print("4. Normalizing to -3dB...")
        send_command('Normalize: PeakLevel=-3 RemoveDcOffset="Yes" ApplyGain="Yes"')
        time.sleep(0.5)

    # 5. Export in appropriate format
    if audio_type == 'sfx':
        print("5. Exporting as WAV 16-bit 44.1kHz...")
        # Force .wav extension
        if not output_file.endswith('.wav'):
            output_file = os.path.splitext(output_file)[0] + '.wav'
            print(f"   Changed output to: {output_file}")

        send_command(f'Export2: Filename="{output_file}" NumChannels=1 SampleRate=44100')

    else:  # music or voice
        print("5. Exporting as OGG Vorbis...")
        # Force .ogg extension
        if not output_file.endswith('.ogg'):
            output_file = os.path.splitext(output_file)[0] + '.ogg'
            print(f"   Changed output to: {output_file}")

        send_command(f'Export2: Filename="{output_file}" NumChannels=2 SampleRate=44100')

    time.sleep(1.0)

    # 6. Close project without saving
    print("6. Cleaning up...")
    send_command('SelectAll:')
    send_command('Close:')

    print("-" * 50)
    print(f"✓ Processing complete: {output_file}")
    print("")

def main():
    parser = argparse.ArgumentParser(
        description='Process downloaded/sourced audio without noise reduction',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Downloaded SFX (export as WAV)
  python process_downloaded_audio.py downloaded_explosion.wav explosion.wav --type sfx

  # Music conversion (SID to OGG)
  python process_downloaded_audio.py katyusha.wav katyusha.ogg --type music

  # Royalty-free voice line
  python process_downloaded_audio.py voice_line.wav voice_line.ogg --type voice
        """
    )

    parser.add_argument('input_file', help='Input audio file')
    parser.add_argument('output_file', help='Output file')
    parser.add_argument('--type', choices=['sfx', 'music', 'voice'],
                        default='sfx', help='Audio type (determines processing and export format)')

    args = parser.parse_args()

    input_file = os.path.abspath(args.input_file)
    output_file = os.path.abspath(args.output_file)

    if not os.path.exists(input_file):
        print(f"Error: Input file not found: {input_file}")
        sys.exit(1)

    # Create output directory if needed
    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)

    process_downloaded_audio(input_file, output_file, args.type)

if __name__ == '__main__':
    main()
