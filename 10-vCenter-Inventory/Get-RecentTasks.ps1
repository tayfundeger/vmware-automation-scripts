<#
.SYNOPSIS
    Lists recent vCenter tasks.
.DESCRIPTION
    Reports recent tasks with their target, state, initiating user and timing.
    Optionally filter to only failed tasks.
.PARAMETER FailedOnly
    Only return tasks that ended in error.
.EXAMPLE
    PS> ./Get-RecentTasks.ps1 -FailedOnly
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([switch]$FailedOnly)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$tasks = Get-Task
if ($FailedOnly) { $tasks = $tasks | Where-Object { $_.State -eq 'Error' } }

$tasks | Select-Object `
    @{N='Task';E={$_.Name}},
    @{N='Target';E={$_.ExtensionData.Info.EntityName}},
    State,
    @{N='StartTime';E={$_.StartTime}},
    @{N='FinishTime';E={$_.FinishTime}},
    @{N='User';E={$_.ExtensionData.Info.Reason.UserName}} |
    Sort-Object StartTime -Descending
