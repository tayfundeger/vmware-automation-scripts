<#
.SYNOPSIS
    Reports the remote syslog target for each host.
.DESCRIPTION
    Lists the configured syslog server(s) per host so you can confirm central
    log forwarding is in place.
.EXAMPLE
    PS> ./Get-HostSyslogConfig.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Sort-Object Name | ForEach-Object {
    $h      = $_
    $target = (Get-VMHostSysLogServer -VMHost $h | ForEach-Object { "$($_.Host):$($_.Port)" }) -join ', '
    [pscustomobject]@{
        Host   = $h.Name
        Syslog = if ($target) { $target } else { '(not configured)' }
    }
}
