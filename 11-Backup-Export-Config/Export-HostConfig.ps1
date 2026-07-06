<#
.SYNOPSIS
    Exports each ESXi host's key configuration to JSON.
.DESCRIPTION
    Writes one JSON file per host (into -OutputFolder) capturing version, NTP,
    syslog, DNS, services and lockdown mode - a quick config snapshot for
    documentation or drift comparison.
.PARAMETER OutputFolder
    Destination folder (default .\HostConfigs).
.EXAMPLE
    PS> ./Export-HostConfig.ps1 -OutputFolder C:\Backup\Hosts
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$OutputFolder = '.\HostConfigs')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

foreach ($h in (Get-VMHost)) {
    $net = Get-VMHostNetwork -VMHost $h
    $cfg = [ordered]@{
        Host         = $h.Name
        Version      = $h.Version
        Build        = $h.Build
        LockdownMode = "$($h.ExtensionData.Config.LockdownMode)"
        NTPServers   = @(Get-VMHostNtpServer -VMHost $h)
        Syslog       = @(Get-VMHostSysLogServer -VMHost $h | ForEach-Object { "$($_.Host):$($_.Port)" })
        DNS          = @($net.DnsAddress)
        DomainName   = $net.DomainName
        Services     = @(Get-VMHostService -VMHost $h | ForEach-Object {
                        [ordered]@{ Key=$_.Key; Running=$_.Running; Policy="$($_.Policy)" } })
    }
    $file = Join-Path $OutputFolder ("{0}.json" -f ($h.Name -replace '[\\/:*?"<>|]', '_'))
    $cfg | ConvertTo-Json -Depth 5 | Out-File -FilePath $file -Encoding UTF8
    Write-Host "Exported $($h.Name) -> $file"
}
