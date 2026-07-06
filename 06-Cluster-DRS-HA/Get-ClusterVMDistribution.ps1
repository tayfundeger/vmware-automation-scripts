<#
.SYNOPSIS
    Shows how VMs are distributed across hosts in a cluster.
.DESCRIPTION
    For each cluster, reports the running VM count and CPU/memory load per host
    to reveal balance (or imbalance) across the cluster.
.PARAMETER Cluster
    Optional cluster name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-ClusterVMDistribution.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Cluster = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($c in (Get-Cluster -Name $Cluster | Sort-Object Name)) {
    Get-VMHost -Location $c | Sort-Object Name | ForEach-Object {
        $h  = $_
        $vm = Get-VM -Location $h
        [pscustomobject]@{
            Cluster   = $c.Name
            VMHost    = $h.Name
            RunningVMs= ($vm | Where-Object { $_.PowerState -eq 'PoweredOn' }).Count
            TotalVMs  = $vm.Count
            CPUPct    = if ($h.CpuTotalMhz) { [math]::Round(($h.CpuUsageMhz/$h.CpuTotalMhz)*100,1) } else { 0 }
            MemPct    = if ($h.MemoryTotalGB){ [math]::Round(($h.MemoryUsageGB/$h.MemoryTotalGB)*100,1) } else { 0 }
        }
    }
}
