<#
.SYNOPSIS
    Powers on multiple VMs in bulk.
.DESCRIPTION
    Starts a set of powered-off VMs selected by name or by cluster, with an
    optional delay between each power-on to stagger boot storms.
.PARAMETER Name
    Specific VM names to power on.
.PARAMETER Cluster
    Power on all VMs in this cluster.
.PARAMETER DelaySeconds
    Seconds to wait between each power-on (default 0).
.EXAMPLE
    PS> ./Start-VMsBulk.ps1 -Cluster PROD-CL -DelaySeconds 10
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string[]]$Name,
    [string]$Cluster,
    [int]$DelaySeconds = 0
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if     ($Name)    { $vms = Get-VM -Name $Name }
elseif ($Cluster) { $vms = Get-Cluster -Name $Cluster | Get-VM }
else              { $vms = Get-VM }

foreach ($vm in ($vms | Where-Object { $_.PowerState -eq 'PoweredOff' })) {
    Write-Host "Powering on $($vm.Name) ..."
    Start-VM -VM $vm -Confirm:$false | Out-Null
    if ($DelaySeconds -gt 0) { Start-Sleep -Seconds $DelaySeconds }
}
