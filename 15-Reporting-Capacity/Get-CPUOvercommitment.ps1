<#
.SYNOPSIS
    Reports CPU overcommitment per cluster.
.DESCRIPTION
    Compares total allocated vCPUs of powered-on VMs to physical cores per
    cluster and reports the overcommitment ratio.
.EXAMPLE
    PS> ./Get-CPUOvercommitment.ps1
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
    $pcpu  = ($hosts | Measure-Object NumCpu -Sum).Sum
    $vcpu  = (Get-VM -Location $_ | Where-Object { $_.PowerState -eq 'PoweredOn' } | Measure-Object NumCpu -Sum).Sum
    [pscustomobject]@{
        Cluster       = $_.Name
        Hosts         = $hosts.Count
        PhysicalCores = [int]$pcpu
        AllocatedvCPU = [int]$vcpu
        Ratio         = if ($pcpu) { [math]::Round($vcpu / $pcpu, 2) } else { 0 }
    }
}
