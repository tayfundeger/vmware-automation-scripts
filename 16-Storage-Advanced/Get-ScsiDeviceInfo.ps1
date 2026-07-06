<#
.SYNOPSIS
    Reports SCSI disk devices (LUNs) per host.
.DESCRIPTION
    Lists disk-type SCSI LUNs visible to each host with vendor, model, capacity
    and multipath policy. Use the canonical name with New-VMFSDatastore.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-ScsiDeviceInfo.ps1 -VMHost esxi01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    Get-ScsiLun -VmHost $h -LunType disk -ErrorAction SilentlyContinue | Select-Object `
        @{N='VMHost';E={$h.Name}},
        CanonicalName, Vendor, Model,
        @{N='CapacityGB';E={[math]::Round($_.CapacityGB,1)}},
        MultipathPolicy
}
