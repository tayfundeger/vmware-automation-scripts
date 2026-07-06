<#
.SYNOPSIS
    Exports vCenter events over a window to CSV.
.DESCRIPTION
    Dumps events from the last N days (optionally filtered by a message pattern)
    to a CSV file for archival or offline analysis.
.PARAMETER Days
    Lookback window in days (default 7).
.PARAMETER Match
    Optional message text filter.
.PARAMETER Path
    CSV output path (default .\vievents.csv).
.EXAMPLE
    PS> ./Export-EventLog.ps1 -Days 30 -Path C:\Logs\events.csv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 7, [string]$Match, [string]$Path = '.\vievents.csv')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$events = Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000
if ($Match) { $events = $events | Where-Object { $_.FullFormattedMessage -match $Match } }

$rows = $events | Select-Object CreatedTime, UserName,
    @{N='Type';E={$_.GetType().Name -replace 'Event$',''}},
    @{N='Message';E={$_.FullFormattedMessage}} |
    Sort-Object CreatedTime -Descending

$rows | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($rows.Count) events to $Path"
