<#
.SYNOPSIS
    Lists principals with Administrator role assignments.
.DESCRIPTION
    Reports every permission using the built-in Administrator ('Admin') role,
    highlighting who has full control and on which objects.
.EXAMPLE
    PS> ./Get-AdminUsers.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VIPermission | Where-Object { $_.Role -match 'Admin' } | Select-Object `
    @{N='Principal';E={$_.Principal}},
    @{N='Role';E={$_.Role}},
    @{N='Entity';E={$_.Entity.Name}},
    @{N='Propagate';E={$_.Propagate}},
    @{N='IsGroup';E={$_.IsGroup}} |
    Sort-Object Principal
