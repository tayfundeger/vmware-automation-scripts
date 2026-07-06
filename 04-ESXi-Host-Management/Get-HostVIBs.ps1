<#
.SYNOPSIS
    Lists installed VIBs (patches/drivers) on ESXi hosts.
.DESCRIPTION
    Uses esxcli (v2) to enumerate installed VIBs with vendor, version and install
    date. Optionally filter by a name pattern.
.PARAMETER VMHost
    Host name filter (wildcards allowed, default all hosts).
.PARAMETER Match
    Optional VIB name substring filter (e.g. 'nfnic', 'lsu').
.EXAMPLE
    PS> ./Get-HostVIBs.ps1 -VMHost esxi01 -Match nvme
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string]$VMHost = '*',
    [string]$Match
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    $esxcli = Get-EsxCli -VMHost $h -V2
    $vibs   = $esxcli.software.vib.list.Invoke()
    if ($Match) { $vibs = $vibs | Where-Object { $_.Name -like "*$Match*" } }
    $vibs | Select-Object @{N='VMHost';E={$h.Name}}, Name, Version, Vendor, InstallDate
}
