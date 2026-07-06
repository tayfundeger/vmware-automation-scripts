<#
.SYNOPSIS
    Creates a standard port group on a host vSwitch.
.DESCRIPTION
    Adds a new standard port group with an optional VLAN ID to a specified
    standard vSwitch on a host. Supports -WhatIf.
.PARAMETER VMHost
    Host name.
.PARAMETER VirtualSwitch
    Standard vSwitch name (e.g. vSwitch0).
.PARAMETER Name
    New port group name.
.PARAMETER VLanId
    Optional VLAN ID (0 = none).
.EXAMPLE
    PS> ./New-StandardPortGroup.ps1 -VMHost esxi01 -VirtualSwitch vSwitch0 -Name APP-VLAN20 -VLanId 20
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHost,
    [Parameter(Mandatory)][string]$VirtualSwitch,
    [Parameter(Mandatory)][string]$Name,
    [int]$VLanId = 0
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h  = Get-VMHost -Name $VMHost -ErrorAction Stop
$vs = Get-VirtualSwitch -VMHost $h -Name $VirtualSwitch -Standard -ErrorAction Stop

if ($PSCmdlet.ShouldProcess("$VMHost / $VirtualSwitch", "Create port group '$Name' (VLAN $VLanId)")) {
    New-VirtualPortGroup -VirtualSwitch $vs -Name $Name -VLanId $VLanId
}
