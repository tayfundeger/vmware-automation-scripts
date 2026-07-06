<#
.SYNOPSIS
    Creates a VMFS datastore on a LUN.
.DESCRIPTION
    Formats a presented LUN (by canonical name, e.g. naa.xxxx) as a new VMFS
    datastore on the given host. Find the canonical name with Get-ScsiDeviceInfo.
    Supports -WhatIf.
.PARAMETER Name
    Datastore name.
.PARAMETER CanonicalName
    LUN canonical name (e.g. naa.60000...).
.PARAMETER VMHost
    Host that sees the LUN.
.EXAMPLE
    PS> ./New-VMFSDatastore.ps1 -Name DS_NEW -CanonicalName naa.6001405abc -VMHost esxi01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$CanonicalName,
    [Parameter(Mandatory)][string]$VMHost
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h = Get-VMHost -Name $VMHost -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($VMHost, "Create VMFS datastore $Name on $CanonicalName")) {
    New-Datastore -VMHost $h -Vmfs -Name $Name -Path $CanonicalName
}
