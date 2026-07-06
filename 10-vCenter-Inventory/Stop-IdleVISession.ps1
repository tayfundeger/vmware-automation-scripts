<#
.SYNOPSIS
    Terminates idle vCenter sessions.
.DESCRIPTION
    Finds sessions whose last-active time is older than -IdleMinutes and
    terminates them (never the current session). Supports -WhatIf.
.PARAMETER IdleMinutes
    Idle threshold in minutes (default 120).
.EXAMPLE
    PS> ./Stop-IdleVISession.ps1 -IdleMinutes 240 -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([int]$IdleMinutes = 120)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$si = Get-View ServiceInstance
$sm = Get-View $si.Content.SessionManager
$cutoff = (Get-Date).ToUniversalTime().AddMinutes(-$IdleMinutes)

$idle = $sm.SessionList | Where-Object {
    $_.Key -ne $sm.CurrentSession.Key -and $_.LastActiveTime -lt $cutoff
}
if (-not $idle) { Write-Host "No idle sessions older than $IdleMinutes minutes."; return }

foreach ($s in $idle) {
    if ($PSCmdlet.ShouldProcess("$($s.UserName) from $($s.IpAddress)", 'Terminate session')) {
        $sm.TerminateSession($s.Key)
        Write-Host "Terminated session: $($s.UserName) ($($s.IpAddress))"
    }
}
