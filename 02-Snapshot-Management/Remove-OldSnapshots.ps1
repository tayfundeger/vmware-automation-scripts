<#
.SYNOPSIS
    Removes snapshots older than a threshold.
.DESCRIPTION
    Deletes snapshots older than -Days. Supports -WhatIf; always preview first.
.PARAMETER Days
    Age threshold in days (default 7).
.EXAMPLE
    PS> ./Remove-OldSnapshots.ps1 -Days 30 -WhatIf
.EXAMPLE
    PS> ./Remove-OldSnapshots.ps1 -Days 30
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [int]$Days = 7
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$cutoff = (Get-Date).AddDays(-$Days)
$snaps  = Get-VM | Get-Snapshot | Where-Object { $_.Created -lt $cutoff }

if (-not $snaps) { Write-Host "No snapshots older than $Days days."; return }

foreach ($snap in $snaps) {
    $label = "$($snap.VM.Name) / $($snap.Name) [$([math]::Round($snap.SizeGB,2)) GB]"
    if ($PSCmdlet.ShouldProcess($label, 'Remove snapshot')) {
        Remove-Snapshot -Snapshot $snap -Confirm:$false
        Write-Host "Removed: $label"
    }
}
