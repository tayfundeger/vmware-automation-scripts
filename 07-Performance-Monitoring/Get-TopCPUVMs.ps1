<#
.SYNOPSIS
    Lists the top CPU-consuming VMs right now.
.DESCRIPTION
    Uses QuickStats (OverallCpuUsage) for an instant ranking of the busiest VMs
    by CPU demand in MHz.
.PARAMETER Top
    Number of VMs to return (default 10).
.EXAMPLE
    PS> ./Get-TopCPUVMs.ps1 -Top 15
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
    @{N='CPUMhz';E={$_.ExtensionData.Summary.QuickStats.OverallCpuUsage}},
    @{N='NumCPU';E={$_.NumCpu}},
    @{N='VMHost';E={$_.VMHost.Name}} |
    Sort-Object CPUMhz -Descending | Select-Object -First $Top
