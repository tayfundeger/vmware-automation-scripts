<#
.SYNOPSIS
    Reports CPU ready time per VM.
.DESCRIPTION
    Uses realtime cpu.ready.summation to estimate CPU ready percentage. High
    ready % indicates CPU contention / over-commitment. The 20000 ms divisor is
    the realtime (20s) interval in milliseconds.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.PARAMETER MaxSamples
    Number of realtime samples to average (default 5).
.EXAMPLE
    PS> ./Get-VMReadyTime.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*', [int]$MaxSamples = 5)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms = Get-VM -Name $Name | Where-Object { $_.PowerState -eq 'PoweredOn' }
if (-not $vms) { Write-Host 'No powered-on VMs.'; return }
$interval = 20000  # realtime sample interval in ms

Get-Stat -Entity $vms -Stat cpu.ready.summation -Realtime -MaxSamples $MaxSamples -ErrorAction SilentlyContinue |
    Group-Object Entity | ForEach-Object {
        $avgMs = ($_.Group | Measure-Object Value -Average).Average
        [pscustomobject]@{
            VM         = $_.Name
            AvgReadyMs = [math]::Round($avgMs, 0)
            ReadyPct   = [math]::Round(($avgMs / $interval) * 100, 2)
        }
    } | Sort-Object ReadyPct -Descending
