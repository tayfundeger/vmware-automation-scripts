<#
.SYNOPSIS
    Flags datastores below a free-space threshold.
.DESCRIPTION
    Returns datastores whose percent-free is at or below -ThresholdPercent,
    ideal for a scheduled capacity alert.
.PARAMETER ThresholdPercent
    Percent-free alert threshold (default 15).
.EXAMPLE
    PS> ./Get-DatastoreCapacityAlert.ps1 -ThresholdPercent 10
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$ThresholdPercent = 15)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$alerts = Get-Datastore | Where-Object { (($_.FreeSpaceGB/$_.CapacityGB)*100) -le $ThresholdPercent } |
    Select-Object Name,
        @{N='CapacityGB';E={[math]::Round($_.CapacityGB,1)}},
        @{N='FreeGB';    E={[math]::Round($_.FreeSpaceGB,1)}},
        @{N='PctFree';   E={[math]::Round(($_.FreeSpaceGB/$_.CapacityGB)*100,1)}} |
    Sort-Object PctFree

if (-not $alerts) { Write-Host "All datastores above $ThresholdPercent% free." -ForegroundColor Green }
else              { $alerts }
