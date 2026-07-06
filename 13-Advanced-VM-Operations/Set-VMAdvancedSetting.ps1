<#
.SYNOPSIS
    Sets a VM advanced (extraConfig) setting.
.DESCRIPTION
    Creates or updates a VM advanced configuration key (e.g. disk.EnableUUID).
    Some settings only take effect when the VM is powered off. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER SettingName
    Advanced setting key.
.PARAMETER Value
    Value to set.
.EXAMPLE
    PS> ./Set-VMAdvancedSetting.ps1 -Name db01 -SettingName disk.EnableUUID -Value TRUE
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$SettingName,
    [Parameter(Mandatory)][string]$Value
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$existing = Get-AdvancedSetting -Entity $vm -Name $SettingName -ErrorAction SilentlyContinue

if ($PSCmdlet.ShouldProcess($Name, "Set advanced setting $SettingName=$Value")) {
    if ($existing) { Set-AdvancedSetting -AdvancedSetting $existing -Value $Value -Confirm:$false }
    else           { New-AdvancedSetting -Entity $vm -Name $SettingName -Value $Value -Confirm:$false }
}
