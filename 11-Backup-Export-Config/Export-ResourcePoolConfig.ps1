<#
.SYNOPSIS
    Exports resource pool configuration to CSV.
.DESCRIPTION
    Captures each resource pool's parent, CPU/memory shares, reservations, limits
    and expandable-reservation flags for documentation or re-creation.
.PARAMETER Path
    CSV output path (default .\ResourcePools.csv).
.EXAMPLE
    PS> ./Export-ResourcePoolConfig.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path = '.\ResourcePools.csv')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$rows = Get-ResourcePool | Where-Object { $_.Name -ne 'Resources' } | Sort-Object Name | ForEach-Object {
    $e = $_.ExtensionData.Config
    [pscustomobject]@{
        ResourcePool     = $_.Name
        Parent           = $_.Parent.Name
        CpuShares        = $_.CpuSharesLevel
        CpuReservationMHz= $_.CpuReservationMHz
        CpuLimitMHz      = $_.CpuLimitMHz
        CpuExpandable    = $e.CpuAllocation.ExpandableReservation
        MemShares        = $_.MemSharesLevel
        MemReservationMB = $_.MemReservationMB
        MemLimitMB       = $_.MemLimitMB
        MemExpandable    = $e.MemoryAllocation.ExpandableReservation
    }
}
if (-not $rows) { Write-Host 'No custom resource pools found.'; return }
$rows | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($rows.Count) resource pools to $Path"
