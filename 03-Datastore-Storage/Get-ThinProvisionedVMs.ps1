<#
.SYNOPSIS
    Reports VMs that have thin-provisioned disks.
.DESCRIPTION
    Lists each thin-provisioned virtual disk with its provisioned capacity,
    useful for tracking datastore over-commit risk.
.EXAMPLE
    PS> ./Get-ThinProvisionedVMs.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | Get-HardDisk | Where-Object { $_.StorageFormat -eq 'Thin' } | Select-Object `
    @{N='VM';E={$_.Parent.Name}}, Name,
    @{N='CapacityGB';E={[math]::Round($_.CapacityGB,2)}},
    StorageFormat,
    @{N='Datastore';E={($_.Filename -split '\]')[0].TrimStart('[')}} |
    Sort-Object VM
