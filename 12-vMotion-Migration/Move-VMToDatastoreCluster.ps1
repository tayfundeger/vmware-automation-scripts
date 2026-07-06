<#
.SYNOPSIS
    Storage vMotion a VM into a datastore cluster.
.DESCRIPTION
    Relocates a VM to a datastore cluster, letting SDRS choose the best member
    datastore. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER DatastoreCluster
    Target datastore cluster.
.EXAMPLE
    PS> ./Move-VMToDatastoreCluster.ps1 -Name app01 -DatastoreCluster DSC-PROD
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$DatastoreCluster
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm  = Get-VM -Name $Name -ErrorAction Stop
$dsc = Get-DatastoreCluster -Name $DatastoreCluster -ErrorAction Stop

if ($PSCmdlet.ShouldProcess($Name, "Storage vMotion to datastore cluster $DatastoreCluster")) {
    Move-VM -VM $vm -Datastore $dsc
}
