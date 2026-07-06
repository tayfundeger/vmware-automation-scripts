<#
.SYNOPSIS
    Creates a tag category and tag if they do not exist.
.DESCRIPTION
    Ensures a tag category exists (creating it with the given cardinality and
    entity types), then creates the tag within it. Idempotent and supports
    -WhatIf.
.PARAMETER Category
    Tag category name.
.PARAMETER Tag
    Tag name to create in the category.
.PARAMETER Description
    Optional tag description.
.PARAMETER Cardinality
    Single or Multiple tags per object for the category (default Single).
.PARAMETER EntityType
    Object types the category applies to (default VirtualMachine).
.EXAMPLE
    PS> ./New-TagAndCategory.ps1 -Category Environment -Tag Production
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Category,
    [Parameter(Mandatory)][string]$Tag,
    [string]$Description = '',
    [ValidateSet('Single','Multiple')][string]$Cardinality = 'Single',
    [string[]]$EntityType = @('VirtualMachine')
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$cat = Get-TagCategory -Name $Category -ErrorAction SilentlyContinue
if (-not $cat) {
    if ($PSCmdlet.ShouldProcess($Category, 'Create tag category')) {
        $cat = New-TagCategory -Name $Category -Cardinality $Cardinality -EntityType $EntityType
    }
} else { Write-Host "Category '$Category' already exists." }

if ($cat) {
    $existing = Get-Tag -Category $cat -Name $Tag -ErrorAction SilentlyContinue
    if ($existing) { Write-Host "Tag '$Tag' already exists in '$Category'."; return }
    if ($PSCmdlet.ShouldProcess($Tag, "Create tag in category '$Category'")) {
        New-Tag -Name $Tag -Category $cat -Description $Description
    }
}
