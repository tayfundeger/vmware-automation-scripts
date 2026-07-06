<#
.SYNOPSIS
    Reports VM reconfiguration events.
.DESCRIPTION
    Retrieves VM "reconfigured" events over the last N days so you can see who
    changed VM settings and when.
.PARAMETER Days
    Lookback window in days (default 7).
.PARAMETER VMName
    Optional VM name filter.
.EXAMPLE
    PS> ./Get-ConfigChangeEvents.ps1 -Days 14 -VMName db01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 7, [string]$VMName)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$events = Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object { $_ -is [VMware.Vim.VmReconfiguredEvent] }
if ($VMName) { $events = $events | Where-Object { $_.Vm.Name -eq $VMName } }

$events | Select-Object CreatedTime, UserName,
    @{N='VM';E={$_.Vm.Name}},
    @{N='Message';E={$_.FullFormattedMessage}} |
    Sort-Object CreatedTime -Descending
