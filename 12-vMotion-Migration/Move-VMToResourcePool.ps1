<#
.SYNOPSIS
    Moves a VM into a resource pool.
.DESCRIPTION
    Changes the resource pool membership of a VM. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER ResourcePool
    Target resource pool.
.EXAMPLE
    PS> ./Move-VMToResourcePool.ps1 -Name app01 -ResourcePool RP-Prod
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$ResourcePool
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$rp = Get-ResourcePool -Name $ResourcePool -ErrorAction Stop

if ($PSCmdlet.ShouldProcess($Name, "Move to resource pool $ResourcePool")) {
    Move-VM -VM $vm -Destination $rp
}
