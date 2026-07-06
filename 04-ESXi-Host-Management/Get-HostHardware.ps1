<#
.SYNOPSIS
    Reports physical hardware details for each ESXi host.
.DESCRIPTION
    Lists CPU model, socket/core/thread counts, total memory and the hardware
    service tag / serial number where exposed by the vendor.
.EXAMPLE
    PS> ./Get-HostHardware.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VMHost | ForEach-Object {
    $hw  = $_.ExtensionData.Hardware
    $tag = ($hw.SystemInfo.OtherIdentifyingInfo |
            Where-Object { $_.IdentifierType.Key -in 'ServiceTag','SerialNumberTag','AssetTag' } |
            Select-Object -First 1).IdentifierValue
    [pscustomobject]@{
        Host        = $_.Name
        Vendor      = $hw.SystemInfo.Vendor
        Model       = $hw.SystemInfo.Model
        ServiceTag  = $tag
        CPUModel    = $_.ProcessorType
        Sockets     = $hw.CpuInfo.NumCpuPackages
        Cores       = $hw.CpuInfo.NumCpuCores
        Threads     = $hw.CpuInfo.NumCpuThreads
        MemoryGB    = [math]::Round($_.MemoryTotalGB, 0)
    }
} | Sort-Object Host

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
