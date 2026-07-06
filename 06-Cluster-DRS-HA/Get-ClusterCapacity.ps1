<#
.SYNOPSIS
    Reports N+1 failover headroom per cluster.
.DESCRIPTION
    Calculates total cluster CPU/memory and the resources that remain if the
    single largest host is lost - a quick N+1 capacity sanity check.
.EXAMPLE
    PS> ./Get-ClusterCapacity.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Sort-Object Name | ForEach-Object {
    $hosts = Get-VMHost -Location $_ | Where-Object { $_.ConnectionState -eq 'Connected' }
    if (-not $hosts) { return }

    $cpuTotal   = ($hosts | Measure-Object CpuTotalMhz -Sum).Sum
    $memTotal   = ($hosts | Measure-Object MemoryTotalGB -Sum).Sum
    $biggestCpu = ($hosts | Measure-Object CpuTotalMhz -Maximum).Maximum
    $biggestMem = ($hosts | Measure-Object MemoryTotalGB -Maximum).Maximum
    $cpuUsed    = ($hosts | Measure-Object CpuUsageMhz -Sum).Sum
    $memUsed    = ($hosts | Measure-Object MemoryUsageGB -Sum).Sum

    [pscustomobject]@{
        Cluster            = $_.Name
        Hosts              = $hosts.Count
        CPUTotalGHz        = [math]::Round($cpuTotal/1000,1)
        CPUUsedGHz         = [math]::Round($cpuUsed/1000,1)
        CPUAvailAfterN1GHz = [math]::Round(($cpuTotal - $biggestCpu - $cpuUsed)/1000,1)
        MemTotalGB         = [math]::Round($memTotal,0)
        MemUsedGB          = [math]::Round($memUsed,0)
        MemAvailAfterN1GB  = [math]::Round($memTotal - $biggestMem - $memUsed,0)
    }
}
