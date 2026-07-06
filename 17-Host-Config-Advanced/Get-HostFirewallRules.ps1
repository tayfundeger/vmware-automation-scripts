<#
.SYNOPSIS
    Lists ESXi firewall rulesets per host.
.DESCRIPTION
    Reports each host's firewall exceptions with enabled state, protocols and
    incoming ports.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.PARAMETER EnabledOnly
    Only return enabled rulesets.
.EXAMPLE
    PS> ./Get-HostFirewallRules.ps1 -VMHost esxi01 -EnabledOnly
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*', [switch]$EnabledOnly)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    $rules = Get-VMHostFirewallException -VMHost $h
    if ($EnabledOnly) { $rules = $rules | Where-Object { $_.Enabled } }
    $rules | Select-Object `
        @{N='VMHost';E={$h.Name}},
        Name, Enabled,
        @{N='Protocols';E={$_.Protocols}},
        @{N='IncomingPorts';E={$_.IncomingPorts}}
}
