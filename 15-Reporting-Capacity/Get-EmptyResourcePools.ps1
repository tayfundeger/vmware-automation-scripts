<#
.SYNOPSIS
    Finds resource pools that contain no VMs.
.DESCRIPTION
    Reports custom resource pools (excluding the hidden root "Resources" pool)
    that have zero VMs - candidates for cleanup.
.EXAMPLE
    PS> ./Get-EmptyResourcePools.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$empty = Get-ResourcePool | Where-Object { $_.Name -ne 'Resources' } | ForEach-Object {
    if ((Get-VM -Location $_).Count -eq 0) {
        [pscustomobject]@{ ResourcePool = $_.Name; Parent = $_.Parent.Name }
    }
}
if (-not $empty) { Write-Host 'No empty resource pools.'; return }
$empty | Sort-Object ResourcePool
