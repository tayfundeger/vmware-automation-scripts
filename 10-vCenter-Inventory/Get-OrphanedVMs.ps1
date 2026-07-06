<#
.SYNOPSIS
    Finds orphaned, inaccessible or invalid VMs.
.DESCRIPTION
    Reports VMs whose runtime connection state is not "connected" - typically
    orphaned entries after host failures or datastore loss that need cleanup.
.EXAMPLE
    PS> ./Get-OrphanedVMs.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$bad = Get-VM | Where-Object { $_.ExtensionData.Runtime.ConnectionState -ne 'connected' }
if (-not $bad) { Write-Host 'No orphaned/inaccessible VMs found.' -ForegroundColor Green; return }

$bad | Select-Object Name,
    @{N='ConnectionState';E={$_.ExtensionData.Runtime.ConnectionState}},
    @{N='VMHost';E={$_.VMHost.Name}},
    PowerState
