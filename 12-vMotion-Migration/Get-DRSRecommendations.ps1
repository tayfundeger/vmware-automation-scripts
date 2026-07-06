<#
.SYNOPSIS
    Lists (and optionally applies) pending DRS recommendations.
.DESCRIPTION
    Shows current DRS migration recommendations per cluster. With -Apply, invokes
    them (respecting -WhatIf).
.PARAMETER Cluster
    Optional cluster name filter (wildcards allowed).
.PARAMETER Apply
    Apply the recommendations instead of only listing them.
.EXAMPLE
    PS> ./Get-DRSRecommendations.ps1
.EXAMPLE
    PS> ./Get-DRSRecommendations.ps1 -Cluster PROD-CL -Apply -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([string]$Cluster = '*', [switch]$Apply)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($c in (Get-Cluster -Name $Cluster | Sort-Object Name)) {
    $recs = Get-DrsRecommendation -Cluster $c -ErrorAction SilentlyContinue
    if (-not $recs) { continue }

    $recs | Select-Object @{N='Cluster';E={$c.Name}}, Priority, Reason, Recommendation

    if ($Apply) {
        foreach ($r in $recs) {
            if ($PSCmdlet.ShouldProcess("$($c.Name)", "Apply DRS recommendation: $($r.Recommendation)")) {
                $r | Invoke-DrsRecommendation
            }
        }
    }
}
