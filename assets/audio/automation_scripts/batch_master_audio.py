#!/usr/bin/env python3
"""
Audacity Automation Script: Batch Master Audio Files
=====================================================

Purpose: Apply consistent mastering to multiple audio files
- Ensures consistent volume levels across all game audio
- Preserves dynamic range while normalizing peaks
- Optional compression for even loudness
- Processes entire directories

Usage:
python batch_master_audio.py ./sfx --type sfx --target -6
python batch_master_audio.py ./music --type music --target -3
python batch_master_audio.py ./voice --type voice --target -3

This script:
1. Scans directory for audio files
2. Applies consistent mastering to each file
3. Exports with "_mastered" suffix (preserves originals)
4. Maintains format (WAV→WAV, OGG→OGG)
"""

import sys
import os
import time
import argparse
import glob

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

def master_audio_file(input_file, output_file, audio_type, target_db, apply_compression):
    """Apply mastering to a single audio file."""

    print(f"  Mastering: {os.path.basename(input_file)}")

    # 1. Import audio file
    send_command(f'Import2: Filename="{input_file}"')
    time.sleep(0.5)

    # 2. Apply compression if requested
    if apply_compression:
        send_command('SelectAll:')

        if audio_type == 'music':
            # Gentle compression for music
            send_command('Compressor: Threshold=-12 NoiseFloor=-40 Ratio=2.5 AttackTime=0.2 ReleaseTime=1 MakeupGain="Yes"')
        elif audio_type == 'voice':
            # Moderate compression for voice
            send_command('Compressor: Threshold=-15 NoiseFloor=-40 Ratio=3 AttackTime=0.1 ReleaseTime=0.8 MakeupGain="Yes"')
        elif audio_type == 'sfx':
            # Light compression for SFX (preserve impact)
            send_command('Compressor: Threshold=-10 NoiseFloor=-40 Ratio=2 AttackTime=0.05 ReleaseTime=0.5 MakeupGain="Yes"')

        time.sleep(0.5)

    # 3. Normalize to target level
    send_command('SelectAll:')
    send_command(f'Normalize: PeakLevel={target_db} RemoveDcOffset="Yes" ApplyGain="Yes"')
    time.sleep(0.5)

    # 4. Export (maintain original format)
    send_command(f'Export2: Filename="{output_file}"')
    time.sleep(1.0)

    # 5. Close without saving
    send_command('SelectAll:')
    send_command('Close:')

def batch_master_directory(directory, audio_type, target_db, apply_compression):
    """Process all audio files in a directory."""

    # Find all audio files
    patterns = ['*.wav', '*.ogg', '*.mp3', '*.flac']
    audio_files = []

    for pattern in patterns:
        audio_files.extend(glob.glob(os.path.join(directory, pattern)))
        audio_files.extend(glob.glob(os.path.join(directory, pattern.upper())))

    if not audio_files:
        print(f"No audio files found in: {directory}")
        return

    # Filter out already mastered files
    audio_files = [f for f in audio_files if '_mastered' not in f]

    print(f"\nFound {len(audio_files)} files to process")
    print(f"Type: {audio_type}")
    print(f"Target: {target_db} dB")
    print(f"Compression: {'Yes' if apply_compression else 'No'}")
    print("-" * 50)

    success_count = 0
    error_count = 0

    for i, input_file in enumerate(audio_files, 1):
        try:
            # Generate output filename
            base, ext = os.path.splitext(input_file)
            output_file = f"{base}_mastered{ext}"

            print(f"[{i}/{len(audio_files)}]", end=" ")
            master_audio_file(input_file, output_file, audio_type, target_db, apply_compression)

            success_count += 1

        except Exception as e:
            print(f"  ERROR: {e}")
            error_count += 1
            # Try to close any open project
            try:
                send_command('Close:')
            except:
                pass

    print("-" * 50)
    print(f"✓ Complete: {success_count} processed, {error_count} errors")
    print("")

def main():
    parser = argparse.ArgumentParser(
        description='Batch master audio files for consistent volume levels',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Master all SFX to -6dB
  python batch_master_audio.py ../sfx --type sfx --target -6

  # Master music with compression
  python batch_master_audio.py ../music --type music --target -3 --compress

  # Master voice lines
  python batch_master_audio.py ../voice --type voice --target -3

Output files are created with "_mastered" suffix, originals are preserved.
        """
    )

    parser.add_argument('directory', help='Directory containing audio files')
    parser.add_argument('--type', choices=['sfx', 'music', 'voice'],
                        required=True, help='Audio type (determines compression settings)')
    parser.add_argument('--target', type=float, default=-6,
                        help='Target normalization level in dB (default: -6)')
    parser.add_argument('--compress', action='store_true',
                        help='Apply compression for more consistent loudness')

    args = parser.parse_args()

    directory = os.path.abspath(args.directory)

    if not os.path.isdir(directory):
        print(f"Error: Directory not found: {directory}")
        sys.exit(1)

    batch_master_directory(directory, args.type, args.target, args.compress)

if __name__ == '__main__':
    main()
