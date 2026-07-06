<#
.SYNOPSIS
    Produces a CPU/memory rightsizing report for all VMs.
.DESCRIPTION
    For each powered-on VM, averages and peaks CPU and memory usage (%) over the
    last N days and emits a simple recommendation (Downsize / OK / Upsize).
    Pipe to Export-Csv for a spreadsheet.
.PARAMETER Days
    Lookback window in days (default 14).
.EXAMPLE
    PS> ./Get-VMRightsizingReport.ps1 -Days 30 | Export-Csv rightsizing.csv -NoTypeInformation
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 14)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$start = (Get-Date).AddDays(-$Days)
foreach ($vm in (Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' })) {
    $stats = Get-Stat -Entity $vm -Stat cpu.usage.average, mem.usage.average -Start $start -ErrorAction SilentlyContinue
    if (-not $stats) { continue }
    $cpuVals = $stats | Where-Object { $_.MetricId -eq 'cpu.usage.average' } | Select-Object -ExpandProperty Value
    $memVals = $stats | Where-Object { $_.MetricId -eq 'mem.usage.average' } | Select-Object -ExpandProperty Value
    $cpuAvg = ($cpuVals | Measure-Object -Average).Average
    $cpuMax = ($cpuVals | Measure-Object -Maximum).Maximum
    $memAvg = ($memVals | Measure-Object -Average).Average
    $memMax = ($memVals | Measure-Object -Maximum).Maximum

    $rec = 'OK'
    if ($cpuAvg -lt 15 -and $memAvg -lt 30) { $rec = 'Downsize' }
    elseif ($cpuAvg -gt 80 -or $memAvg -gt 85) { $rec = 'Upsize' }

    [pscustomobject]@{
        VM             = $vm.Name
        NumCpu         = $vm.NumCpu
        MemoryGB       = $vm.MemoryGB
        AvgCpuPct      = [math]::Round($cpuAvg,1)
        MaxCpuPct      = [math]::Round($cpuMax,1)
        AvgMemPct      = [math]::Round($memAvg,1)
        MaxMemPct      = [math]::Round($memMax,1)
        Recommendation = $rec
    }
}
