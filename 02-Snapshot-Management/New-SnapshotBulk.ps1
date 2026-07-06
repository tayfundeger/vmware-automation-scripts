<#
.SYNOPSIS
    Creates a snapshot on multiple VMs (e.g. pre-patching).
.DESCRIPTION
    Takes a named snapshot across a set of VMs selected by name or cluster.
    Optionally quiesce or include memory.
.PARAMETER Name
    VM names to snapshot.
.PARAMETER Cluster
    Snapshot all VMs in this cluster.
.PARAMETER SnapshotName
    Name for the snapshot (default: "Pre-Change <date>").
.PARAMETER Quiesce
    Quiesce the guest file system (requires Tools).
.PARAMETER Memory
    Include VM memory state.
.EXAMPLE
    PS> ./New-SnapshotBulk.ps1 -Cluster PROD-CL -SnapshotName "Pre-Patch-Aug"
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$Name,
    [string]$Cluster,
    [string]$SnapshotName = ("Pre-Change {0:yyyy-MM-dd}" -f (Get-Date)),
    [switch]$Quiesce,
    [switch]$Memory
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if     ($Name)    { $vms = Get-VM -Name $Name }
elseif ($Cluster) { $vms = Get-Cluster -Name $Cluster | Get-VM }
else              { Write-Warning 'Specify -Name or -Cluster.'; return }

foreach ($vm in $vms) {
    if ($PSCmdlet.ShouldProcess($vm.Name, "New snapshot '$SnapshotName'")) {
        New-Snapshot -VM $vm -Name $SnapshotName -Quiesce:$Quiesce -Memory:$Memory -Confirm:$false |
            Select-Object @{N='VM';E={$vm.Name}}, Name, Created
    }
}
