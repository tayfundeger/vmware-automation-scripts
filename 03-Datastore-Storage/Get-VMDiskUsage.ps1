<#
.SYNOPSIS
    Reports virtual disk details for one or all VMs.
.DESCRIPTION
    Lists each virtual disk with capacity, format, disk type and datastore path.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VMDiskUsage.ps1 -Name db01
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM -Name $Name | Get-HardDisk | Select-Object `
    @{N='VM';E={$_.Parent.Name}}, Name,
    @{N='CapacityGB';E={[math]::Round($_.CapacityGB,2)}},
    StorageFormat, DiskType,
    @{N='Filename';E={$_.Filename}} |
    Sort-Object VM, Name
