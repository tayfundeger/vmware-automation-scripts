<#
.SYNOPSIS
    Reports which roles are actually in use.
.DESCRIPTION
    Cross-references defined roles against assigned permissions and reports, per
    role, how many permission assignments reference it (0 = unused).
.EXAMPLE
    PS> ./Get-VIRoleUsage.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$perms = Get-VIPermission
Get-VIRole | Sort-Object Name | ForEach-Object {
    $roleName = $_.Name
    [pscustomobject]@{
        Role        = $roleName
        IsSystem    = $_.IsSystem
        Privileges  = $_.PrivilegeList.Count
        Assignments = ($perms | Where-Object { $_.Role -eq $roleName } | Measure-Object).Count
    }
}
