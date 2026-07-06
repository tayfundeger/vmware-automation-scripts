<#
.SYNOPSIS
    Bulk-creates snapshots from a CSV list.
.DESCRIPTION
    Snapshots each VM named in a CSV, with optional per-row snapshot name, memory
    and quiesce flags. Supports -WhatIf.
.PARAMETER CsvPath
    CSV path. Columns: Name. Optional: SnapshotName, Memory (true/false),
    Quiesce (true/false).
.PARAMETER Description
    Default snapshot description.
.EXAMPLE
    PS> ./Invoke-SnapshotFromCSV.ps1 -CsvPath C:\snaps.csv -Description "Pre-patch"
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
    CSV example:
      Name,SnapshotName,Memory,Quiesce
      db01,pre-patch,true,false
      web01,,false,true
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$CsvPath,
    [string]$Description = 'Created by Invoke-SnapshotFromCSV'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not (Test-Path $CsvPath)) { Write-Warning "CSV not found: $CsvPath"; return }

foreach ($row in (Import-Csv -Path $CsvPath)) {
    $vm = Get-VM -Name $row.Name -ErrorAction SilentlyContinue
    if (-not $vm) { Write-Warning "VM not found: $($row.Name)"; continue }

    $snapName = if ($row.SnapshotName) { $row.SnapshotName } else { "snap-$(Get-Date -Format 'yyyyMMdd-HHmm')" }
    $mem = ($row.Memory  -eq 'true')
    $qui = ($row.Quiesce -eq 'true')

    if ($PSCmdlet.ShouldProcess($row.Name, "Create snapshot '$snapName' (Memory=$mem, Quiesce=$qui)")) {
        New-Snapshot -VM $vm -Name $snapName -Description $Description -Memory:$mem -Quiesce:$qui | Out-Null
        Write-Host "Snapshot created for $($row.Name): $snapName"
    }
}
