<#
.SYNOPSIS
    Reports NTP configuration for each host.
.DESCRIPTION
    Lists configured NTP servers and whether the ntpd service is running and set
    to start with the host - a common source of time-drift issues.
.EXAMPLE
    PS> ./Get-HostNTPConfig.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Sort-Object Name | ForEach-Object {
    $h    = $_
    $ntpd = Get-VMHostService -VMHost $h | Where-Object { $_.Key -eq 'ntpd' }
    [pscustomobject]@{
        Host        = $h.Name
        NTPServers  = (Get-VMHostNtpServer -VMHost $h) -join ', '
        ServiceOn   = $ntpd.Running
        StartPolicy = $ntpd.Policy
    }
}
