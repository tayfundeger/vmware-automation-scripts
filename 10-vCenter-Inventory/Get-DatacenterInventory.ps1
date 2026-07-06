<#
.SYNOPSIS
    Summarizes each datacenter's objects.
.DESCRIPTION
    Reports, per datacenter, the number of clusters, standalone/total hosts, VMs
    and datastores.
.EXAMPLE
    PS> ./Get-DatacenterInventory.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Datacenter | Sort-Object Name | ForEach-Object {
    [pscustomobject]@{
        Datacenter = $_.Name
        Clusters   = (Get-Cluster   -Location $_).Count
        Hosts      = (Get-VMHost    -Location $_).Count
        VMs        = (Get-VM        -Location $_).Count
        Datastores = (Get-Datastore -Location $_).Count
    }
}
