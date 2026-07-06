<#
.SYNOPSIS
    Reports which alarms have actions configured.
.DESCRIPTION
    For each alarm definition, lists the configured action types (email, SNMP,
    run-script) so you can see which alarms actually notify.
.PARAMETER WithActionsOnly
    Only return alarms that have at least one action configured.
.EXAMPLE
    PS> ./Get-AlarmActionReport.ps1 -WithActionsOnly
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([switch]$WithActionsOnly)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$rows = Get-AlarmDefinition | ForEach-Object {
    $types = @()
    $act = $_.ExtensionData.Info.Action
    if ($act -and $act.Action) {
        foreach ($a in $act.Action) {
            if ($a.Action) { $types += ($a.Action.GetType().Name -replace 'Action$','') }
        }
    }
    [pscustomobject]@{
        Alarm   = $_.Name
        Enabled = $_.Enabled
        Actions = if ($types) { ($types | Select-Object -Unique) -join ', ' } else { '(none)' }
    }
}
if ($WithActionsOnly) { $rows = $rows | Where-Object { $_.Actions -ne '(none)' } }
$rows | Sort-Object Alarm
