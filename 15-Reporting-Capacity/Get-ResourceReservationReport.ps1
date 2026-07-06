<#
.SYNOPSIS
    Reports VMs with CPU or memory reservations/limits set.
.DESCRIPTION
    Lists every VM that has a non-default reservation or limit - reservations can
    trip up admission control and DRS, so this highlights them.
.EXAMPLE
    PS> ./Get-ResourceReservationReport.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | Get-VMResourceConfiguration |
    Where-Object {
        $_.CpuReservationMhz -gt 0 -or $_.MemReservationMB -gt 0 -or
        $_.CpuLimitMhz -ne -1 -or $_.MemLimitMB -ne -1
    } |
    Select-Object @{N='VM';E={$_.VM.Name}},
        CpuReservationMhz, CpuLimitMhz, MemReservationMB, MemLimitMB,
        CpuSharesLevel, MemSharesLevel |
    Sort-Object VM
