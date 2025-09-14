param(
    [switch]$InstallOptional
)

Start-Transcript -Path "C:\install-tools.log" -Force

Write-Host "Starte Installation der DevOps-Tools..." -ForegroundColor Cyan

# Stelle sicher, dass winget verfügbar ist
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget ist nicht installiert. Bitte zuerst App Installer aus dem Microsoft Store aktualisieren."
    exit 1
}

# Liste der Basis-Tools
$tools = @(
    @{ Name = "Git.Git";              Display = "Git" },
    @{ Name = "Microsoft.VisualStudioCode"; Display = "Visual Studio Code" },
    @{ Name = "Microsoft.WSL";        Display = "WSL" },
    @{ Name = "Ansible.Ansible";      Display = "Ansible" },
    @{ Name = "HashiCorp.Terraform";  Display = "Terraform" }
)

# Optionale Tools
if ($InstallOptional) {
    $tools += @(
        @{ Name = "Microsoft.AzureCLI"; Display = "Azure CLI" },
        @{ Name = "Docker.DockerDesktop"; Display = "Docker Desktop" },
        @{ Name = "Kubernetes.kubectl"; Display = "kubectl" },
        @{ Name = "Helm.Helm"; Display = "Helm" },
        @{ Name = "Python.Python.3"; Display = "Python 3" },
        @{ Name = "OpenJS.NodeJS.LTS"; Display = "Node.js LTS" },
        @{ Name = "7zip.7zip"; Display = "7-Zip" },
        @{ Name = "Notepad++.Notepad++"; Display = "Notepad++" }
    )
}

foreach ($tool in $tools) {
    Write-Host "Installiere $($tool.Display)..." -ForegroundColor Yellow
    winget install --id $($tool.Name) --silent --accept-package-agreements --accept-source-agreements -e
}

Write-Host "Alle gewünschten Tools wurden installiert." -ForegroundColor Green

Stop-Transcript
