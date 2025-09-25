#!/usr/bin/env python3
import os
import sys
import subprocess

def main():
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Path to the AutoHotkey script
    ahk_script = os.path.join(script_dir, "lizard_sounds.ahk")

    # Try to run the AutoHotkey script
    try:
        subprocess.run(["AutoHotkey.exe", ahk_script], check=True)
    except subprocess.CalledProcessError:
        print("Error: Failed to run AutoHotkey script")
        sys.exit(1)
    except FileNotFoundError:
        print("Error: AutoHotkey not found in PATH")
        sys.exit(1)

if __name__ == "__main__":
    main()