<#
.SYNOPSIS
    Lists loaded ESXi kernel modules per host.
.DESCRIPTION
    Uses esxcli to enumerate kernel modules (VMkernel drivers) with their
    enabled/loaded state. Optionally filter by module name.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.PARAMETER Module
    Optional module name pattern to filter.
.EXAMPLE
    PS> ./Get-HostKernelModules.ps1 -VMHost esxi01 -Module nfnic
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*', [string]$Module)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    $esx  = Get-EsxCli -VMHost $h -V2
    $mods = $esx.system.module.list.Invoke()
    if ($Module) { $mods = $mods | Where-Object { $_.Name -like "*$Module*" } }
    $mods | Select-Object @{N='VMHost';E={$h.Name}}, Name, IsEnabled, IsLoaded
}
