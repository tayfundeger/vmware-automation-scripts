<#
.SYNOPSIS
    Storage vMotions all VMs off a datastore.
.DESCRIPTION
    Moves every VM that has files on the source datastore to a target datastore,
    e.g. to empty a LUN before decommissioning. A VM with disks spread across
    datastores will have all disks relocated to the target. Supports -WhatIf.
.PARAMETER Source
    Datastore to evacuate.
.PARAMETER Target
    Destination datastore.
.EXAMPLE
    PS> ./Invoke-DatastoreEvacuation.ps1 -Source DS_OLD -Target DS_NEW -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Source,
    [Parameter(Mandatory)][string]$Target
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$src = Get-Datastore -Name $Source -ErrorAction Stop
$dst = Get-Datastore -Name $Target -ErrorAction Stop
$vms = Get-VM -Datastore $src
if (-not $vms) { Write-Host "$Source has no VMs."; return }

foreach ($vm in $vms) {
    if ($PSCmdlet.ShouldProcess($vm.Name, "Storage vMotion from $Source to $Target")) {
        Move-VM -VM $vm -Datastore $dst | Out-Null
        Write-Host "Moved $($vm.Name) -> $Target"
    }
}
