<#
.SYNOPSIS
    Creates a DRS anti-affinity rule (keep VMs apart).
.DESCRIPTION
    Creates a VM anti-affinity rule so the listed VMs are kept on separate hosts
    (e.g. clustered database or domain controller pairs). Supports -WhatIf.
.PARAMETER Cluster
    Cluster name.
.PARAMETER Name
    Rule name.
.PARAMETER VM
    Two or more VM names to keep apart.
.EXAMPLE
    PS> ./New-DRSAntiAffinityRule.ps1 -Cluster PROD-CL -Name "DC-Split" -VM dc01,dc02
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Cluster,
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string[]]$VM
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if ($VM.Count -lt 2) { Write-Warning 'Provide at least two VMs.'; return }

$c   = Get-Cluster -Name $Cluster -ErrorAction Stop
$vms = Get-VM -Name $VM -ErrorAction Stop

if ($PSCmdlet.ShouldProcess($Cluster, "Create anti-affinity rule '$Name' for $($VM -join ', ')")) {
    New-DrsRule -Cluster $c -Name $Name -KeepTogether $false -VM $vms
}
