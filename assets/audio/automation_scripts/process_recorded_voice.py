#!/usr/bin/env python3
"""
Audacity Automation Script: Process Recorded Voice Lines
=========================================================

Purpose: Process recorded voice lines with 2-second silence prefix
- Extracts noise profile from first 2 seconds
- Applies noise reduction
- Trims silence prefix
- Applies voice effects (radio/propaganda)
- Normalizes to -3dB peak
- Exports as OGG Vorbis

Usage:
1. python process_recorded_voice.py input.wav output.ogg --type commander
2. python process_recorded_voice.py input.wav output.ogg --type propaganda
3. python process_recorded_voice.py input.wav output.ogg --type enemy

Voice Types:
- commander: Adds radio static filter (for Soviet commander voice)
- propaganda: Adds echo + low-pass filter (for loudspeaker effect)
- enemy: No effects (clean voice with noise reduction)
- none: No effects (clean voice)
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

def process_recorded_voice(input_file, output_file, voice_type='none'):
    """Process recorded voice with optional effects."""

    print(f"Processing: {input_file}")
    print(f"Voice Type: {voice_type}")
    print(f"Output: {output_file}")
    print("-" * 50)

    # 1. Import audio file
    print("1. Importing audio file...")
    send_command(f'Import2: Filename="{input_file}"')
    time.sleep(0.5)

    # 2. Select first 2 seconds for noise profile
    print("2. Extracting noise profile from first 2 seconds...")
    send_command('Select: Start=0 End=2')
    time.sleep(0.2)

    # 3. Get noise profile
    send_command('GetNoiseProfile:')
    time.sleep(0.5)

    # 4. Select entire track
    print("3. Applying noise reduction...")
    send_command('SelectAll:')
    time.sleep(0.2)

    # 5. Apply noise reduction (moderate settings for voice)
    send_command('NoiseReduction: Use_Preset="<Factory Defaults>" Sensitivity=12 Gain=0 AttackTime=0.15 ReleaseTime=0.15 FreqSmoothing=3')
    time.sleep(0.5)

    # 6. Trim silence from beginning
    print("4. Trimming silence prefix...")
    send_command('Select: Start=0 End=2.5')
    time.sleep(0.2)
    send_command('Delete:')
    time.sleep(0.2)

    # 7. Trim any remaining silence at start and end
    send_command('SelectAll:')
    send_command('TruncateSilence: Action="Truncate Detected Silence" Compress=50 Independent=0 Minimum=0.1 Threshold=-35 Truncate=0.3')
    time.sleep(0.5)

    # 8. Apply voice-specific effects
    if voice_type == 'commander':
        print("5. Applying commander radio effect...")
        send_command('SelectAll:')

        # High-pass filter to remove low rumble
        send_command('HighpassFilter: Frequency=200 Rolloff="dB12"')
        time.sleep(0.3)

        # Low-pass filter for radio effect
        send_command('LowpassFilter: Frequency=3000 Rolloff="dB12"')
        time.sleep(0.3)

        # Add subtle distortion for radio character
        send_command('Distortion: Type="Hard Clip" Drive=5')
        time.sleep(0.3)

    elif voice_type == 'propaganda':
        print("5. Applying propaganda loudspeaker effect...")
        send_command('SelectAll:')

        # Echo effect (loudspeaker reverb)
        send_command('Echo: Delay=0.2 Decay=0.4')
        time.sleep(0.3)

        # Low-pass filter (muffled speaker sound)
        send_command('LowpassFilter: Frequency=2500 Rolloff="dB12"')
        time.sleep(0.3)

        # Slight EQ boost in mids (megaphone character)
        send_command('Equalization: FilterLength=4001 InterpolateLin=0 InterpolateDB=0 Curve="Telephone"')
        time.sleep(0.3)

    elif voice_type == 'enemy':
        print("5. No special effects (enemy voice)...")
        # Clean voice, just noise reduction

    else:  # 'none'
        print("5. No special effects...")

    # 9. Normalize to -3dB peak (per SovietTD voice guidelines)
    print("6. Normalizing to -3dB peak...")
    send_command('SelectAll:')
    send_command('Normalize: PeakLevel=-3 RemoveDcOffset="Yes" ApplyGain="Yes"')
    time.sleep(0.5)

    # 10. Export as OGG Vorbis (Quality 5 = ~128 kbps)
    print("7. Exporting as OGG Vorbis...")
    send_command(f'Export2: Filename="{output_file}" NumChannels=1 SampleRate=44100')
    time.sleep(1.0)

    # 11. Close project without saving
    print("8. Cleaning up...")
    send_command('SelectAll:')
    send_command('Close:')

    print("-" * 50)
    print(f"✓ Processing complete: {output_file}")
    print("")

def main():
    parser = argparse.ArgumentParser(
        description='Process recorded voice lines with optional effects',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Commander voice with radio effect
  python process_recorded_voice.py wave_incoming.wav wave_incoming.ogg --type commander

  # Propaganda tower voice
  python process_recorded_voice.py propaganda_line.wav propaganda.ogg --type propaganda

  # Enemy death line (clean)
  python process_recorded_voice.py enemy_death.wav enemy_death.ogg --type enemy
        """
    )

    parser.add_argument('input_file', help='Input WAV file with 2-second silence prefix')
    parser.add_argument('output_file', help='Output OGG file')
    parser.add_argument('--type', choices=['commander', 'propaganda', 'enemy', 'none'],
                        default='none', help='Voice type (applies specific effects)')

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

    process_recorded_voice(input_file, output_file, args.type)

if __name__ == '__main__':
    main()
