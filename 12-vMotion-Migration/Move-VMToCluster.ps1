<#
.SYNOPSIS
    Migrates a VM to a different cluster.
.DESCRIPTION
    Moves a VM onto a connected host in the target cluster. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER Cluster
    Target cluster.
.EXAMPLE
    PS> ./Move-VMToCluster.ps1 -Name app01 -Cluster DR-CL
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Cluster
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$c  = Get-Cluster -Name $Cluster -ErrorAction Stop
$dest = Get-VMHost -Location $c | Where-Object { $_.ConnectionState -eq 'Connected' } | Select-Object -First 1
if (-not $dest) { Write-Warning "No connected host in cluster $Cluster."; return }

if ($PSCmdlet.ShouldProcess($Name, "Migrate to cluster $Cluster (host $($dest.Name))")) {
    Move-VM -VM $vm -Destination $dest
}
