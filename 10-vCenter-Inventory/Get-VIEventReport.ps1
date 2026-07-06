<#
.SYNOPSIS
    Reports vCenter events over a time window.
.DESCRIPTION
    Retrieves events from the last N days and summarizes them, optionally
    filtering by a text pattern in the message. Great for a quick "what happened"
    overview.
.PARAMETER Days
    Lookback window in days (default 1).
.PARAMETER Match
    Optional text pattern to filter event messages.
.EXAMPLE
    PS> ./Get-VIEventReport.ps1 -Days 2 -Match error
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 1, [string]$Match)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$events = Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000
if ($Match) { $events = $events | Where-Object { $_.FullFormattedMessage -match $Match } }

$events | Select-Object CreatedTime, UserName,
    @{N='Type';E={$_.GetType().Name}},
    @{N='Message';E={$_.FullFormattedMessage}} |
    Sort-Object CreatedTime -Descending
