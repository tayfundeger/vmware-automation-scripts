<#
.SYNOPSIS
    Reboots an ESXi host (maintenance-mode guarded).
.DESCRIPTION
    Reboots a host only if it is already in maintenance mode, unless -Force is
    supplied. Supports -WhatIf.
.PARAMETER VMHost
    Host name.
.PARAMETER Force
    Reboot even if the host is not in maintenance mode.
.EXAMPLE
    PS> ./Restart-VMHostSafely.ps1 -VMHost esxi04
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$VMHost, [switch]$Force)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h = Get-VMHost -Name $VMHost -ErrorAction Stop
if ($h.ConnectionState -ne 'Maintenance' -and -not $Force) {
    Write-Warning "$VMHost is not in maintenance mode. Enter maintenance mode first or use -Force."
    return
}

if ($PSCmdlet.ShouldProcess($VMHost, 'Reboot host')) {
    Restart-VMHost -VMHost $h -Confirm:$false
    Write-Host "$VMHost reboot initiated."
}
