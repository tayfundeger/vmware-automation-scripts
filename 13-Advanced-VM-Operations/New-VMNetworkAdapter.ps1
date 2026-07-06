<#
.SYNOPSIS
    Adds a network adapter to a VM.
.DESCRIPTION
    Creates a new NIC of the given type connected to a port group. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER NetworkName
    Port group to connect to.
.PARAMETER Type
    Adapter type (default Vmxnet3).
.PARAMETER StartConnected
    Whether the NIC is connected at power-on (default true).
.EXAMPLE
    PS> ./New-VMNetworkAdapter.ps1 -Name app01 -NetworkName "APP-VLAN20"
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$NetworkName,
    [ValidateSet('e1000','e1000e','Vmxnet3','Vmxnet2','Flexible')][string]$Type = 'Vmxnet3',
    [bool]$StartConnected = $true
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($Name, "Add $Type adapter on '$NetworkName'")) {
    New-NetworkAdapter -VM $vm -NetworkName $NetworkName -Type $Type -StartConnected:$StartConnected -Confirm:$false
}
