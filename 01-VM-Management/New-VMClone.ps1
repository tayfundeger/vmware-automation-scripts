<#
.SYNOPSIS
    Clones an existing virtual machine.
.DESCRIPTION
    Creates a full clone of a source VM onto a target host and datastore.
    The source VM should be powered off (or be a template) for a clean clone.
.PARAMETER SourceVM
    Name of the VM to clone.
.PARAMETER NewName
    Name for the cloned VM.
.PARAMETER VMHost
    Target ESXi host.
.PARAMETER Datastore
    Target datastore.
.EXAMPLE
    PS> ./New-VMClone.ps1 -SourceVM app01 -NewName app01-copy -VMHost esxi02 -Datastore DS02
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$SourceVM,
    [Parameter(Mandatory)][string]$NewName,
    [Parameter(Mandatory)][string]$VMHost,
    [Parameter(Mandatory)][string]$Datastore
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$src = Get-VM -Name $SourceVM -ErrorAction Stop
if ($src.PowerState -eq 'PoweredOn') {
    Write-Warning "$SourceVM is powered on. For a consistent clone power it off first or clone from a snapshot."
}

if ($PSCmdlet.ShouldProcess($NewName, "Clone from '$SourceVM'")) {
    New-VM -Name $NewName -VM $src `
           -VMHost    (Get-VMHost   -Name $VMHost    -ErrorAction Stop) `
           -Datastore (Get-Datastore -Name $Datastore -ErrorAction Stop)
}
