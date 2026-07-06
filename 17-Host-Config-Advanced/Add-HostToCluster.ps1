<#
.SYNOPSIS
    Adds an ESXi host to a cluster.
.DESCRIPTION
    Joins a new ESXi host to an existing cluster using host root credentials.
    Supports -WhatIf.
.PARAMETER VMHostName
    Host FQDN or IP to add.
.PARAMETER Cluster
    Target cluster.
.PARAMETER HostCredential
    ESXi host credentials (PSCredential, usually root).
.EXAMPLE
    PS> ./Add-HostToCluster.ps1 -VMHostName esxi09.lab.local -Cluster PROD-CL -HostCredential (Get-Credential)
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHostName,
    [Parameter(Mandatory)][string]$Cluster,
    [Parameter(Mandatory)][System.Management.Automation.PSCredential]$HostCredential
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$c = Get-Cluster -Name $Cluster -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($VMHostName, "Add to cluster $Cluster")) {
    Add-VMHost -Name $VMHostName -Location $c -Credential $HostCredential -Force
    Write-Host "$VMHostName added to $Cluster."
}
