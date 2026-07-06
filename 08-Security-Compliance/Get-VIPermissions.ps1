<#
.SYNOPSIS
    Reports all assigned vCenter permissions.
.DESCRIPTION
    Lists every permission with the principal, role, entity it applies to,
    whether it propagates and whether the principal is a group.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-VIPermissions.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VIPermission | Select-Object `
    @{N='Principal';E={$_.Principal}},
    @{N='Role';E={$_.Role}},
    @{N='Entity';E={$_.Entity.Name}},
    @{N='EntityType';E={$_.EntityId.Split('-')[0]}},
    @{N='Propagate';E={$_.Propagate}},
    @{N='IsGroup';E={$_.IsGroup}} |
    Sort-Object Principal

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
