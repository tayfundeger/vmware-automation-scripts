<#
.SYNOPSIS
    Reports datastore cluster (SDRS) configuration and capacity.
.DESCRIPTION
    Lists each datastore cluster with SDRS automation level, capacity and the
    member datastore count.
.EXAMPLE
    PS> ./Get-DatastoreClusterInfo.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$dsc = Get-DatastoreCluster
if (-not $dsc) { Write-Host 'No datastore clusters found.'; return }

$dsc | Select-Object Name,
    @{N='SdrsAutomation';E={$_.SdrsAutomationLevel}},
    @{N='CapacityGB';E={[math]::Round($_.CapacityGB,1)}},
    @{N='FreeGB';    E={[math]::Round($_.FreeSpaceGB,1)}},
    @{N='Members';   E={(Get-Datastore -RelatedObject $_).Count}}
