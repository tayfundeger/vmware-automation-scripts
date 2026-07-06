<#
.SYNOPSIS
    Restarts the guest OS of one or more VMs.
.DESCRIPTION
    Sends a graceful guest OS reboot via VMware Tools. Requires Tools running.
.PARAMETER Name
    One or more VM names.
.EXAMPLE
    PS> ./Restart-VMGuest.ps1 -Name app01,app02
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string[]]$Name
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($vmName in $Name) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if (-not $vm) { Write-Warning "VM not found: $vmName"; continue }
    if ($vm.ExtensionData.Guest.ToolsRunningStatus -ne 'guestToolsRunning') {
        Write-Warning "$vmName: Tools not running, cannot restart guest."; continue
    }
    if ($PSCmdlet.ShouldProcess($vmName, 'Restart guest OS')) {
        Restart-VMGuest -VM $vm -Confirm:$false | Out-Null
    }
}
