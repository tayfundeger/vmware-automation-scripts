<#
.SYNOPSIS
    Sets the CPU power management policy on a host.
.DESCRIPTION
    Changes the host power policy to High Performance, Balanced, Low Power or
    Custom. Supports -WhatIf.
.PARAMETER VMHost
    Host name.
.PARAMETER Policy
    HighPerformance, Balanced, LowPower or Custom.
.EXAMPLE
    PS> ./Set-HostPowerPolicy.ps1 -VMHost esxi01 -Policy HighPerformance
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHost,
    [Parameter(Mandatory)][ValidateSet('HighPerformance','Balanced','LowPower','Custom')][string]$Policy
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$map = @{ HighPerformance = 1; Balanced = 2; LowPower = 3; Custom = 4 }
$h = Get-VMHost -Name $VMHost -ErrorAction Stop
$ps = Get-View $h.ExtensionData.ConfigManager.PowerSystem

if ($PSCmdlet.ShouldProcess($VMHost, "Set power policy to $Policy")) {
    $ps.ConfigurePowerPolicy($map[$Policy])
    Write-Host "$VMHost power policy set to $Policy."
}
