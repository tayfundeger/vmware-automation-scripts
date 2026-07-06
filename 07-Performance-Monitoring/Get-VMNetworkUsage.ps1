<#
.SYNOPSIS
    Reports real-time network throughput per VM.
.DESCRIPTION
    Uses realtime stats (net.usage.average) to report average and peak network
    usage in Mbps for powered-on VMs.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.PARAMETER MaxSamples
    Number of realtime samples to average (default 5).
.EXAMPLE
    PS> ./Get-VMNetworkUsage.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
    net.usage.average is reported in KBps; this script converts to Mbps.
#>
[CmdletBinding()]
param([string]$Name = '*', [int]$MaxSamples = 5)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms = Get-VM -Name $Name | Where-Object { $_.PowerState -eq 'PoweredOn' }
if (-not $vms) { Write-Host 'No powered-on VMs.'; return }

Get-Stat -Entity $vms -Stat net.usage.average -Realtime -MaxSamples $MaxSamples -ErrorAction SilentlyContinue |
    Group-Object Entity | ForEach-Object {
        $avgKBps = ($_.Group | Measure-Object Value -Average).Average
        $maxKBps = ($_.Group | Measure-Object Value -Maximum).Maximum
        [pscustomobject]@{
            VM        = $_.Name
            AvgMbps   = [math]::Round(($avgKBps * 8) / 1000, 2)
            MaxMbps   = [math]::Round(($maxKBps * 8) / 1000, 2)
        }
    } | Sort-Object MaxMbps -Descending
