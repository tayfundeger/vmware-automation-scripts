<#
.SYNOPSIS
    Removes a network adapter from a VM.
.DESCRIPTION
    Deletes a named NIC from the VM. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER AdapterName
    NIC name (e.g. "Network adapter 2").
.EXAMPLE
    PS> ./Remove-VMNetworkAdapter.ps1 -Name app01 -AdapterName "Network adapter 2"
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$AdapterName
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$na = Get-NetworkAdapter -VM $vm | Where-Object { $_.Name -eq $AdapterName }
if (-not $na) { Write-Warning "Adapter '$AdapterName' not found on $Name."; return }

if ($PSCmdlet.ShouldProcess("$Name / $AdapterName", 'Remove network adapter')) {
    Remove-NetworkAdapter -NetworkAdapter $na -Confirm:$false
    Write-Host "$AdapterName removed from $Name."
}
