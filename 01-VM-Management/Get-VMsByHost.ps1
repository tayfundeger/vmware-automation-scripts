<#
.SYNOPSIS
    Lists VMs grouped by their ESXi host.
.DESCRIPTION
    For each host, enumerates the VMs it currently runs with basic sizing.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VMsByHost.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string]$VMHost = '*'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost -Name $VMHost | Sort-Object Name | ForEach-Object {
    $h = $_
    Get-VM -Location $h | Select-Object @{N='VMHost';E={$h.Name}}, Name, PowerState, NumCpu, MemoryGB
}
