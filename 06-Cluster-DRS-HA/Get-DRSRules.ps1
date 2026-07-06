<#
.SYNOPSIS
    Lists DRS affinity and anti-affinity rules.
.DESCRIPTION
    Enumerates DRS VM-to-VM rules per cluster, resolving the member VM names and
    showing whether each rule is enabled.
.PARAMETER Cluster
    Optional cluster name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-DRSRules.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Cluster = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($c in (Get-Cluster -Name $Cluster | Sort-Object Name)) {
    Get-DrsRule -Cluster $c | Select-Object `
        @{N='Cluster';E={$c.Name}}, Name, Type, Enabled,
        @{N='VMs';E={ (Get-VM -Id $_.VMIds -ErrorAction SilentlyContinue).Name -join ', ' }}
}
