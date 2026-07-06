<#
.SYNOPSIS
    Lists active vCenter sessions.
.DESCRIPTION
    Uses the SessionManager to report every currently logged-in session with the
    user, source IP, login time, last-active time and the client application.
.EXAMPLE
    PS> ./Get-VISession.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$si = Get-View ServiceInstance
$sm = Get-View $si.Content.SessionManager
$sm.SessionList | Select-Object `
    UserName,
    @{N='IPAddress';E={$_.IpAddress}},
    @{N='Application';E={$_.UserAgent}},
    LoginTime, LastActiveTime,
    @{N='Current';E={$_.Key -eq $sm.CurrentSession.Key}} |
    Sort-Object LastActiveTime -Descending
