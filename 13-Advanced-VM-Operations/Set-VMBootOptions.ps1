<#
.SYNOPSIS
    Configures VM boot delay and BIOS-setup-on-next-boot.
.DESCRIPTION
    Sets the power-on boot delay (milliseconds) and optionally forces the VM to
    enter firmware setup on next boot. Useful when you need time to press a key.
    Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER BootDelayMs
    Boot delay in milliseconds (default 0).
.PARAMETER EnterBIOSSetup
    Force entry into BIOS/EFI setup on the next boot.
.EXAMPLE
    PS> ./Set-VMBootOptions.ps1 -Name app01 -BootDelayMs 5000
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [int]$BootDelayMs = 0,
    [switch]$EnterBIOSSetup
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.BootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
$spec.BootOptions.BootDelay = $BootDelayMs
if ($EnterBIOSSetup) { $spec.BootOptions.EnterBIOSSetup = $true }

if ($PSCmdlet.ShouldProcess($Name, "Set boot delay ${BootDelayMs}ms (BIOS setup: $([bool]$EnterBIOSSetup))")) {
    $vm.ExtensionData.ReconfigVM($spec)
    Write-Host "$Name boot options updated."
}
