<#
.SYNOPSIS
    Reports vSphere HA configuration per cluster.
.DESCRIPTION
    Shows HA enablement, host monitoring, VM monitoring, admission control state
    and isolation response for each cluster.
.EXAMPLE
    PS> ./Get-HAConfiguration.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Sort-Object Name | ForEach-Object {
    $das = $_.ExtensionData.Configuration.DasConfig
    [pscustomobject]@{
        Cluster          = $_.Name
        HAEnabled        = $_.HAEnabled
        HostMonitoring   = $das.HostMonitoring
        VMMonitoring     = $das.VmMonitoring
        AdmissionControl = $das.AdmissionControlEnabled
        RestartPriority  = $das.DefaultVmSettings.RestartPriority
        IsolationResponse= $das.DefaultVmSettings.IsolationResponse
    }
}
