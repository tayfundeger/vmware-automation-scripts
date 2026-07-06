<#
.SYNOPSIS
    Reports VMware Tools status and version per VM.
.DESCRIPTION
    Lists each VM with Tools running status, installed version and whether the
    version is current or needs an upgrade.
.PARAMETER OutOfDateOnly
    Only return VMs whose Tools are not current.
.EXAMPLE
    PS> ./Get-VMToolsStatus.ps1 -OutOfDateOnly
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([switch]$OutOfDateOnly)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VM | Select-Object Name, PowerState,
    @{N='ToolsStatus';E={$_.ExtensionData.Guest.ToolsStatus}},
    @{N='ToolsVersion';E={$_.ExtensionData.Guest.ToolsVersion}},
    @{N='VersionStatus';E={$_.ExtensionData.Guest.ToolsVersionStatus2}}

if ($OutOfDateOnly) {
    $report = $report | Where-Object { $_.VersionStatus -and $_.VersionStatus -ne 'guestToolsCurrent' -and $_.VersionStatus -ne 'guestToolsUnmanaged' }
}
$report | Sort-Object Name
