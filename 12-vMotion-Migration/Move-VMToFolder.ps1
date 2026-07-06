<#
.SYNOPSIS
    Moves a VM to a different inventory folder.
.DESCRIPTION
    Changes the blue-folder (inventory) location of a VM without migrating it
    between hosts or datastores. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER Folder
    Target VM folder.
.EXAMPLE
    PS> ./Move-VMToFolder.ps1 -Name app01 -Folder Production
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Folder
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$fd = Get-Folder -Name $Folder -ErrorAction Stop

if ($PSCmdlet.ShouldProcess($Name, "Move to folder $Folder")) {
    Move-VM -VM $vm -InventoryLocation $fd
}
