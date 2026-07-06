<#
.SYNOPSIS
    Exports custom vCenter roles and their privileges to JSON.
.DESCRIPTION
    Captures each non-system (custom) role with its full privilege list, so roles
    can be documented or recreated on another vCenter with New-VIRole.
.PARAMETER Path
    JSON output path (default .\CustomRoles.json).
.EXAMPLE
    PS> ./Export-RoleConfig.ps1 -Path C:\Backup\roles.json
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path = '.\CustomRoles.json')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$roles = Get-VIRole | Where-Object { -not $_.IsSystem } | ForEach-Object {
    [ordered]@{ Name = $_.Name; Privileges = @($_.PrivilegeList) }
}
if (-not $roles) { Write-Host 'No custom roles found.'; return }
$roles | ConvertTo-Json -Depth 4 | Out-File -FilePath $Path -Encoding UTF8
Write-Host "Exported $($roles.Count) custom role(s) to $Path"
