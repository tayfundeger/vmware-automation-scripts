<#
.SYNOPSIS
    Reports recent vMotion / migration history.
.DESCRIPTION
    Retrieves migration events (manual vMotion, DRS-initiated, and relocations)
    from the last N days, showing which VM moved, when, by whom and between
    which hosts.
.PARAMETER Days
    Lookback window in days (default 7).
.EXAMPLE
    PS> ./Get-VMotionHistory.ps1 -Days 14
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Days = 7)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VIEvent -Start (Get-Date).AddDays(-$Days) -MaxSamples 100000 |
    Where-Object {
        $_ -is [VMware.Vim.VmMigratedEvent] -or
        $_ -is [VMware.Vim.DrsVmMigratedEvent] -or
        $_ -is [VMware.Vim.VmRelocatedEvent]
    } |
    Select-Object CreatedTime, UserName,
        @{N='VM';E={$_.Vm.Name}},
        @{N='SourceHost';E={$_.SourceHost.Name}},
        @{N='DestHost';E={$_.Host.Name}},
        @{N='Type';E={$_.GetType().Name}} |
    Sort-Object CreatedTime -Descending
