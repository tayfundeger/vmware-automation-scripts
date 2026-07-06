<#
.SYNOPSIS
    Reports VM power on/off/suspend events.
.DESCRIPTION
    Retrieves power-state change events for VMs over the last N days, optionally
    filtered to a single VM.
.PARAMETER Days
    Lookback window in days (default 1).
.PARAMETER VMName
    Optional VM name filter.
.EXAMPLE
    PS> ./Get-VMPowerEvents.ps1 -Days 3 -VMName app01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 1, [string]$VMName)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$events = Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object {
        $_ -is [VMware.Vim.VmPoweredOnEvent]  -or
        $_ -is [VMware.Vim.VmPoweredOffEvent] -or
        $_ -is [VMware.Vim.VmSuspendedEvent]
    }
if ($VMName) { $events = $events | Where-Object { $_.Vm.Name -eq $VMName } }

$events | Select-Object CreatedTime, UserName,
    @{N='VM';E={$_.Vm.Name}},
    @{N='Event';E={$_.GetType().Name -replace 'Event$',''}} |
    Sort-Object CreatedTime -Descending
