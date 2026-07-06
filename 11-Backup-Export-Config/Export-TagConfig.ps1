<#
.SYNOPSIS
    Exports tag categories, tags and assignments to CSV.
.DESCRIPTION
    Writes two CSVs into -OutputFolder: tag definitions (category, cardinality,
    tag, description) and tag assignments (entity, category, tag). Useful as a
    backup before tag restructuring.
.PARAMETER OutputFolder
    Destination folder (default .\TagConfig).
.EXAMPLE
    PS> ./Export-TagConfig.ps1 -OutputFolder C:\Backup\Tags
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$OutputFolder = '.\TagConfig')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

$defs = Get-Tag | Sort-Object { $_.Category.Name }, Name | ForEach-Object {
    [pscustomobject]@{ Category=$_.Category.Name; Cardinality=$_.Category.Cardinality; Tag=$_.Name; Description=$_.Description }
}
$defs | Export-Csv -Path (Join-Path $OutputFolder 'tag-definitions.csv') -NoTypeInformation -Encoding UTF8

$asg = Get-TagAssignment | ForEach-Object {
    [pscustomobject]@{ Entity=$_.Entity.Name; Category=$_.Tag.Category.Name; Tag=$_.Tag.Name }
}
$asg | Export-Csv -Path (Join-Path $OutputFolder 'tag-assignments.csv') -NoTypeInformation -Encoding UTF8

Write-Host "Exported $($defs.Count) tags and $($asg.Count) assignments to $OutputFolder"
