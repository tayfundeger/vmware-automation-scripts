<#
.SYNOPSIS
    Reports historical CPU/memory usage per cluster.
.DESCRIPTION
    Averages cpu.usage.average and mem.usage.average over a lookback window for
    each cluster, giving a trend view rather than an instant snapshot.
.PARAMETER Hours
    Lookback window in hours (default 24).
.EXAMPLE
    PS> ./Get-ClusterPerformance.ps1 -Hours 48
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Hours = 24)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$start = (Get-Date).AddHours(-$Hours)
foreach ($c in (Get-Cluster | Sort-Object Name)) {
    $cpu = Get-Stat -Entity $c -Stat cpu.usage.average -Start $start -Finish (Get-Date) -ErrorAction SilentlyContinue
    $mem = Get-Stat -Entity $c -Stat mem.usage.average -Start $start -Finish (Get-Date) -ErrorAction SilentlyContinue
    [pscustomobject]@{
        Cluster   = $c.Name
        AvgCPUPct = if ($cpu) { [math]::Round(($cpu | Measure-Object Value -Average).Average,1) } else { $null }
        MaxCPUPct = if ($cpu) { [math]::Round(($cpu | Measure-Object Value -Maximum).Maximum,1) } else { $null }
        AvgMemPct = if ($mem) { [math]::Round(($mem | Measure-Object Value -Average).Average,1) } else { $null }
        MaxMemPct = if ($mem) { [math]::Round(($mem | Measure-Object Value -Maximum).Maximum,1) } else { $null }
    }
}
