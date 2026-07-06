<#
.SYNOPSIS
    Reports VMkernel (vmk) adapters per host.
.DESCRIPTION
    Lists VMkernel interfaces with IP, subnet, MAC, port group and which traffic
    types (management, vMotion, etc.) are enabled.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VMKernelAdapters.ps1
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
    Get-VMHostNetworkAdapter -VMHost $h -VMKernel | Select-Object `
        @{N='VMHost';E={$h.Name}}, Name, IP, SubnetMask, Mac, PortGroupName,
        @{N='Mgmt';E={$_.ManagementTrafficEnabled}},
        @{N='vMotion';E={$_.VMotionEnabled}}
}
