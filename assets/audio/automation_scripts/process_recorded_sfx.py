#!/usr/bin/env python3
"""
Audacity Automation Script: Process Recorded SFX
================================================

Purpose: Process recorded sound effects with 2-second silence prefix
- Extracts noise profile from first 2 seconds
- Applies noise reduction
- Trims silence prefix
- Normalizes to -6dB peak
- Exports as WAV 16-bit 44.1kHz

Usage:
1. Open Audacity
2. Enable mod-script-pipe: Edit → Preferences → Modules → mod-script-pipe → Enabled
3. Restart Audacity
4. Run: python process_recorded_sfx.py input.wav output.wav

Requirements:
- Audacity 3.0+ with mod-script-pipe enabled
- Input file must have ~2 seconds of silence at the beginning
"""

import sys
import os
import time

def send_command(command):
    """Send command to Audacity via named pipe."""
    if sys.platform == 'win32':
        pipe_path = '\\\\.\\pipe\\ToSrvPipe'
        response_pipe_path = '\\\\.\\pipe\\FromSrvPipe'
    else:
        pipe_path = '/tmp/audacity_script_pipe.to.' + str(os.getuid())
        response_pipe_path = '/tmp/audacity_script_pipe.from.' + str(os.getuid())

    try:
        # Send command
        with open(pipe_path, 'w') as pipe:
            pipe.write(command + '\n')

        # Read response
        with open(response_pipe_path, 'r') as response_pipe:
            response = response_pipe.read()

        return response
    except Exception as e:
        print(f"Error: {e}")
        print("Make sure Audacity is running with mod-script-pipe enabled!")
        sys.exit(1)

def process_recorded_sfx(input_file, output_file):
    """Process recorded SFX with noise reduction from silence prefix."""

    print(f"Processing: {input_file}")
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

    # 5. Apply noise reduction (moderate settings)
    # Sensitivity: 12dB, Frequency smoothing: 3, Noise: Reduce 12dB
    send_command('NoiseReduction: Use_Preset="<Factory Defaults>" Sensitivity=12 Gain=0 AttackTime=0.15 ReleaseTime=0.15 FreqSmoothing=3')
    time.sleep(0.5)

    # 6. Trim silence from beginning (remove first ~2 seconds)
    print("4. Trimming silence prefix...")
    send_command('Select: Start=0 End=2.5')  # Trim a bit extra to be safe
    time.sleep(0.2)
    send_command('Delete:')
    time.sleep(0.2)

    # 7. Trim any remaining silence at start and end
    send_command('SelectAll:')
    send_command('TruncateSilence: Action="Truncate Detected Silence" Compress=50 Independent=0 Minimum=0.1 Threshold=-40 Truncate=0.5')
    time.sleep(0.5)

    # 8. Normalize to -6dB peak (per SovietTD audio guidelines)
    print("5. Normalizing to -6dB peak...")
    send_command('SelectAll:')
    send_command('Normalize: PeakLevel=-6 RemoveDcOffset="Yes" ApplyGain="Yes"')
    time.sleep(0.5)

    # 9. Export as WAV 16-bit 44.1kHz
    print("6. Exporting as WAV 16-bit 44.1kHz...")
    send_command(f'Export2: Filename="{output_file}" NumChannels=1 SampleRate=44100')
    time.sleep(1.0)

    # 10. Close project without saving
    print("7. Cleaning up...")
    send_command('SelectAll:')
    send_command('Close:')

    print("-" * 50)
    print(f"✓ Processing complete: {output_file}")
    print("")

def main():
    if len(sys.argv) < 3:
        print("Usage: python process_recorded_sfx.py input.wav output.wav")
        print("")
        print("Example:")
        print("  python process_recorded_sfx.py ~/raw/tower_shoot.wav ~/SFX/tower_shoot.wav")
        sys.exit(1)

    input_file = os.path.abspath(sys.argv[1])
    output_file = os.path.abspath(sys.argv[2])

    if not os.path.exists(input_file):
        print(f"Error: Input file not found: {input_file}")
        sys.exit(1)

    # Create output directory if needed
    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)

    process_recorded_sfx(input_file, output_file)

if __name__ == '__main__':
    main()
