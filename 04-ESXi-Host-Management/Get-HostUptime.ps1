<#
.SYNOPSIS
    Reports uptime of each ESXi host.
.DESCRIPTION
    Uses QuickStats.Uptime to report how long each connected host has been up.
.EXAMPLE
    PS> ./Get-HostUptime.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Select-Object Name,
    @{N='UptimeDays';E={[math]::Round($_.ExtensionData.Summary.QuickStats.Uptime/86400,1)}},
    @{N='ConnectionState';E={$_.ConnectionState}} |
    Sort-Object UptimeDays -Descending
