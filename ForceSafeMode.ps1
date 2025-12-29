# ForceSafeMode.ps1
# This script forces the computer to boot into Safe Mode

bcdedit /set {current} safeboot minimal
Restart-Computer