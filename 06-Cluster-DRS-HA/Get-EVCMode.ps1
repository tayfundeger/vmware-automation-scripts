<#
.SYNOPSIS
    Reports the EVC mode configured on each cluster.
.DESCRIPTION
    Lists the Enhanced vMotion Compatibility baseline per cluster (blank means
    EVC is disabled).
.EXAMPLE
    PS> ./Get-EVCMode.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Select-Object Name,
    @{N='EVCMode';E={ if ($_.EVCMode) { $_.EVCMode } else { '(disabled)' } }} |
    Sort-Object Name
