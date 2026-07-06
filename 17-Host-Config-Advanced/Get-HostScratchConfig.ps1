<#
.SYNOPSIS
    Reports the scratch location configuration per host.
.DESCRIPTION
    Shows the current and configured scratch locations. Hosts booting from SD/USB
    should have a persistent scratch location on shared/local VMFS.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-HostScratchConfig.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    $cur = Get-AdvancedSetting -Entity $h -Name 'ScratchConfig.CurrentScratchLocation'    -ErrorAction SilentlyContinue
    $cfg = Get-AdvancedSetting -Entity $h -Name 'ScratchConfig.ConfiguredScratchLocation' -ErrorAction SilentlyContinue
    [pscustomobject]@{
        VMHost     = $h.Name
        Current    = $cur.Value
        Configured = $cfg.Value
    }
}
