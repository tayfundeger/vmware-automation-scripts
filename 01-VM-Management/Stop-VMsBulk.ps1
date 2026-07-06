<#
.SYNOPSIS
    Gracefully shuts down multiple VMs in bulk.
.DESCRIPTION
    Issues a guest OS shutdown (via VMware Tools) to a set of powered-on VMs.
    Falls back with a warning when Tools is not running, unless -Force is used
    to hard power off.
.PARAMETER Name
    Specific VM names to shut down.
.PARAMETER Cluster
    Shut down all VMs in this cluster.
.PARAMETER Force
    Hard power off (Stop-VM) instead of a graceful guest shutdown.
.EXAMPLE
    PS> ./Stop-VMsBulk.ps1 -Cluster TEST-CL
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string[]]$Name,
    [string]$Cluster,
    [switch]$Force
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if     ($Name)    { $vms = Get-VM -Name $Name }
elseif ($Cluster) { $vms = Get-Cluster -Name $Cluster | Get-VM }
else              { $vms = Get-VM }

foreach ($vm in ($vms | Where-Object { $_.PowerState -eq 'PoweredOn' })) {
    if ($Force) {
        Write-Host "Hard power off: $($vm.Name)"
        Stop-VM -VM $vm -Confirm:$false | Out-Null
    }
    elseif ($vm.ExtensionData.Guest.ToolsRunningStatus -eq 'guestToolsRunning') {
        Write-Host "Guest shutdown: $($vm.Name)"
        Stop-VMGuest -VM $vm -Confirm:$false | Out-Null
    }
    else {
        Write-Warning "$($vm.Name): VMware Tools not running. Skipped. Use -Force to hard power off."
    }
}
