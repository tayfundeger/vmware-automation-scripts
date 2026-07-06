<#
.SYNOPSIS
    Identifies who created snapshots within a lookback window.
.DESCRIPTION
    Queries vCenter task events for snapshot-creation tasks and reports the
    user, time and VM. Only covers events still retained by vCenter.
.PARAMETER Days
    How many days back to search (default 30).
.EXAMPLE
    PS> ./Get-SnapshotCreator.ps1 -Days 60
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [int]$Days = 30
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object { $_ -is [VMware.Vim.TaskEvent] -and $_.Info.DescriptionId -eq 'VirtualMachine.createSnapshot' } |
    Select-Object CreatedTime, UserName, @{N='VM';E={$_.Vm.Name}} |
    Sort-Object CreatedTime -Descending
