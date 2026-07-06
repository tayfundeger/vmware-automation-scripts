<#
.SYNOPSIS
    Grows a VM's virtual disk.
.DESCRIPTION
    Increases a hard disk to a larger capacity (disks can only grow, never
    shrink). The guest OS partition must be extended separately afterwards.
    Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER DiskName
    Hard disk name (e.g. "Hard disk 1").
.PARAMETER NewCapacityGB
    New (larger) size in GB.
.EXAMPLE
    PS> ./Expand-VMHardDisk.ps1 -Name db01 -DiskName "Hard disk 1" -NewCapacityGB 120
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
    [Parameter(Mandatory)][decimal]$NewCapacityGB
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm   = Get-VM -Name $Name -ErrorAction Stop
$disk = Get-HardDisk -VM $vm | Where-Object { $_.Name -eq $DiskName }
if (-not $disk) { Write-Warning "Disk '$DiskName' not found on $Name."; return }
if ($NewCapacityGB -le $disk.CapacityGB) { Write-Warning "New size must be larger than current ($([math]::Round($disk.CapacityGB,1)) GB)."; return }

if ($PSCmdlet.ShouldProcess("$Name / $DiskName", "Grow to ${NewCapacityGB}GB")) {
    Set-HardDisk -HardDisk $disk -CapacityGB $NewCapacityGB -Confirm:$false
    Write-Host "$DiskName on $Name grown to ${NewCapacityGB}GB. Remember to extend the guest partition."
}
