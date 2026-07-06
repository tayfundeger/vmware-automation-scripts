<#
.SYNOPSIS
    Finds idle VMs based on low CPU and network activity.
.DESCRIPTION
    Averages CPU usage (%) and network usage (KBps) over the last N days and
    returns powered-on VMs below both thresholds - decommission candidates.
    Note: per-VM stat queries can take time on large inventories.
.PARAMETER Days
    Lookback window in days (default 7).
.PARAMETER CpuThresholdPct
    Max average CPU percent to be considered idle (default 5).
.PARAMETER NetThresholdKBps
    Max average network KBps to be considered idle (default 10).
.EXAMPLE
    PS> ./Get-IdleVMs.ps1 -Days 14
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 7, [double]$CpuThresholdPct = 5, [double]$NetThresholdKBps = 10)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$start = (Get-Date).AddDays(-$Days)
foreach ($vm in (Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' })) {
    $stats = Get-Stat -Entity $vm -Stat cpu.usage.average, net.usage.average -Start $start -ErrorAction SilentlyContinue
    if (-not $stats) { continue }
    $cpu = ($stats | Where-Object { $_.MetricId -eq 'cpu.usage.average' } | Measure-Object Value -Average).Average
    $net = ($stats | Where-Object { $_.MetricId -eq 'net.usage.average' } | Measure-Object Value -Average).Average
    if ($cpu -lt $CpuThresholdPct -and $net -lt $NetThresholdKBps) {
        [pscustomobject]@{
            VM         = $vm.Name
            AvgCpuPct  = [math]::Round($cpu,2)
            AvgNetKBps = [math]::Round($net,2)
            NumCpu     = $vm.NumCpu
            MemoryGB   = $vm.MemoryGB
            VMHost     = $vm.VMHost.Name
        }
    }
}
