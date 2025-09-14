# configure-wsl.ps1
Write-Host "=== Konfiguration von WSL nach Neustart ==="

# WSL2 als Standard setzen
wsl --set-default-version 2

# Standard-Distribution installieren (Ubuntu)
# Falls die Distro bereits installiert ist, wird dieser Schritt übersprungen.
try {
    wsl --install -d Ubuntu
    Write-Host "Ubuntu wurde installiert."
} catch {
    Write-Host "Ubuntu ist bereits installiert oder die Installation ist fehlgeschlagen."
}

# Optional: Standard-Distribution setzen
wsl --set-default Ubuntu

Write-Host "=== WSL Konfiguration abgeschlossen ==="
