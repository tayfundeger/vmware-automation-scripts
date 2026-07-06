<#
.SYNOPSIS
    Removes all snapshots for a specific VM.
.DESCRIPTION
    Deletes every snapshot on the target VM (a full consolidation of the tree).
    Supports -WhatIf.
.PARAMETER Name
    VM name.
.EXAMPLE
    PS> ./Remove-AllSnapshotsForVM.ps1 -Name db01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm    = Get-VM -Name $Name -ErrorAction Stop
$snaps = Get-Snapshot -VM $vm
if (-not $snaps) { Write-Host "$Name has no snapshots."; return }

if ($PSCmdlet.ShouldProcess($Name, "Remove ALL ($($snaps.Count)) snapshots")) {
    $snaps | Remove-Snapshot -Confirm:$false
    Write-Host "Removed $($snaps.Count) snapshot(s) from $Name."
}
