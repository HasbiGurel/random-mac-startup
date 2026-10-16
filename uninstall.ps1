<#
  Random MAC Startup - Kaldirma (orijinal MAC adresine geri doner)
#>
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell -Verb RunAs -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$PSCommandPath`"")
    exit
}

$installDir = 'C:\ProgramData\RandomMac'
$taskName   = 'RandomMacAtStartup'

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue

$adapterFile = Join-Path $installDir 'adapter.txt'
$adapter = if (Test-Path $adapterFile) { (Get-Content $adapterFile).Trim() } else { 'Ethernet' }

# Elle atanan adresi kaldir -> donanim (fabrika) adresine don
Reset-NetAdapterAdvancedProperty -Name $adapter -RegistryKeyword 'NetworkAddress' -ErrorAction SilentlyContinue
Remove-NetAdapterAdvancedProperty -Name $adapter -RegistryKeyword 'NetworkAddress' -ErrorAction SilentlyContinue
Restart-NetAdapter -Name $adapter -ErrorAction SilentlyContinue
Start-Sleep 5

Remove-Item -Path $installDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ("Kaldirildi. '$adapter' guncel MAC: " + (Get-NetAdapter -Name $adapter).MacAddress)
Read-Host "`nCikmak icin Enter"