<#
.SYNOPSIS
    Exports a full inventory to CSV files.
.DESCRIPTION
    Writes VMs.csv, Hosts.csv, Datastores.csv and Clusters.csv into -OutputFolder
    for a point-in-time snapshot of the environment.
.PARAMETER OutputFolder
    Destination folder (default .\Inventory).
.EXAMPLE
    PS> ./Export-FullInventory.ps1 -OutputFolder C:\Reports\Inv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$OutputFolder = '.\Inventory')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

Get-VM | Select-Object Name, PowerState, NumCpu, MemoryGB,
    @{N='UsedGB';E={[math]::Round($_.UsedSpaceGB,1)}},
    @{N='VMHost';E={$_.VMHost.Name}},
    @{N='GuestOS';E={$_.ExtensionData.Config.GuestFullName}} |
    Export-Csv (Join-Path $OutputFolder 'VMs.csv') -NoTypeInformation -Encoding UTF8

Get-VMHost | Select-Object Name, ConnectionState, PowerState, Version, Build,
    @{N='CPUCores';E={$_.NumCpu}},
    @{N='MemoryGB';E={[math]::Round($_.MemoryTotalGB,1)}},
    Manufacturer, Model |
    Export-Csv (Join-Path $OutputFolder 'Hosts.csv') -NoTypeInformation -Encoding UTF8

Get-Datastore | Select-Object Name, Type,
    @{N='CapacityGB';E={[math]::Round($_.CapacityGB,1)}},
    @{N='FreeGB';E={[math]::Round($_.FreeSpaceGB,1)}},
    @{N='PctFree';E={ if ($_.CapacityGB) { [math]::Round(($_.FreeSpaceGB/$_.CapacityGB)*100,1) } else { 0 } }} |
    Export-Csv (Join-Path $OutputFolder 'Datastores.csv') -NoTypeInformation -Encoding UTF8

Get-Cluster | Select-Object Name, HAEnabled, DrsEnabled, DrsAutomationLevel,
    @{N='Hosts';E={(Get-VMHost -Location $_).Count}},
    @{N='VMs';E={(Get-VM -Location $_).Count}} |
    Export-Csv (Join-Path $OutputFolder 'Clusters.csv') -NoTypeInformation -Encoding UTF8

Write-Host "Inventory exported to $OutputFolder (VMs, Hosts, Datastores, Clusters)."
