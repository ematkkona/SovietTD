#!/usr/bin/env python3
"""
Test Audacity Connection - Verify mod-script-pipe is working
=============================================================

This script tests if Audacity is running and accepting script commands.
Run this BEFORE trying the other automation scripts to verify your setup.

Usage:
    python test_audacity_connection.py
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
        # Check if pipe exists
        if not os.path.exists(pipe_path):
            print(f"❌ ERROR: Pipe not found at: {pipe_path}")
            print()
            print("This means mod-script-pipe is not enabled or Audacity is not running.")
            print()
            print("To fix:")
            print("1. Open Audacity")
            print("2. Go to Edit → Preferences → Modules")
            print("3. Set mod-script-pipe to 'Enabled'")
            print("4. Restart Audacity")
            print("5. Run this test script again")
            return None

        # Send command
        with open(pipe_path, 'w') as pipe:
            pipe.write(command + '\n')

        # Read response
        with open(response_pipe_path, 'r') as response_pipe:
            response = response_pipe.read()

        return response

    except Exception as e:
        print(f"❌ ERROR: {e}")
        return None

def main():
    print("=" * 60)
    print("Audacity mod-script-pipe Connection Test")
    print("=" * 60)
    print()

    # Test 1: Check if Audacity is running
    print("Test 1: Checking if Audacity is running...")
    result = send_command('Help:')

    if result is None:
        print("❌ FAILED: Cannot connect to Audacity")
        print()
        print("Make sure:")
        print("1. Audacity is running")
        print("2. mod-script-pipe is enabled (Edit → Preferences → Modules)")
        print("3. You've restarted Audacity after enabling mod-script-pipe")
        sys.exit(1)
    else:
        print("✅ PASSED: Connected to Audacity successfully!")
        print()

    # Test 2: Try a simple command
    print("Test 2: Sending test command...")
    result = send_command('GetInfo: Type=Commands')

    if result and len(result) > 10:
        print("✅ PASSED: Audacity is responding to commands!")
        print()
    else:
        print("❌ FAILED: Audacity not responding properly")
        sys.exit(1)

    # Test 3: Generate a tone and delete it (full workflow test)
    print("Test 3: Testing audio generation workflow...")

    # Generate 1 second tone
    send_command('NewMonoTrack:')
    time.sleep(0.2)

    send_command('Select: Start=0 End=1')
    time.sleep(0.2)

    send_command('Tone: Frequency=440 Amplitude=0.5')
    time.sleep(0.5)

    # Delete the track
    send_command('SelectAll:')
    time.sleep(0.2)

    send_command('Close:')
    time.sleep(0.2)

    print("✅ PASSED: Full workflow test successful!")
    print()

    # All tests passed
    print("=" * 60)
    print("🎉 SUCCESS! Your Audacity setup is working correctly!")
    print("=" * 60)
    print()
    print("You can now use the audio automation scripts:")
    print("  • process_recorded_sfx.py")
    print("  • process_recorded_voice.py")
    print("  • process_downloaded_audio.py")
    print("  • batch_master_audio.py")
    print()
    print("See README.md for usage instructions.")
    print()

if __name__ == '__main__':
    main()
