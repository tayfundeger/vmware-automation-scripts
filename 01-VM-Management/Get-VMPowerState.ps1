<#
.SYNOPSIS
    Reports the power state of all VMs plus a summary.
.DESCRIPTION
    Lists every VM with its power state and host, and prints a count summary by
    power state.
.EXAMPLE
    PS> ./Get-VMPowerState.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vms = Get-VM
Write-Host "`n=== Power State Summary ===" -ForegroundColor Cyan
$vms | Group-Object PowerState | Select-Object @{N='PowerState';E={$_.Name}}, Count | Format-Table -AutoSize

$vms | Select-Object Name, PowerState, @{N='VMHost';E={$_.VMHost.Name}} |
    Sort-Object PowerState, Name
