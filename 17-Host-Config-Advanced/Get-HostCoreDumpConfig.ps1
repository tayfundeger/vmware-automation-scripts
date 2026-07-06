<#
.SYNOPSIS
    Reports ESXi core dump configuration per host.
.DESCRIPTION
    Uses esxcli to report the active/configured core dump partition and any
    network (dump collector) settings - important for support diagnostics.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-HostCoreDumpConfig.ps1
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
    $esx  = Get-EsxCli -VMHost $h -V2
    $part = $esx.system.coredump.partition.get.Invoke()
    $net  = $esx.system.coredump.network.get.Invoke()
    [pscustomobject]@{
        VMHost              = $h.Name
        ActivePartition     = $part.Active
        ConfiguredPartition = $part.Configured
        NetworkEnabled      = $net.Enabled
        NetworkServer       = $net.NetworkServerIP
        NetworkPort         = $net.NetworkServerPort
    }
}
