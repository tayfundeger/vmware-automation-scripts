<#
.SYNOPSIS
    Enables or disables an ESXi firewall ruleset.
.DESCRIPTION
    Toggles a named firewall exception on a host. Supports -WhatIf.
.PARAMETER VMHost
    Host name.
.PARAMETER RuleName
    Firewall ruleset name (e.g. "sshServer").
.PARAMETER Enabled
    $true to enable, $false to disable.
.EXAMPLE
    PS> ./Set-HostFirewallRule.ps1 -VMHost esxi01 -RuleName sshServer -Enabled $false
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$VMHost,
    [Parameter(Mandatory)][string]$RuleName,
    [Parameter(Mandatory)][bool]$Enabled
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h = Get-VMHost -Name $VMHost -ErrorAction Stop
$rule = Get-VMHostFirewallException -VMHost $h -Name $RuleName -ErrorAction SilentlyContinue
if (-not $rule) { Write-Warning "Firewall rule '$RuleName' not found on $VMHost."; return }

$state = if ($Enabled) { 'Enable' } else { 'Disable' }
if ($PSCmdlet.ShouldProcess("$VMHost / $RuleName", "$state firewall rule")) {
    Set-VMHostFirewallException -Exception $rule -Enabled $Enabled -Confirm:$false
}
