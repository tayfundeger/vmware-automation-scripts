<#
.SYNOPSIS
    Reports standard virtual switches per host.
.DESCRIPTION
    Lists standard vSwitches with their uplinks (physical NICs), MTU and port
    count for every host.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VirtualSwitches.ps1
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
    Get-VirtualSwitch -VMHost $h -Standard | Select-Object `
        @{N='VMHost';E={$h.Name}}, Name,
        @{N='Uplinks';E={($_.Nic) -join ', '}},
        Mtu, NumPorts
}
