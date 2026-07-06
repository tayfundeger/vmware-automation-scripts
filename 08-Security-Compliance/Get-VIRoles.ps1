<#
.SYNOPSIS
    Lists vCenter roles and their privilege counts.
.DESCRIPTION
    Enumerates all roles, showing whether each is a built-in (system) role and
    how many privileges it contains.
.EXAMPLE
    PS> ./Get-VIRoles.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VIRole | Select-Object Name,
    @{N='IsSystem';E={$_.IsSystem}},
    @{N='PrivilegeCount';E={$_.PrivilegeList.Count}} |
    Sort-Object Name
