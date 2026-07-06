<#
.SYNOPSIS
    Removes a virtual disk from a VM.
.DESCRIPTION
    Detaches a named hard disk, optionally deleting the VMDK from disk. Supports
    -WhatIf. Use with care - deleting from disk is irreversible.
.PARAMETER Name
    VM name.
.PARAMETER DiskName
    Hard disk name (e.g. "Hard disk 2").
.PARAMETER DeleteFromDisk
    Also delete the underlying VMDK files.
.EXAMPLE
    PS> ./Remove-VMHardDisk.ps1 -Name db01 -DiskName "Hard disk 3" -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$DiskName,
    [switch]$DeleteFromDisk
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm   = Get-VM -Name $Name -ErrorAction Stop
$disk = Get-HardDisk -VM $vm | Where-Object { $_.Name -eq $DiskName }
if (-not $disk) { Write-Warning "Disk '$DiskName' not found on $Name."; return }

$action = if ($DeleteFromDisk) { 'Remove and DELETE from disk' } else { 'Detach (keep files)' }
if ($PSCmdlet.ShouldProcess("$Name / $DiskName", $action)) {
    Remove-HardDisk -HardDisk $disk -DeletePermanently:$DeleteFromDisk -Confirm:$false
    Write-Host "$DiskName removed from $Name ($action)."
}
