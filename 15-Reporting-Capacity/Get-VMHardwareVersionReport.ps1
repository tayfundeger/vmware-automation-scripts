<#
.SYNOPSIS
    Summarizes VMs by virtual hardware version.
.DESCRIPTION
    Groups all VMs by their hardware (compatibility) version and reports the
    count of each - useful for planning hardware upgrades.
.EXAMPLE
    PS> ./Get-VMHardwareVersionReport.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM |
    Group-Object HardwareVersion |
    Select-Object @{N='HardwareVersion';E={$_.Name}}, Count |
    Sort-Object HardwareVersion
