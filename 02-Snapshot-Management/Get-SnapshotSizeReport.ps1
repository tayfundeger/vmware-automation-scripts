<#
.SYNOPSIS
    Reports total snapshot disk consumption per VM.
.DESCRIPTION
    Aggregates snapshot sizes per VM and prints the grand total, helping reclaim
    datastore capacity tied up in snapshots.
.EXAMPLE
    PS> ./Get-SnapshotSizeReport.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$snaps = Get-VM | Get-Snapshot
if (-not $snaps) { Write-Host 'No snapshots found.'; return }

$byVM = $snaps | Group-Object { $_.VM.Name } | ForEach-Object {
    [pscustomobject]@{
        VM            = $_.Name
        SnapshotCount = $_.Count
        TotalSizeGB   = [math]::Round(($_.Group | Measure-Object SizeGB -Sum).Sum, 2)
    }
} | Sort-Object TotalSizeGB -Descending

$byVM
Write-Host ("`nGrand total: {0} GB across {1} snapshots." -f `
    [math]::Round(($snaps | Measure-Object SizeGB -Sum).Sum,2), $snaps.Count) -ForegroundColor Cyan
