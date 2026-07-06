<#
.SYNOPSIS
    Reports lockdown mode status per host.
.DESCRIPTION
    Lists the lockdown mode (Disabled / Normal / Strict) configured on each host.
.EXAMPLE
    PS> ./Get-LockdownMode.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Select-Object Name,
    @{N='LockdownMode';E={$_.ExtensionData.Config.LockdownMode}} |
    Sort-Object Name
