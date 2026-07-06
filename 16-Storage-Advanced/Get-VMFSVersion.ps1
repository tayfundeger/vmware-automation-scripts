<#
.SYNOPSIS
    Reports the VMFS version of each datastore.
.DESCRIPTION
    Lists VMFS datastores with their major version (5 vs 6) and capacity - handy
    for planning VMFS-6 migrations.
.EXAMPLE
    PS> ./Get-VMFSVersion.ps1
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
        Datastore    = $_.Name
        MajorVersion = $vmfs.MajorVersion
        Version      = $vmfs.Version
        CapacityGB   = [math]::Round($_.CapacityGB,1)
        FreeGB       = [math]::Round($_.FreeSpaceGB,1)
    }
}
