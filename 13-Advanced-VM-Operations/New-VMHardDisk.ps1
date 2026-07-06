<#
.SYNOPSIS
    Adds a virtual disk to a VM.
.DESCRIPTION
    Creates a new hard disk of the given size and format, optionally on a specific
    datastore. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER CapacityGB
    New disk size in GB.
.PARAMETER Format
    Thin, Thick or EagerZeroedThick (default Thin).
.PARAMETER Datastore
    Optional target datastore.
.EXAMPLE
    PS> ./New-VMHardDisk.ps1 -Name db01 -CapacityGB 100 -Format Thin
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][decimal]$CapacityGB,
    [ValidateSet('Thin','Thick','EagerZeroedThick')][string]$Format = 'Thin',
    [string]$Datastore
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$p  = @{ VM = $vm; CapacityGB = $CapacityGB; StorageFormat = $Format; Confirm = $false }
if ($Datastore) { $p.Datastore = Get-Datastore -Name $Datastore -ErrorAction Stop }

if ($PSCmdlet.ShouldProcess($Name, "Add ${CapacityGB}GB $Format disk")) {
    New-HardDisk @p
}
