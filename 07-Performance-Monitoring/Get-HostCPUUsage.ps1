<#
.SYNOPSIS
    Reports current CPU utilization per host.
.DESCRIPTION
    Uses the host CpuUsageMhz / CpuTotalMhz counters for an instant view of CPU
    load across all hosts.
.EXAMPLE
    PS> ./Get-HostCPUUsage.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Select-Object Name,
    @{N='UsedGHz';E={[math]::Round($_.CpuUsageMhz/1000,1)}},
    @{N='TotalGHz';E={[math]::Round($_.CpuTotalMhz/1000,1)}},
    @{N='CPUPct';E={ if ($_.CpuTotalMhz) { [math]::Round(($_.CpuUsageMhz/$_.CpuTotalMhz)*100,1) } else { 0 } }} |
    Sort-Object CPUPct -Descending
