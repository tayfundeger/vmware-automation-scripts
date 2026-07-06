<#
.SYNOPSIS
    Consolidates VM disks for VMs flagged as needing it.
.DESCRIPTION
    Runs disk consolidation on VMs where ConsolidationNeeded is true (or on a
    specific VM). Supports -WhatIf.
.PARAMETER Name
    Optional specific VM name. If omitted, all flagged VMs are consolidated.
.EXAMPLE
    PS> ./Start-VMDiskConsolidation.ps1 -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Name
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if ($Name) { $targets = Get-VM -Name $Name -ErrorAction Stop }
else       { $targets = Get-VM | Where-Object { $_.ExtensionData.Runtime.ConsolidationNeeded } }

if (-not $targets) { Write-Host 'Nothing to consolidate.' -ForegroundColor Green; return }

foreach ($vm in $targets) {
    if ($PSCmdlet.ShouldProcess($vm.Name, 'Consolidate disks')) {
        $vm.ExtensionData.ConsolidateVMDisks()
        Write-Host "Consolidation started for $($vm.Name)."
    }
}
