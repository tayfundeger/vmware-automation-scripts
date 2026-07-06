<#
.SYNOPSIS
    Enters or exits maintenance mode on an ESXi host.
.DESCRIPTION
    Puts a host into maintenance mode, or takes it out with -Exit. Entering
    maintenance mode requires running VMs to be evacuated; in a fully-automated
    DRS cluster this happens automatically, otherwise migrate/power off VMs first.
.PARAMETER VMHost
    Host name.
.PARAMETER Exit
    Exit maintenance mode instead of entering it.
.EXAMPLE
    PS> ./Set-HostMaintenanceMode.ps1 -VMHost esxi03
.EXAMPLE
    PS> ./Set-HostMaintenanceMode.ps1 -VMHost esxi03 -Exit
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHost,
    [switch]$Exit
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h = Get-VMHost -Name $VMHost -ErrorAction Stop

if ($Exit) {
    if ($PSCmdlet.ShouldProcess($VMHost, 'Exit maintenance mode')) {
        Set-VMHost -VMHost $h -State Connected
    }
} else {
    if ($PSCmdlet.ShouldProcess($VMHost, 'Enter maintenance mode')) {
        Set-VMHost -VMHost $h -State Maintenance
    }
}
