# install-wsl.ps1
Write-Host "=== Aktivieren der WSL-Features ==="

# Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Virtual Machine Platform (für WSL2 notwendig)
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Optional: Hyper-V (nicht zwingend notwendig für WSL2, aber empfohlen auf VMs)
# dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart

Write-Host "=== Features wurden aktiviert. Neustart erforderlich! ==="
