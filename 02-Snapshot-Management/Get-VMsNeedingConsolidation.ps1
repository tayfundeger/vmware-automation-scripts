<#
.SYNOPSIS
    Lists VMs that require disk consolidation.
.DESCRIPTION
    Reports VMs where Runtime.ConsolidationNeeded is true - typically leftover
    delta disks after a failed or interrupted snapshot removal.
.EXAMPLE
    PS> ./Get-VMsNeedingConsolidation.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms = Get-VM | Where-Object { $_.ExtensionData.Runtime.ConsolidationNeeded }
if (-not $vms) { Write-Host 'No VMs require consolidation.' -ForegroundColor Green; return }

$vms | Select-Object Name, PowerState, @{N='VMHost';E={$_.VMHost.Name}}
