<#
.SYNOPSIS
    Upgrades VMware Tools on one or more VMs.
.DESCRIPTION
    Initiates a VMware Tools upgrade. Use -NoReboot to suppress the automatic
    guest reboot. Supports -WhatIf.
.PARAMETER Name
    VM name(s).
.PARAMETER NoReboot
    Do not automatically reboot the guest after the upgrade.
.EXAMPLE
    PS> ./Update-VMTools.ps1 -Name web01,web02 -NoReboot
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string[]]$Name,
    [switch]$NoReboot
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($vmName in $Name) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if (-not $vm) { Write-Warning "VM not found: $vmName"; continue }
    if ($vm.PowerState -ne 'PoweredOn') { Write-Warning "$vmName is not powered on."; continue }
    if ($PSCmdlet.ShouldProcess($vmName, 'Upgrade VMware Tools')) {
        Update-Tools -VM $vm -NoReboot:$NoReboot
        Write-Host "$vmName: Tools upgrade initiated."
    }
}
