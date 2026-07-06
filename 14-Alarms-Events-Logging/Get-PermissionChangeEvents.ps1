<#
.SYNOPSIS
    Reports permission add/remove/update events.
.DESCRIPTION
    Retrieves permission-change events over the last N days - a key audit trail
    for who granted or revoked access and when.
.PARAMETER Days
    Lookback window in days (default 30).
.EXAMPLE
    PS> ./Get-PermissionChangeEvents.ps1 -Days 90
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 30)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object { $_ -is [VMware.Vim.PermissionEvent] } |
    Select-Object CreatedTime, UserName,
        @{N='Type';E={$_.GetType().Name -replace 'Event$',''}},
        @{N='Message';E={$_.FullFormattedMessage}} |
    Sort-Object CreatedTime -Descending
