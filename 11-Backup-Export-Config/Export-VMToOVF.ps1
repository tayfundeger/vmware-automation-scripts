<#
.SYNOPSIS
    Exports a VM to OVF/OVA.
.DESCRIPTION
    Exports one or more VMs to the OVF (or OVA) format for archival or transfer.
    The VM should be powered off for a clean export. Supports -WhatIf.
.PARAMETER Name
    VM name(s) to export.
.PARAMETER Destination
    Destination folder.
.PARAMETER Format
    Ovf (folder of files) or Ova (single file). Default Ovf.
.EXAMPLE
    PS> ./Export-VMToOVF.ps1 -Name web01 -Destination C:\Export -Format Ova
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string[]]$Name,
    [Parameter(Mandatory)][string]$Destination,
    [ValidateSet('Ovf','Ova')][string]$Format = 'Ovf'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($vmName in $Name) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if (-not $vm) { Write-Warning "VM not found: $vmName"; continue }
    if ($vm.PowerState -eq 'PoweredOn') { Write-Warning "$vmName is powered on; export may be inconsistent." }
    if ($PSCmdlet.ShouldProcess($vmName, "Export to $Format at $Destination")) {
        Export-VApp -VM $vm -Destination $Destination -Format $Format -Force
    }
}
