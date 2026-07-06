<#
.SYNOPSIS
    Reports resource pool configuration and membership.
.DESCRIPTION
    Lists each resource pool with CPU/memory shares, reservations, limits and the
    number of VMs it contains.
.EXAMPLE
    PS> ./Get-ResourcePools.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-ResourcePool | Sort-Object Name | Select-Object Name,
    @{N='CpuShares';E={$_.CpuSharesLevel}},
    @{N='CpuReservMhz';E={$_.CpuReservationMHz}},
    @{N='CpuLimitMhz';E={$_.CpuLimitMHz}},
    @{N='MemShares';E={$_.MemSharesLevel}},
    @{N='MemReservMB';E={$_.MemReservationMB}},
    @{N='MemLimitMB';E={$_.MemLimitMB}},
    @{N='VMs';E={(Get-VM -Location $_).Count}}
