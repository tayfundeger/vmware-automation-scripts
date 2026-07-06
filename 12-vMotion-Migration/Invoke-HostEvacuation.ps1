<#
.SYNOPSIS
    Migrates all powered-on VMs off a host.
.DESCRIPTION
    vMotions every powered-on VM from the source host to the other connected
    hosts in its cluster (round-robin), e.g. to prepare for maintenance on a
    cluster without fully-automated DRS. Supports -WhatIf.
.PARAMETER VMHost
    Source host to evacuate.
.EXAMPLE
    PS> ./Invoke-HostEvacuation.ps1 -VMHost esxi04 -WhatIf
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
$cluster = Get-Cluster -VMHost $h -ErrorAction SilentlyContinue
if (-not $cluster) { Write-Warning 'Host is not in a cluster; no evacuation targets.'; return }

$targets = Get-VMHost -Location $cluster | Where-Object { $_.Name -ne $h.Name -and $_.ConnectionState -eq 'Connected' }
if (-not $targets) { Write-Warning 'No other connected hosts in the cluster.'; return }

$vms = Get-VM -Location $h | Where-Object { $_.PowerState -eq 'PoweredOn' }
if (-not $vms) { Write-Host "$VMHost has no powered-on VMs."; return }

$i = 0
foreach ($vm in $vms) {
    $dest = $targets[$i % $targets.Count]; $i++
    if ($PSCmdlet.ShouldProcess($vm.Name, "vMotion to $($dest.Name)")) {
        Move-VM -VM $vm -Destination $dest | Out-Null
        Write-Host "Moved $($vm.Name) -> $($dest.Name)"
    }
}
