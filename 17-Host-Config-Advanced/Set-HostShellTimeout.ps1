<#
.SYNOPSIS
    Sets ESXi Shell / SSH idle timeouts (hardening).
.DESCRIPTION
    Configures ESXiShellTimeOut (availability) and ESXiShellInteractiveTimeOut
    (idle) advanced settings, in seconds (0 disables). Supports -WhatIf.
.PARAMETER VMHost
    Host name.
.PARAMETER ShellTimeoutSec
    Availability timeout in seconds (how long shell/SSH stays enabled).
.PARAMETER InteractiveTimeoutSec
    Idle session timeout in seconds.
.EXAMPLE
    PS> ./Set-HostShellTimeout.ps1 -VMHost esxi01 -ShellTimeoutSec 3600 -InteractiveTimeoutSec 900
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHost,
    [int]$ShellTimeoutSec,
    [int]$InteractiveTimeoutSec
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not $PSBoundParameters.ContainsKey('ShellTimeoutSec') -and -not $PSBoundParameters.ContainsKey('InteractiveTimeoutSec')) {
    Write-Warning 'Specify -ShellTimeoutSec and/or -InteractiveTimeoutSec.'; return
}

$h = Get-VMHost -Name $VMHost -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($VMHost, 'Set shell/SSH timeouts')) {
    if ($PSBoundParameters.ContainsKey('ShellTimeoutSec')) {
        Get-AdvancedSetting -Entity $h -Name 'UserVars.ESXiShellTimeOut' | Set-AdvancedSetting -Value $ShellTimeoutSec -Confirm:$false | Out-Null
    }
    if ($PSBoundParameters.ContainsKey('InteractiveTimeoutSec')) {
        Get-AdvancedSetting -Entity $h -Name 'UserVars.ESXiShellInteractiveTimeOut' | Set-AdvancedSetting -Value $InteractiveTimeoutSec -Confirm:$false | Out-Null
    }
    Write-Host "$VMHost shell timeouts updated."
}
