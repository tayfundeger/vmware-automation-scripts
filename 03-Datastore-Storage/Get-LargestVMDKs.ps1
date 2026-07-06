<#
.SYNOPSIS
    Lists the largest virtual disks in the environment.
.DESCRIPTION
    Returns the top N virtual disks by provisioned capacity.
.PARAMETER Top
    Number of disks to return (default 20).
.EXAMPLE
    PS> ./Get-LargestVMDKs.ps1 -Top 10
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Top = 20)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | Get-HardDisk | Sort-Object CapacityGB -Descending | Select-Object -First $Top `
    @{N='VM';E={$_.Parent.Name}}, Name,
    @{N='CapacityGB';E={[math]::Round($_.CapacityGB,2)}},
    StorageFormat,
    @{N='Datastore';E={($_.Filename -split '\]')[0].TrimStart('[')}}
