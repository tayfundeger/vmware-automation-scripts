<#
.SYNOPSIS
    Reports vSphere Distributed Switch (VDS) configuration.
.DESCRIPTION
    Lists each distributed switch with version, MTU, uplink/port counts and the
    number of distributed port groups.
.EXAMPLE
    PS> ./Get-DVSwitchInfo.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ (VDS module) and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vds = Get-VDSwitch -ErrorAction SilentlyContinue
if (-not $vds) { Write-Host 'No distributed switches found.'; return }

$vds | Select-Object Name, Version, Mtu, NumUplinkPorts,
    @{N='PortGroups';E={(Get-VDPortgroup -VDSwitch $_).Count}},
    @{N='Hosts';E={(Get-VMHost -DistributedSwitch $_ -ErrorAction SilentlyContinue).Count}}
