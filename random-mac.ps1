<#
  Belirtilen ag bagdastiricisina rastgele, yerel yonetilen (locally administered)
  bir MAC adresi atar. Yonetici/SYSTEM yetkisi gerektirir.
#>
param(
    [string]$AdapterName = 'Ethernet'
)

$logDir = 'C:\ProgramData\RandomMac'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log = Join-Path $logDir 'log.txt'

# Ilk bayt 02: unicast + locally administered (gercek bir ureticiyle cakismaz)
$bytes = 1..5 | ForEach-Object { '{0:X2}' -f (Get-Random -Maximum 256) }
$mac = '02' + ($bytes -join '')

try {
    Set-NetAdapter -Name $AdapterName -MacAddress $mac -Confirm:$false -ErrorAction Stop
    Add-Content -Path $log -Value "$(Get-Date -Format s) [$AdapterName] $mac OK"
} catch {
    Add-Content -Path $log -Value "$(Get-Date -Format s) [$AdapterName] HATA: $($_.Exception.Message)"
    exit 1
}