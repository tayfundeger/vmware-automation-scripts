<#
.SYNOPSIS
    Safely removes one or more VMs with guard rails.
.DESCRIPTION
    Removes VMs from inventory or permanently from disk. Refuses to touch a
    powered-on VM and requires confirmation (SupportsShouldProcess). Use
    -DeleteFromDisk to delete the VM files as well.
.PARAMETER Name
    One or more VM names to remove.
.PARAMETER DeleteFromDisk
    Delete the VM permanently, including its files on the datastore.
.EXAMPLE
    PS> ./Remove-VMSafely.ps1 -Name oldvm01 -WhatIf
.EXAMPLE
    PS> ./Remove-VMSafely.ps1 -Name oldvm01,oldvm02 -DeleteFromDisk
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string[]]$Name,
    [switch]$DeleteFromDisk
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($vmName in $Name) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if (-not $vm)                        { Write-Warning "VM not found: $vmName"; continue }
    if ($vm.PowerState -eq 'PoweredOn')  { Write-Warning "$vmName is powered on. Shut it down first."; continue }

    $action = if ($DeleteFromDisk) { 'Delete permanently (files on disk)' } else { 'Remove from inventory' }
    if ($PSCmdlet.ShouldProcess($vmName, $action)) {
        if ($DeleteFromDisk) { Remove-VM -VM $vm -DeletePermanently -Confirm:$false }
        else                 { Remove-VM -VM $vm -Confirm:$false }
        Write-Host "$vmName removed ($action)."
    }
}
