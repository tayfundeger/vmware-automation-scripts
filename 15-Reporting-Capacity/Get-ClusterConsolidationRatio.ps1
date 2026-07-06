<#
.SYNOPSIS
    Reports VM-to-host consolidation ratio per cluster.
.DESCRIPTION
    Shows how many VMs run per host in each cluster - a quick view of
    consolidation density.
.EXAMPLE
    PS> ./Get-ClusterConsolidationRatio.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Sort-Object Name | ForEach-Object {
    $hostCount = (Get-VMHost -Location $_).Count
    $vmCount   = (Get-VM -Location $_).Count
    [pscustomobject]@{
        Cluster       = $_.Name
        Hosts         = $hostCount
        VMs           = $vmCount
        VMsPerHost    = if ($hostCount) { [math]::Round($vmCount / $hostCount, 1) } else { 0 }
    }
}
