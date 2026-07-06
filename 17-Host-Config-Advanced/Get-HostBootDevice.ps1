<#
.SYNOPSIS
    Reports the boot device of each host.
.DESCRIPTION
    Uses esxcli to report the boot filesystem UUID and boot NIC - useful when
    auditing SD-card/USB boot media or stateless (Auto Deploy) hosts.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-HostBootDevice.ps1
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
    $esx = Get-EsxCli -VMHost $h -V2
    $b   = $esx.system.boot.device.get.Invoke()
    [pscustomobject]@{
        VMHost             = $h.Name
        BootFilesystemUUID = $b.BootFilesystemUUID
        BootNIC            = $b.BootNIC
        StatelessBootNIC   = $b.StatelessBootNIC
    }
}
