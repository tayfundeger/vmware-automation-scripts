<#
.SYNOPSIS
    Reports current memory utilization per host.
.DESCRIPTION
    Uses MemoryUsageGB / MemoryTotalGB for an instant view of memory load across
    all hosts.
.EXAMPLE
    PS> ./Get-HostMemoryUsage.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Select-Object Name,
    @{N='UsedGB';E={[math]::Round($_.MemoryUsageGB,0)}},
    @{N='TotalGB';E={[math]::Round($_.MemoryTotalGB,0)}},
    @{N='MemPct';E={ if ($_.MemoryTotalGB) { [math]::Round(($_.MemoryUsageGB/$_.MemoryTotalGB)*100,1) } else { 0 } }} |
    Sort-Object MemPct -Descending
