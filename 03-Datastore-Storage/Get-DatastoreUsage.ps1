<#
.SYNOPSIS
    Reports capacity and free space for all datastores.
.DESCRIPTION
    Lists every datastore with capacity, free space, used space and percent free.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-DatastoreUsage.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-Datastore | Select-Object Name, Type,
    @{N='CapacityGB';E={[math]::Round($_.CapacityGB,1)}},
    @{N='FreeGB';    E={[math]::Round($_.FreeSpaceGB,1)}},
    @{N='UsedGB';    E={[math]::Round($_.CapacityGB - $_.FreeSpaceGB,1)}},
    @{N='PctFree';   E={[math]::Round(($_.FreeSpaceGB/$_.CapacityGB)*100,1)}} |
    Sort-Object PctFree

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
