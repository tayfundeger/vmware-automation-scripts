<#
.SYNOPSIS
    Reports the CPU power management policy per host.
.DESCRIPTION
    Shows each host's active power policy (High Performance, Balanced, Low Power
    or Custom) - "High Performance" is often preferred for latency-sensitive
    workloads.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-HostPowerPolicy.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    $cur = $h.ExtensionData.Config.PowerSystemInfo.CurrentPolicy
    [pscustomobject]@{
        VMHost    = $h.Name
        Policy    = $cur.Name
        ShortName = $cur.ShortName
    }
}
