<#
.SYNOPSIS
    Enables or disables an alarm definition.
.DESCRIPTION
    Turns a named alarm definition on or off. Supports -WhatIf.
.PARAMETER AlarmName
    Alarm definition name.
.PARAMETER Enabled
    $true to enable, $false to disable.
.EXAMPLE
    PS> ./Set-AlarmState.ps1 -AlarmName "Host connection and power state" -Enabled $false
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$AlarmName,
    [Parameter(Mandatory)][bool]$Enabled
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$alarm = Get-AlarmDefinition -Name $AlarmName -ErrorAction SilentlyContinue
if (-not $alarm) { Write-Warning "Alarm not found: $AlarmName"; return }

$state = if ($Enabled) { 'Enable' } else { 'Disable' }
if ($PSCmdlet.ShouldProcess($AlarmName, "$state alarm")) {
    Set-AlarmDefinition -AlarmDefinition $alarm -Enabled $Enabled -Confirm:$false
}
