<#
.SYNOPSIS
    Reports memory overcommitment per cluster.
.DESCRIPTION
    Compares total allocated vRAM of powered-on VMs to physical RAM per cluster
    and reports the overcommitment ratio.
.EXAMPLE
    PS> ./Get-MemoryOvercommitment.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Cluster | Sort-Object Name | ForEach-Object {
    $hosts = Get-VMHost -Location $_
    $pram  = ($hosts | Measure-Object MemoryTotalGB -Sum).Sum
    $vram  = (Get-VM -Location $_ | Where-Object { $_.PowerState -eq 'PoweredOn' } | Measure-Object MemoryGB -Sum).Sum
    [pscustomobject]@{
        Cluster        = $_.Name
        Hosts          = $hosts.Count
        PhysicalRAM_GB = [math]::Round([double]$pram,1)
        AllocatedvRAM_GB = [math]::Round([double]$vram,1)
        Ratio          = if ($pram) { [math]::Round($vram / $pram, 2) } else { 0 }
    }
}
