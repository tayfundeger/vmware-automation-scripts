<#
.SYNOPSIS
    Migrates a VM to another host via vMotion.
.DESCRIPTION
    Performs a live (or cold) vMotion of a VM to a specified destination host.
.PARAMETER Name
    VM name to migrate.
.PARAMETER DestinationHost
    Target ESXi host name.
.EXAMPLE
    PS> ./Move-VMToHost.ps1 -Name app01 -DestinationHost esxi05
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$DestinationHost
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm   = Get-VM     -Name $Name            -ErrorAction Stop
$dest = Get-VMHost -Name $DestinationHost -ErrorAction Stop

if ($PSCmdlet.ShouldProcess($Name, "vMotion to $DestinationHost")) {
    Move-VM -VM $vm -Destination $dest
}
