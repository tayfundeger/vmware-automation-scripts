<#
.SYNOPSIS
    Reports the HA admission-control policy and effective resources.
.DESCRIPTION
    Describes each cluster's HA admission-control policy (host-failures,
    percentage or dedicated failover hosts) and shows effective vs. total CPU
    and memory as reported by vCenter.
.EXAMPLE
    PS> ./Get-HAFailoverCapacity.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Sort-Object Name | ForEach-Object {
    $sum = $_.ExtensionData.Summary
    $pol = $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy
    $desc = if (-not $pol) { '(none)' } else {
        switch ($pol.GetType().Name) {
            'ClusterFailoverLevelAdmissionControlPolicy'     { "Host failures tolerated: $($pol.FailoverLevel)" }
            'ClusterFailoverResourcesAdmissionControlPolicy' { "CPU $($pol.CpuFailoverResourcesPercent)% / Mem $($pol.MemoryFailoverResourcesPercent)%" }
            'ClusterFailoverHostAdmissionControlPolicy'      { "Dedicated failover hosts: $($pol.FailoverHosts.Count)" }
            default { $pol.GetType().Name }
        }
    }
    [pscustomobject]@{
        Cluster          = $_.Name
        HAEnabled        = $_.HAEnabled
        AdmissionPolicy  = $desc
        EffectiveHosts   = $sum.NumEffectiveHosts
        TotalHosts       = $sum.NumHosts
        EffectiveCpuGHz  = [math]::Round($sum.EffectiveCpu/1000,1)
        TotalCpuGHz      = [math]::Round($sum.TotalCpu/1000,1)
        EffectiveMemGB   = [math]::Round($sum.EffectiveMemory/1024,0)
        TotalMemGB       = [math]::Round($sum.TotalMemory/1GB,0)
    }
}
