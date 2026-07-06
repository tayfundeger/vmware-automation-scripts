<#
.SYNOPSIS
    Rescans storage adapters and VMFS on hosts.
.DESCRIPTION
    Triggers a rescan of all HBAs and a VMFS rescan on each targeted host - run
    after presenting new LUNs. Supports -WhatIf.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed; default all).
.EXAMPLE
    PS> ./Update-StorageAdapterRescan.ps1 -VMHost esxi0*
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    if ($PSCmdlet.ShouldProcess($h.Name, 'Rescan all HBA + VMFS')) {
        Get-VMHostStorage -VMHost $h -RescanAllHba -RescanVmfs | Out-Null
        Write-Host "Rescanned $($h.Name)."
    }
}
