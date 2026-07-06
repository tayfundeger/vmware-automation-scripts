<#
.SYNOPSIS
    Finds oversized VMs (low utilization vs. allocation).
.DESCRIPTION
    Averages CPU and memory usage (%) over the last N days and returns powered-on
    VMs consistently below both thresholds - candidates to downsize.
.PARAMETER Days
    Lookback window in days (default 7).
.PARAMETER CpuMaxPct
    CPU average below this is "oversized" (default 15).
.PARAMETER MemMaxPct
    Memory average below this is "oversized" (default 30).
.EXAMPLE
    PS> ./Get-OversizedVMs.ps1 -Days 30
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 7, [double]$CpuMaxPct = 15, [double]$MemMaxPct = 30)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$start = (Get-Date).AddDays(-$Days)
foreach ($vm in (Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' })) {
    $stats = Get-Stat -Entity $vm -Stat cpu.usage.average, mem.usage.average -Start $start -ErrorAction SilentlyContinue
    if (-not $stats) { continue }
    $cpu = ($stats | Where-Object { $_.MetricId -eq 'cpu.usage.average' } | Measure-Object Value -Average).Average
    $mem = ($stats | Where-Object { $_.MetricId -eq 'mem.usage.average' } | Measure-Object Value -Average).Average
    if ($cpu -lt $CpuMaxPct -and $mem -lt $MemMaxPct) {
        [pscustomobject]@{
            VM        = $vm.Name
            NumCpu    = $vm.NumCpu
            MemoryGB  = $vm.MemoryGB
            AvgCpuPct = [math]::Round($cpu,1)
            AvgMemPct = [math]::Round($mem,1)
        }
    }
}
