<#
.SYNOPSIS
    Lists the top memory-consuming VMs right now.
.DESCRIPTION
    Uses QuickStats (HostMemoryUsage) for an instant ranking of the VMs
    consuming the most host memory in MB.
.PARAMETER Top
    Number of VMs to return (default 10).
.EXAMPLE
    PS> ./Get-TopMemoryVMs.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Top = 10)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' } | Select-Object Name,
    @{N='HostMemMB';E={$_.ExtensionData.Summary.QuickStats.HostMemoryUsage}},
    @{N='ConfiguredGB';E={$_.MemoryGB}},
    @{N='VMHost';E={$_.VMHost.Name}} |
    Sort-Object HostMemMB -Descending | Select-Object -First $Top
