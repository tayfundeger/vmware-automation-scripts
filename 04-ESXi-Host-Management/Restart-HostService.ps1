<#
.SYNOPSIS
    Restarts a service on one or more ESXi hosts.
.DESCRIPTION
    Restarts a named service (by key, e.g. TSM-SSH, ntpd, DCUI) across the
    selected hosts. Supports -WhatIf.
.PARAMETER ServiceKey
    Service key to restart (e.g. 'TSM-SSH', 'ntpd').
.PARAMETER VMHost
    Host name filter (wildcards allowed, default all hosts).
.EXAMPLE
    PS> ./Restart-HostService.ps1 -ServiceKey ntpd -VMHost esxi01
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$ServiceKey,
    [string]$VMHost = '*'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    $svc = Get-VMHostService -VMHost $h | Where-Object { $_.Key -eq $ServiceKey }
    if (-not $svc) { Write-Warning "$($h.Name): service '$ServiceKey' not found."; continue }
    if ($PSCmdlet.ShouldProcess($h.Name, "Restart service $ServiceKey")) {
        Restart-VMHostService -HostService $svc -Confirm:$false | Out-Null
        Write-Host "$($h.Name): $ServiceKey restarted."
    }
}
