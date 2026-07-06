<#
.SYNOPSIS
    Storage vMotion a VM to another datastore.
.DESCRIPTION
    Relocates all of a VM's disks to a target datastore with Storage vMotion.
    Optionally change the disk format during the move. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER Datastore
    Target datastore.
.PARAMETER DiskFormat
    Optional target disk format: Thin, Thick or EagerZeroedThick.
.EXAMPLE
    PS> ./Move-VMDatastore.ps1 -Name app01 -Datastore DS_FAST -DiskFormat Thin
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Datastore,
    [ValidateSet('Thin','Thick','EagerZeroedThick')][string]$DiskFormat
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$ds = Get-Datastore -Name $Datastore -ErrorAction Stop
$params = @{ VM = $vm; Datastore = $ds }
if ($DiskFormat) { $params.DiskStorageFormat = $DiskFormat }

if ($PSCmdlet.ShouldProcess($Name, "Storage vMotion to $Datastore")) {
    Move-VM @params
}
