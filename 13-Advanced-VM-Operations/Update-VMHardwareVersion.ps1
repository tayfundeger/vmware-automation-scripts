<#
.SYNOPSIS
    Upgrades a VM's virtual hardware (compatibility) version.
.DESCRIPTION
    Upgrades the VM to the latest supported hardware version, or to a specific
    version string (e.g. vmx-19). The VM must be powered off. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER Version
    Optional target version (e.g. vmx-19). Omit for latest supported.
.EXAMPLE
    PS> ./Update-VMHardwareVersion.ps1 -Name app01 -Version vmx-21 -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$Name, [string]$Version)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
if ($vm.PowerState -ne 'PoweredOff') { Write-Warning "$Name must be powered off to upgrade hardware version."; return }

$target = if ($Version) { $Version } else { 'latest supported' }
if ($PSCmdlet.ShouldProcess($Name, "Upgrade hardware version to $target")) {
    if ($Version) { $vm.ExtensionData.UpgradeVM_Task($Version) | Out-Null }
    else          { $vm.ExtensionData.UpgradeVM_Task($null)    | Out-Null }
    Write-Host "$Name hardware upgrade task submitted ($target)."
}
