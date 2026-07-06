<#
.SYNOPSIS
    Lists hosts currently in maintenance mode.
.DESCRIPTION
    Reports every host whose state is Maintenance, along with its cluster - handy
    to confirm nothing was left in maintenance after patching.
.EXAMPLE
    PS> ./Get-VMHostInMaintenance.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$hosts = Get-VMHost | Where-Object { $_.ConnectionState -eq 'Maintenance' }
if (-not $hosts) { Write-Host 'No hosts are in maintenance mode.' -ForegroundColor Green; return }

$hosts | Select-Object Name,
    @{N='Cluster';E={(Get-Cluster -VMHost $_ -ErrorAction SilentlyContinue).Name}},
    PowerState, Version
