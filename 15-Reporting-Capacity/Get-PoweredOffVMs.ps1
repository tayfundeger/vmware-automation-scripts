<#
.SYNOPSIS
    Reports powered-off VMs and their reclaimable space.
.DESCRIPTION
    Lists all powered-off VMs with provisioned and used disk space - useful for
    identifying stale VMs that consume storage while doing nothing.
.EXAMPLE
    PS> ./Get-PoweredOffVMs.ps1 | Sort-Object UsedGB -Descending
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$off = Get-VM | Where-Object { $_.PowerState -eq 'PoweredOff' }
if (-not $off) { Write-Host 'No powered-off VMs.'; return }

$off | Select-Object Name,
    @{N='UsedGB';E={[math]::Round($_.UsedSpaceGB,1)}},
    @{N='ProvisionedGB';E={[math]::Round($_.ProvisionedSpaceGB,1)}},
    @{N='GuestOS';E={$_.ExtensionData.Config.GuestFullName}},
    @{N='Folder';E={$_.Folder.Name}} |
    Sort-Object UsedGB -Descending
