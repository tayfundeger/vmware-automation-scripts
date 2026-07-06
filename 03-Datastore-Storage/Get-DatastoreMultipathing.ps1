<#
.SYNOPSIS
    Reports SCSI LUN multipathing policy per host.
.DESCRIPTION
    Lists disk LUNs on each host with their path-selection (multipath) policy
    and vendor - useful for verifying consistent policy across a cluster.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-DatastoreMultipathing.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost -Name $VMHost | Sort-Object Name | ForEach-Object {
    $h = $_
    Get-ScsiLun -VmHost $h -LunType disk | Select-Object `
        @{N='VMHost';E={$h.Name}}, CanonicalName, Vendor, MultipathPolicy,
        @{N='CapacityGB';E={[math]::Round($_.CapacityGB,1)}}
}
