<#
.SYNOPSIS
    Maps VMFS datastores to their backing LUN(s).
.DESCRIPTION
    For each VMFS datastore, reports the backing device canonical name(s) and
    partition - useful when correlating datastores with array LUNs.
.EXAMPLE
    PS> ./Get-DatastoreLUNMapping.ps1
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
    $ds = $_
    foreach ($ext in $_.ExtensionData.Info.Vmfs.Extent) {
        [pscustomobject]@{
            Datastore     = $ds.Name
            CanonicalName = $ext.DiskName
            Partition     = $ext.Partition
        }
    }
}
