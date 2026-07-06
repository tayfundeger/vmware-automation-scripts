<#
.SYNOPSIS
    Reports user login/logout events.
.DESCRIPTION
    Retrieves vCenter login and logout session events over the last N days for
    security auditing.
.PARAMETER Days
    Lookback window in days (default 1).
.EXAMPLE
    PS> ./Get-LoginEvents.ps1 -Days 7
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 1)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object { $_ -is [VMware.Vim.UserLoginSessionEvent] -or $_ -is [VMware.Vim.UserLogoutSessionEvent] } |
    Select-Object CreatedTime, UserName,
        @{N='IPAddress';E={$_.IpAddress}},
        @{N='Type';E={$_.GetType().Name -replace 'Event$',''}} |
    Sort-Object CreatedTime -Descending
