<#
.SYNOPSIS
    Configures NTP servers on ESXi hosts.
.DESCRIPTION
    Replaces the NTP server list on the selected hosts, enables the ntpd startup
    policy and restarts the service. Supports -WhatIf.
.PARAMETER NtpServer
    One or more NTP servers to set.
.PARAMETER VMHost
    Host name filter (wildcards allowed, default all hosts).
.EXAMPLE
    PS> ./Set-HostNTPConfig.ps1 -NtpServer 10.0.0.1,10.0.0.2 -VMHost "esxi0*"
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string[]]$NtpServer,
    [string]$VMHost = '*'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    if (-not $PSCmdlet.ShouldProcess($h.Name, "Set NTP servers: $($NtpServer -join ', ')")) { continue }

    # Remove existing, then add the desired set
    Get-VMHostNtpServer -VMHost $h | ForEach-Object { Remove-VMHostNtpServer -NtpServer $_ -VMHost $h -Confirm:$false }
    Add-VMHostNtpServer -NtpServer $NtpServer -VMHost $h | Out-Null

    $ntpd = Get-VMHostService -VMHost $h | Where-Object { $_.Key -eq 'ntpd' }
    Set-VMHostService -HostService $ntpd -Policy On -Confirm:$false | Out-Null
    Restart-VMHostService -HostService $ntpd -Confirm:$false | Out-Null
    Write-Host "$($h.Name): NTP configured and ntpd restarted."
}
