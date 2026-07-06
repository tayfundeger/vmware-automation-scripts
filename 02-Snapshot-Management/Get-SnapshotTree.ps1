<#
.SYNOPSIS
    Shows the snapshot hierarchy for a VM.
.DESCRIPTION
    Prints an indented tree of a VM's snapshots and marks the current one.
.PARAMETER Name
    VM name.
.EXAMPLE
    PS> ./Get-SnapshotTree.ps1 -Name app01
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Name
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm      = Get-VM -Name $Name -ErrorAction Stop
$current = (Get-Snapshot -VM $vm | Where-Object { $_.IsCurrent }).Name

function Show-Node($snap, $depth) {
    $marker = if ($snap.Name -eq $current) { ' <-- current' } else { '' }
    Write-Host ("{0}- {1} ({2:yyyy-MM-dd HH:mm}){3}" -f ('  ' * $depth), $snap.Name, $snap.Created, $marker)
    foreach ($child in ($snap.Children)) { Show-Node $child ($depth + 1) }
}

$roots = Get-Snapshot -VM $vm | Where-Object { -not $_.ParentSnapshot }
if (-not $roots) { Write-Host "$Name has no snapshots."; return }
Write-Host "Snapshot tree for $Name :" -ForegroundColor Cyan
foreach ($r in $roots) { Show-Node $r 1 }
