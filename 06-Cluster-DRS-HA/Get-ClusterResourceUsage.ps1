<#
.SYNOPSIS
    Reports current CPU and memory utilization per cluster.
.DESCRIPTION
    Aggregates host CPU/memory totals and current usage for each cluster and
    calculates utilization percentages.
.EXAMPLE
    PS> ./Get-ClusterResourceUsage.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Sort-Object Name | ForEach-Object {
    $hosts = Get-VMHost -Location $_
    $cpuTotal = ($hosts | Measure-Object CpuTotalMhz -Sum).Sum
    $cpuUsed  = ($hosts | Measure-Object CpuUsageMhz -Sum).Sum
    $memTotal = ($hosts | Measure-Object MemoryTotalGB -Sum).Sum
    $memUsed  = ($hosts | Measure-Object MemoryUsageGB -Sum).Sum
    [pscustomobject]@{
        Cluster    = $_.Name
        Hosts      = $hosts.Count
        CPUUsedGHz = [math]::Round($cpuUsed/1000,1)
        CPUTotGHz  = [math]::Round($cpuTotal/1000,1)
        CPUPct     = if ($cpuTotal) { [math]::Round(($cpuUsed/$cpuTotal)*100,1) } else { 0 }
        MemUsedGB  = [math]::Round($memUsed,0)
        MemTotGB   = [math]::Round($memTotal,0)
        MemPct     = if ($memTotal) { [math]::Round(($memUsed/$memTotal)*100,1) } else { 0 }
    }
}
