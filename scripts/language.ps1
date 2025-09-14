# Setzt die Tastatur- und Eingabesprache auf Deutsch (Deutschland)
# LCID 1031 = de-DE

$Lang = "de-DE"

# Sprachpaket hinzufügen (falls noch nicht vorhanden)
if (-not (Get-WinUserLanguageList | Where-Object { $_.LanguageTag -eq $Lang })) {
    $list = Get-WinUserLanguageList
    $list.Add($Lang)
    Set-WinUserLanguageList $list -Force
}

# Eingabesprache explizit setzen
Set-WinUserLanguageList -LanguageList $Lang -Force

# System-Locale setzen
Set-WinSystemLocale $Lang

# Benutzer-Locale setzen
Set-Culture $Lang

# Zeitzone optional anpassen (Berlin)
# Set-TimeZone -Id "W. Europe Standard Time"

Write-Host "Eingabesprache und Tastaturlayout auf Deutsch (Deutschland) gesetzt."
