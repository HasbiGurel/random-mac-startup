<#
  Random MAC Startup - Kurulum
  Kullanim:  install.ps1 [-AdapterName "Ethernet"]
#>
param(
    [string]$AdapterName
)

# Yonetici degilse kendini yonetici olarak yeniden baslat
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    $argList = @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$PSCommandPath`"")
    if ($AdapterName) { $argList += @('-AdapterName',"`"$AdapterName`"") }
    Start-Process powershell -Verb RunAs -ArgumentList $argList
    exit
}

# Bagdastirici secimi
if (-not $AdapterName) {
    $adapters = Get-NetAdapter -Physical | Sort-Object Name
    Write-Host "`nFiziksel ag bagdastiricilari:`n"
    for ($i = 0; $i -lt $adapters.Count; $i++) {
        Write-Host ("  [{0}] {1}  ({2})  {3}  {4}" -f $i, $adapters[$i].Name, $adapters[$i].InterfaceDescription, $adapters[$i].MacAddress, $adapters[$i].Status)
    }
    $sel = Read-Host "`nMAC adresi degistirilecek bagdastiricinin numarasi"
    $AdapterName = $adapters[[int]$sel].Name
}

$installDir = 'C:\ProgramData\RandomMac'
$taskName   = 'RandomMacAtStartup'

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot 'random-mac.ps1') -Destination $installDir -Force

# Orijinal MAC adresini yedekle (yalnizca ilk kurulumda)
$backup = Join-Path $installDir 'original-mac.txt'
if (-not (Test-Path $backup)) {
    (Get-NetAdapter -Name $AdapterName).MacAddress | Set-Content $backup
}
$AdapterName | Set-Content (Join-Path $installDir 'adapter.txt')

$action    = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installDir\random-mac.ps1`" -AdapterName `"$AdapterName`""
$trigger   = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
$settings  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null

Write-Host "`nKurulum tamamlandi. '$AdapterName' her acilista rastgele MAC alacak."
$now = Read-Host "Simdi de bir kez degistirilsin mi? (E/H)"
if ($now -match '^[EeYy]') {
    & "$installDir\random-mac.ps1" -AdapterName $AdapterName
    Start-Sleep 5
    Write-Host ("Yeni MAC: " + (Get-NetAdapter -Name $AdapterName).MacAddress)
}
Read-Host "`nCikmak icin Enter"