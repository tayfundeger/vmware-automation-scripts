<#
.SYNOPSIS
    Reports VM density and vCPU:pCPU ratio per host.
.DESCRIPTION
    For each host shows total/powered-on VM counts, allocated vCPUs vs physical
    cores, and allocated vRAM vs physical RAM.
.EXAMPLE
    PS> ./Get-VMDensityPerHost.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Sort-Object Name | ForEach-Object {
    $vms = Get-VM -Location $_
    $on  = $vms | Where-Object { $_.PowerState -eq 'PoweredOn' }
    $vcpu = ($on | Measure-Object NumCpu -Sum).Sum
    $vram = ($on | Measure-Object MemoryGB -Sum).Sum
    [pscustomobject]@{
        VMHost        = $_.Name
        TotalVMs      = $vms.Count
        PoweredOnVMs  = $on.Count
        vCPU          = [int]$vcpu
        pCPU          = $_.NumCpu
        vCPUperCore   = if ($_.NumCpu) { [math]::Round($vcpu / $_.NumCpu, 2) } else { 0 }
        vRAM_GB       = [math]::Round([double]$vram,1)
        pRAM_GB       = [math]::Round($_.MemoryTotalGB,1)
    }
}
