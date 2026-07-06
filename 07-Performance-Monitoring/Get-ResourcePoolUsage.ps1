<#
.SYNOPSIS
    Reports CPU/memory usage and limits per resource pool.
.DESCRIPTION
    Lists each resource pool with current CPU/memory usage (QuickStats) alongside
    its CPU/memory reservation and limit settings.
.EXAMPLE
    PS> ./Get-ResourcePoolUsage.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-ResourcePool | Sort-Object Name | ForEach-Object {
    $qs = $_.ExtensionData.Summary.QuickStats
    [pscustomobject]@{
        ResourcePool = $_.Name
        CPUUsedMhz   = $qs.OverallCpuUsage
        MemUsedMB    = $qs.HostMemoryUsage
        CpuReservMhz = $_.CpuReservationMHz
        CpuLimitMhz  = $_.CpuLimitMHz
        MemReservMB  = $_.MemReservationMB
        MemLimitMB   = $_.MemLimitMB
    }
}
