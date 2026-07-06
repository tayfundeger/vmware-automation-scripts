<#
.SYNOPSIS
    Reports configuration of all clusters.
.DESCRIPTION
    Lists each cluster with HA/DRS status, DRS automation level, EVC mode and
    host/VM counts.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-ClusterInventory.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-Cluster | Select-Object Name,
    @{N='HAEnabled';E={$_.HAEnabled}},
    @{N='DrsEnabled';E={$_.DrsEnabled}},
    @{N='DrsAutomation';E={$_.DrsAutomationLevel}},
    @{N='EVCMode';E={$_.EVCMode}},
    @{N='Hosts';E={(Get-VMHost -Location $_).Count}},
    @{N='VMs';E={(Get-VM -Location $_).Count}} |
    Sort-Object Name

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
