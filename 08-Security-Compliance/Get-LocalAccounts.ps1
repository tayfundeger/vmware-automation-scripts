<#
.SYNOPSIS
    Lists local user accounts on each ESXi host.
.DESCRIPTION
    Uses esxcli (system account list) to enumerate local accounts per host -
    useful for spotting unexpected or stale local users.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-LocalAccounts.ps1
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
    $esxcli = Get-EsxCli -VMHost $h -V2
    $esxcli.system.account.list.Invoke() |
        Select-Object @{N='VMHost';E={$h.Name}}, UserID, Description
}
