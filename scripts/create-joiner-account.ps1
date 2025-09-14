param(
    [Parameter(Mandatory = $true)]
    [string]$DomainName,

    [Parameter(Mandatory = $true)]
    [string]$JoinerPassword
)

Write-Host "Starte Erstellung des Joiner-Accounts in Domain $DomainName"

# Passwort als SecureString
$secPass = ConvertTo-SecureString $JoinerPassword -AsPlainText -Force

# DN korrekt zusammensetzen
$dcParts   = $DomainName.Split('.') | ForEach-Object { "DC=$_" }
$domainDN  = ($dcParts -join ",")
$userPath  = "CN=Users,$domainDN"

# Prüfen, ob User schon existiert
if (-not (Get-ADUser -Filter { SamAccountName -eq "joiner" } -ErrorAction SilentlyContinue)) {
    New-ADUser `
        -Name "Joiner" `
        -SamAccountName "joiner" `
        -UserPrincipalName "joiner@$DomainName" `
        -AccountPassword $secPass `
        -Enabled $true `
        -PasswordNeverExpires $true `
        -Path $userPath

    Add-ADGroupMember -Identity "Domain Admins" -Members "joiner"

    Write-Host "User 'joiner' erfolgreich erstellt und zur Gruppe 'Domain Admins' hinzugefügt."
}
else {
    Write-Host "User 'joiner' existiert bereits. Überspringe Erstellung."
}

Write-Host "Fertig."
