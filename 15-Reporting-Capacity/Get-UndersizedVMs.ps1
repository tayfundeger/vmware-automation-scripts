<#
.SYNOPSIS
    Finds undersized VMs (high utilization vs. allocation).
.DESCRIPTION
    Averages CPU and memory usage (%) over the last N days and returns powered-on
    VMs above the thresholds - candidates to grow.
.PARAMETER Days
    Lookback window in days (default 7).
.PARAMETER CpuMinPct
    CPU average above this is "undersized" (default 80).
.PARAMETER MemMinPct
    Memory average above this is "undersized" (default 85).
.EXAMPLE
    PS> ./Get-UndersizedVMs.ps1 -Days 30
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 7, [double]$CpuMinPct = 80, [double]$MemMinPct = 85)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$start = (Get-Date).AddDays(-$Days)
foreach ($vm in (Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' })) {
    $stats = Get-Stat -Entity $vm -Stat cpu.usage.average, mem.usage.average -Start $start -ErrorAction SilentlyContinue
    if (-not $stats) { continue }
    $cpu = ($stats | Where-Object { $_.MetricId -eq 'cpu.usage.average' } | Measure-Object Value -Average).Average
    $mem = ($stats | Where-Object { $_.MetricId -eq 'mem.usage.average' } | Measure-Object Value -Average).Average
    if ($cpu -gt $CpuMinPct -or $mem -gt $MemMinPct) {
        [pscustomobject]@{
            VM        = $vm.Name
            NumCpu    = $vm.NumCpu
            MemoryGB  = $vm.MemoryGB
            AvgCpuPct = [math]::Round($cpu,1)
            AvgMemPct = [math]::Round($mem,1)
        }
    }
}
