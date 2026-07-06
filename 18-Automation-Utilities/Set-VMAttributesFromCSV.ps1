<#
.SYNOPSIS
    Bulk-sets VM notes and custom attributes from a CSV.
.DESCRIPTION
    Reads a CSV (one row per VM+attribute) and applies each value. Use the
    special attribute name "Notes" to set the VM notes field; any other name is
    treated as an existing custom attribute. Supports -WhatIf.
.PARAMETER CsvPath
    CSV path. Columns: Name, AttributeName, Value.
.EXAMPLE
    PS> ./Set-VMAttributesFromCSV.ps1 -CsvPath C:\vmattr.csv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
    CSV example:
      Name,AttributeName,Value
      web01,Owner,teamA
      web01,Notes,Front-end web server
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$CsvPath)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not (Test-Path $CsvPath)) { Write-Warning "CSV not found: $CsvPath"; return }

foreach ($row in (Import-Csv -Path $CsvPath)) {
    $vm = Get-VM -Name $row.Name -ErrorAction SilentlyContinue
    if (-not $vm) { Write-Warning "VM not found: $($row.Name)"; continue }

    if ($row.AttributeName -eq 'Notes') {
        if ($PSCmdlet.ShouldProcess($row.Name, "Set Notes")) {
            Set-VM -VM $vm -Notes $row.Value -Confirm:$false | Out-Null
        }
    } else {
        $attr = Get-CustomAttribute -Name $row.AttributeName -ErrorAction SilentlyContinue
        if (-not $attr) { Write-Warning "Custom attribute not found: $($row.AttributeName)"; continue }
        if ($PSCmdlet.ShouldProcess($row.Name, "Set $($row.AttributeName)=$($row.Value)")) {
            Set-Annotation -Entity $vm -CustomAttribute $attr -Value $row.Value | Out-Null
        }
    }
}
