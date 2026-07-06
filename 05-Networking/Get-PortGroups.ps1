<#
.SYNOPSIS
    Reports standard port groups and their VLAN IDs.
.DESCRIPTION
    Lists standard virtual port groups per host with the parent vSwitch and VLAN.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-PortGroups.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost -Name $VMHost | Sort-Object Name | ForEach-Object {
    $h = $_
    Get-VirtualPortGroup -VMHost $h -Standard | Select-Object `
        @{N='VMHost';E={$h.Name}}, Name,
        @{N='vSwitch';E={$_.VirtualSwitchName}},
        @{N='VLAN';E={$_.VLanId}}
}
