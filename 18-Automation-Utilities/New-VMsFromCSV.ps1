<#
.SYNOPSIS
    Bulk-creates VMs from a template using a CSV.
.DESCRIPTION
    Reads a CSV and deploys each VM from a template onto a host (or cluster),
    datastore and optional folder. Supports -WhatIf.
.PARAMETER CsvPath
    CSV path. Columns: Name, Template, Datastore, and either VMHost or Cluster.
    Optional: Folder.
.EXAMPLE
    PS> ./New-VMsFromCSV.ps1 -CsvPath C:\newvms.csv -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
    CSV example:
      Name,Template,Datastore,VMHost,Cluster,Folder
      web05,Tmpl-Ubuntu22,DS_FAST,esxi02,,Web
      db03,Tmpl-RHEL9,DS_TIER1,,PROD-CL,Databases
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$CsvPath)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not (Test-Path $CsvPath)) { Write-Warning "CSV not found: $CsvPath"; return }

foreach ($row in (Import-Csv -Path $CsvPath)) {
    $p = @{
        Name      = $row.Name
        Template  = Get-Template  -Name $row.Template  -ErrorAction Stop
        Datastore = Get-Datastore -Name $row.Datastore -ErrorAction Stop
        Confirm   = $false
    }
    if     ($row.VMHost)  { $p.VMHost       = Get-VMHost  -Name $row.VMHost  -ErrorAction Stop }
    elseif ($row.Cluster) { $p.ResourcePool = Get-Cluster -Name $row.Cluster -ErrorAction Stop }
    else   { Write-Warning "$($row.Name): no VMHost or Cluster specified, skipped."; continue }
    if ($row.Folder) { $p.Location = Get-Folder -Name $row.Folder -ErrorAction Stop }

    if ($PSCmdlet.ShouldProcess($row.Name, "Deploy from template $($row.Template)")) {
        New-VM @p
        Write-Host "Created $($row.Name)."
    }
}
