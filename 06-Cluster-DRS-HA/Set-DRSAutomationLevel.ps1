<#
.SYNOPSIS
    Sets the DRS automation level of a cluster.
.DESCRIPTION
    Changes DRS automation to FullyAutomated, PartiallyAutomated or Manual.
    Supports -WhatIf.
.PARAMETER Cluster
    Cluster name.
.PARAMETER Level
    FullyAutomated | PartiallyAutomated | Manual.
.EXAMPLE
    PS> ./Set-DRSAutomationLevel.ps1 -Cluster PROD-CL -Level FullyAutomated
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Cluster,
    [Parameter(Mandatory)][ValidateSet('FullyAutomated','PartiallyAutomated','Manual')][string]$Level
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$c = Get-Cluster -Name $Cluster -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($Cluster, "Set DRS automation to $Level")) {
    Set-Cluster -Cluster $c -DrsAutomationLevel $Level -Confirm:$false
}
