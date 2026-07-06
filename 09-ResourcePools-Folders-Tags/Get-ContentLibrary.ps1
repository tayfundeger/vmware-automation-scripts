<#
.SYNOPSIS
    Lists content library items.
.DESCRIPTION
    Enumerates items across content libraries with their library name, type and
    creation date.
.EXAMPLE
    PS> ./Get-ContentLibrary.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$items = Get-ContentLibraryItem -ErrorAction SilentlyContinue
if (-not $items) { Write-Host 'No content library items found.'; return }

$items | Select-Object Name,
    @{N='Library';E={$_.ContentLibrary.Name}},
    @{N='Type';E={$_.ItemType}},
    @{N='Created';E={$_.Created}} |
    Sort-Object Library, Name
