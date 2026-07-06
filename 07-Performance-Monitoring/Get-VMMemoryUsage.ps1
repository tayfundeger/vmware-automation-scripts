<#
.SYNOPSIS
    Reports real-time memory usage (%) per VM.
.DESCRIPTION
    Uses realtime performance stats (mem.usage.average) to report average and
    peak active memory percentage for powered-on VMs.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.PARAMETER MaxSamples
    Number of realtime samples to average (default 5).
.EXAMPLE
    PS> ./Get-VMMemoryUsage.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*', [int]$MaxSamples = 5)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms = Get-VM -Name $Name | Where-Object { $_.PowerState -eq 'PoweredOn' }
if (-not $vms) { Write-Host 'No powered-on VMs.'; return }

Get-Stat -Entity $vms -Stat mem.usage.average -Realtime -MaxSamples $MaxSamples -ErrorAction SilentlyContinue |
    Group-Object Entity | ForEach-Object {
        [pscustomobject]@{
            VM        = $_.Name
            AvgMemPct = [math]::Round(($_.Group | Measure-Object Value -Average).Average, 1)
            MaxMemPct = [math]::Round(($_.Group | Measure-Object Value -Maximum).Maximum, 1)
        }
    } | Sort-Object AvgMemPct -Descending
