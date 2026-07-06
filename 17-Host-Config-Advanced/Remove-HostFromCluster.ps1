<#
.SYNOPSIS
    Removes an ESXi host from inventory.
.DESCRIPTION
    Safely removes a host: aborts if it still has powered-on VMs, otherwise
    disconnects and removes it. Put the host in maintenance mode first. Supports
    -WhatIf.
.PARAMETER VMHost
    Host name to remove.
.EXAMPLE
    PS> ./Remove-HostFromCluster.ps1 -VMHost esxi09 -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$VMHost)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$h = Get-VMHost -Name $VMHost -ErrorAction Stop
$vmsOn = Get-VM -Location $h | Where-Object { $_.PowerState -eq 'PoweredOn' }
if ($vmsOn) { Write-Warning "$VMHost has $($vmsOn.Count) powered-on VM(s). Evacuate first."; return }

if ($PSCmdlet.ShouldProcess($VMHost, 'Disconnect and remove from inventory')) {
    Set-VMHost -VMHost $h -State Disconnected -Confirm:$false | Out-Null
    Remove-VMHost -VMHost $h -Confirm:$false
    Write-Host "$VMHost removed from inventory."
}
