<#
.SYNOPSIS
    Reports vCenter/ESXi license usage.
.DESCRIPTION
    Uses the LicenseManager to list each license: product name, edition, total
    vs. used capacity and the (masked) license key.
.EXAMPLE
    PS> ./Get-VILicense.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$si = Get-View ServiceInstance
$lm = Get-View $si.Content.LicenseManager
$lm.Licenses | Select-Object `
    Name, EditionKey,
    @{N='Used';E={$_.Used}},
    @{N='Total';E={ if ($_.Total -eq 0) { 'Unlimited' } else { $_.Total } }},
    @{N='LicenseKey';E={$_.LicenseKey}} |
    Sort-Object Name
