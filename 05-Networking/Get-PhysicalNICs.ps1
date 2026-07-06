<#
.SYNOPSIS
    Reports physical NICs (vmnic) per host.
.DESCRIPTION
    Lists physical uplinks with link speed, duplex and MAC address.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-PhysicalNICs.ps1
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
    Get-VMHostNetworkAdapter -VMHost $h -Physical | Select-Object `
        @{N='VMHost';E={$h.Name}}, Name, Mac,
        @{N='LinkSpeedMb';E={$_.ExtensionData.LinkSpeed.SpeedMb}},
        @{N='FullDuplex';E={$_.ExtensionData.LinkSpeed.Duplex}}
}
