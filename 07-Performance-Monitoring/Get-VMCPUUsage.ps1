<#
.SYNOPSIS
    Reports real-time CPU usage (%) per VM.
.DESCRIPTION
    Uses realtime performance stats (cpu.usage.average) to report average and
    peak CPU percentage for powered-on VMs over the recent sample window.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.PARAMETER MaxSamples
    Number of realtime samples to average (default 5, ~20s each).
.EXAMPLE
    PS> ./Get-VMCPUUsage.ps1 -MaxSamples 10
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*', [int]$MaxSamples = 5)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms = Get-VM -Name $Name | Where-Object { $_.PowerState -eq 'PoweredOn' }
if (-not $vms) { Write-Host 'No powered-on VMs.'; return }

Get-Stat -Entity $vms -Stat cpu.usage.average -Realtime -MaxSamples $MaxSamples -ErrorAction SilentlyContinue |
    Group-Object Entity | ForEach-Object {
        [pscustomobject]@{
            VM        = $_.Name
            AvgCPUPct = [math]::Round(($_.Group | Measure-Object Value -Average).Average, 1)
            MaxCPUPct = [math]::Round(($_.Group | Measure-Object Value -Maximum).Maximum, 1)
        }
    } | Sort-Object AvgCPUPct -Descending
