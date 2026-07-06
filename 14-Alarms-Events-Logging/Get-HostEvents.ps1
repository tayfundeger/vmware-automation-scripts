<#
.SYNOPSIS
    Reports ESXi host-related events.
.DESCRIPTION
    Retrieves host events (connection changes, maintenance mode, hardware alerts,
    etc.) over the last N days.
.PARAMETER Days
    Lookback window in days (default 1).
.PARAMETER HostName
    Optional host name filter.
.EXAMPLE
    PS> ./Get-HostEvents.ps1 -Days 2 -HostName esxi01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 1, [string]$HostName)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$events = Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object { $_ -is [VMware.Vim.HostEvent] }
if ($HostName) { $events = $events | Where-Object { $_.Host.Name -eq $HostName } }

$events | Select-Object CreatedTime, UserName,
    @{N='Host';E={$_.Host.Name}},
    @{N='Type';E={$_.GetType().Name -replace 'Event$',''}},
    @{N='Message';E={$_.FullFormattedMessage}} |
    Sort-Object CreatedTime -Descending
