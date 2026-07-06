<#
.SYNOPSIS
    Exports an inventory of all ESXi hosts.
.DESCRIPTION
    Lists each host with connection/power state, ESXi version and build, vendor,
    model, cluster, VM count and uptime in days.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-HostInventory.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VMHost | Select-Object Name,
    @{N='ConnectionState';E={$_.ConnectionState}},
    @{N='PowerState';E={$_.PowerState}},
    @{N='Version';E={$_.Version}},
    @{N='Build';E={$_.Build}},
    @{N='Vendor';E={$_.Manufacturer}},
    @{N='Model';E={$_.Model}},
    @{N='Cluster';E={(Get-Cluster -VMHost $_ -ErrorAction SilentlyContinue).Name}},
    @{N='VMCount';E={(Get-VM -Location $_).Count}},
    @{N='UptimeDays';E={[math]::Round($_.ExtensionData.Summary.QuickStats.Uptime/86400,1)}} |
    Sort-Object Name

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
