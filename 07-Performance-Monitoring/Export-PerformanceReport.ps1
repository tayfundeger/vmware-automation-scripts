<#
.SYNOPSIS
    Builds a combined per-VM performance report.
.DESCRIPTION
    Averages CPU %, memory %, disk latency and network usage per VM over a
    lookback window and exports the result to CSV (or the pipeline).
.PARAMETER Hours
    Lookback window in hours (default 24).
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Export-PerformanceReport.ps1 -Hours 24 -Path C:\Reports\perf.csv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Hours = 24, [string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms   = Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' }
if (-not $vms) { Write-Host 'No powered-on VMs.'; return }
$start = (Get-Date).AddHours(-$Hours)
$stats = 'cpu.usage.average','mem.usage.average','disk.maxTotalLatency.average','net.usage.average'

$raw = Get-Stat -Entity $vms -Stat $stats -Start $start -Finish (Get-Date) -ErrorAction SilentlyContinue
$report = $raw | Group-Object Entity | ForEach-Object {
    $g = $_.Group
    [pscustomobject]@{
        VM           = $_.Name
        AvgCPUPct    = [math]::Round((($g | Where-Object MetricId -eq 'cpu.usage.average')            | Measure-Object Value -Average).Average,1)
        AvgMemPct    = [math]::Round((($g | Where-Object MetricId -eq 'mem.usage.average')            | Measure-Object Value -Average).Average,1)
        AvgLatencyMs = [math]::Round((($g | Where-Object MetricId -eq 'disk.maxTotalLatency.average') | Measure-Object Value -Average).Average,1)
        AvgNetMbps   = [math]::Round(((($g | Where-Object MetricId -eq 'net.usage.average')           | Measure-Object Value -Average).Average * 8)/1000,2)
    }
} | Sort-Object AvgCPUPct -Descending

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
