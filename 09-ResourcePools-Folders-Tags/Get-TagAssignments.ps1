<#
.SYNOPSIS
    Reports tag assignments across the inventory.
.DESCRIPTION
    Lists which tags (and their categories) are assigned to which objects.
.PARAMETER Category
    Optional tag category name filter.
.EXAMPLE
    PS> ./Get-TagAssignments.ps1
.EXAMPLE
    PS> ./Get-TagAssignments.ps1 -Category Environment
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Category)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$assignments = if ($Category) {
    Get-TagAssignment -Category $Category -ErrorAction SilentlyContinue
} else {
    Get-TagAssignment
}
if (-not $assignments) { Write-Host 'No tag assignments found.'; return }

$assignments | Select-Object `
    @{N='Entity';E={$_.Entity.Name}},
    @{N='Category';E={$_.Tag.Category.Name}},
    @{N='Tag';E={$_.Tag.Name}} |
    Sort-Object Category, Tag, Entity
