<#
.SYNOPSIS
    Reports detailed VMFS datastore properties.
.DESCRIPTION
    For each VMFS datastore, shows version, block size, UUID and capacity/free
    space - a detailed VMFS fingerprint.
.EXAMPLE
    PS> ./Get-VMFSProperties.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Datastore | Where-Object { $_.Type -eq 'VMFS' } | Sort-Object Name | ForEach-Object {
    $vmfs = $_.ExtensionData.Info.Vmfs
    [pscustomobject]@{
        Datastore   = $_.Name
        Version     = $vmfs.Version
        BlockSizeMB = $vmfs.BlockSizeMb
        UUID        = $vmfs.Uuid
        CapacityGB  = [math]::Round($_.CapacityGB,1)
        FreeGB      = [math]::Round($_.FreeSpaceGB,1)
    }
}
