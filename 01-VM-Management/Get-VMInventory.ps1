<#
.SYNOPSIS
    Exports a full inventory of all virtual machines.
.DESCRIPTION
    Collects key configuration and capacity data for every VM in the connected
    vCenter(s): power state, CPU, memory, provisioned/used space, guest OS,
    host, cluster and VMware Tools status. Outputs objects or writes a CSV.
.PARAMETER Path
    Optional path to a CSV file. If omitted, objects are returned to the pipeline.
.EXAMPLE
    PS> ./Get-VMInventory.ps1
.EXAMPLE
    PS> ./Get-VMInventory.ps1 -Path C:\Reports\vm_inventory.csv
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string]$Path
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VM | Select-Object Name,
    @{N='PowerState';   E={$_.PowerState}},
    @{N='NumCPU';       E={$_.NumCpu}},
    @{N='MemoryGB';     E={$_.MemoryGB}},
    @{N='ProvisionedGB';E={[math]::Round($_.ProvisionedSpaceGB,2)}},
    @{N='UsedGB';       E={[math]::Round($_.UsedSpaceGB,2)}},
    @{N='GuestOS';      E={$_.Guest.OSFullName}},
    @{N='IPAddress';    E={($_.Guest.IPAddress -join ', ')}},
    @{N='VMHost';       E={$_.VMHost.Name}},
    @{N='Cluster';      E={(Get-Cluster -VM $_ -ErrorAction SilentlyContinue).Name}},
    @{N='ToolsStatus';  E={$_.ExtensionData.Guest.ToolsStatus}},
    @{N='HWVersion';    E={$_.HardwareVersion}}

if ($Path) {
    $report | Sort-Object Name | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
    Write-Host "Inventory written to $Path ($($report.Count) VMs)."
} else {
    $report | Sort-Object Name
}
