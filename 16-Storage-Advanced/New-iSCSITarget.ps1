<#
.SYNOPSIS
    Adds an iSCSI target to a host's iSCSI HBA.
.DESCRIPTION
    Adds a dynamic (Send) or static iSCSI target to the host's iSCSI adapter.
    Run a rescan afterwards to discover LUNs. Supports -WhatIf.
.PARAMETER VMHost
    Host name.
.PARAMETER Address
    Target IP/hostname.
.PARAMETER Port
    Target port (default 3260).
.PARAMETER Type
    Send (dynamic discovery) or Static (default Send).
.EXAMPLE
    PS> ./New-iSCSITarget.ps1 -VMHost esxi01 -Address 10.0.0.20
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHost,
    [Parameter(Mandatory)][string]$Address,
    [int]$Port = 3260,
    [ValidateSet('Send','Static')][string]$Type = 'Send'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h = Get-VMHost -Name $VMHost -ErrorAction Stop
$hba = Get-VMHostHba -VMHost $h -Type IScsi -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $hba) { Write-Warning "$VMHost has no iSCSI HBA (is the software iSCSI adapter enabled?)."; return }

if ($PSCmdlet.ShouldProcess($VMHost, "Add $Type iSCSI target $Address`:$Port")) {
    New-IScsiHbaTarget -IScsiHba $hba -Address $Address -Port $Port -Type $Type
    Write-Host "Added target. Run Update-StorageAdapterRescan to discover LUNs."
}
