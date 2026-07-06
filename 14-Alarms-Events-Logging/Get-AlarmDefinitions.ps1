<#
.SYNOPSIS
    Lists all alarm definitions.
.DESCRIPTION
    Reports every alarm definition with its enabled state and description.
.PARAMETER DisabledOnly
    Only return alarms that are currently disabled.
.EXAMPLE
    PS> ./Get-AlarmDefinitions.ps1 -DisabledOnly
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([switch]$DisabledOnly)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$defs = Get-AlarmDefinition
if ($DisabledOnly) { $defs = $defs | Where-Object { -not $_.Enabled } }
$defs | Select-Object Name, Enabled, @{N='Description';E={$_.Description}} | Sort-Object Name
