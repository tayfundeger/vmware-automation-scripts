<#
.SYNOPSIS
    Lists storage adapters (HBAs) per host.
.DESCRIPTION
    Reports each host's storage adapters with type, model, driver and status.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-StorageAdapters.ps1 -VMHost esxi01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    Get-VMHostHba -VMHost $h | Select-Object `
        @{N='VMHost';E={$h.Name}},
        Device, Type, Model, Driver,
        @{N='Status';E={$_.Status}}
}
