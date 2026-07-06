<#
.SYNOPSIS
    Bulk-migrates VMs based on a CSV file.
.DESCRIPTION
    Reads a CSV with columns Name, TargetHost and/or TargetDatastore and migrates
    each VM accordingly (compute vMotion, storage vMotion, or both in one move).
    Supports -WhatIf.
.PARAMETER CsvPath
    Path to the CSV file. Required columns: Name. Optional: TargetHost, TargetDatastore.
.EXAMPLE
    PS> ./Move-VMsBulkByCSV.ps1 -CsvPath C:\migrate.csv -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
    CSV example:
      Name,TargetHost,TargetDatastore
      web01,esxi05,DS_FAST
      db01,,DS_TIER2
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$CsvPath)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not (Test-Path $CsvPath)) { Write-Warning "CSV not found: $CsvPath"; return }

foreach ($row in (Import-Csv -Path $CsvPath)) {
    $vm = Get-VM -Name $row.Name -ErrorAction SilentlyContinue
    if (-not $vm) { Write-Warning "VM not found: $($row.Name)"; continue }

    $params = @{ VM = $vm }
    $desc = @()
    if ($row.TargetHost)      { $params.Destination = Get-VMHost   -Name $row.TargetHost      -ErrorAction Stop; $desc += "host $($row.TargetHost)" }
    if ($row.TargetDatastore) { $params.Datastore   = Get-Datastore -Name $row.TargetDatastore -ErrorAction Stop; $desc += "datastore $($row.TargetDatastore)" }
    if ($params.Count -le 1)  { Write-Warning "$($row.Name): no target specified, skipped."; continue }

    if ($PSCmdlet.ShouldProcess($row.Name, "Migrate to $($desc -join ' + ')")) {
        Move-VM @params | Out-Null
        Write-Host "Migrated $($row.Name) -> $($desc -join ' + ')"
    }
}
