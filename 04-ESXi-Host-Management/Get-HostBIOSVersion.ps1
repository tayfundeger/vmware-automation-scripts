<#
.SYNOPSIS
    Reports the BIOS/firmware version of each host.
.DESCRIPTION
    Reads BiosInfo to list BIOS version and release date - useful for firmware
    compliance checks against vendor baselines.
.EXAMPLE
    PS> ./Get-HostBIOSVersion.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Select-Object Name,
    @{N='Vendor';E={$_.Manufacturer}},
    @{N='Model';E={$_.Model}},
    @{N='BIOSVersion';E={$_.ExtensionData.Hardware.BiosInfo.BiosVersion}},
    @{N='BIOSDate';E={$_.ExtensionData.Hardware.BiosInfo.ReleaseDate}} |
    Sort-Object Name
