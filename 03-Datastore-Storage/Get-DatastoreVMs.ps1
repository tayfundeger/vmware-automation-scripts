<#
.SYNOPSIS
    Lists VMs residing on each datastore.
.DESCRIPTION
    Maps every datastore to the VMs that have files on it, with per-VM used space.
.PARAMETER Datastore
    Optional datastore name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-DatastoreVMs.ps1 -Datastore "PROD-*"
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Datastore = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Datastore -Name $Datastore | Sort-Object Name | ForEach-Object {
    $ds = $_
    Get-VM -Datastore $ds | Select-Object @{N='Datastore';E={$ds.Name}}, Name, PowerState,
        @{N='UsedGB';E={[math]::Round($_.UsedSpaceGB,2)}}
}
