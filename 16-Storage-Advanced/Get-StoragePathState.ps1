<#
.SYNOPSIS
    Reports storage path state for each LUN (detects dead paths).
.DESCRIPTION
    Enumerates every path to each disk LUN per host and reports its state
    (Active/Standby/Dead/Disabled). Filter for Dead to find connectivity issues.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.PARAMETER DeadOnly
    Only return paths that are not Active.
.EXAMPLE
    PS> ./Get-StoragePathState.ps1 -DeadOnly
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$VMHost = '*', [switch]$DeadOnly)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$rows = foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    foreach ($lun in (Get-ScsiLun -VmHost $h -LunType disk -ErrorAction SilentlyContinue)) {
        Get-ScsiLunPath -ScsiLun $lun | ForEach-Object {
            [pscustomobject]@{
                VMHost    = $h.Name
                LUN       = $lun.CanonicalName
                Path      = $_.Name
                State     = $_.State
                Preferred = $_.Preferred
            }
        }
    }
}
if ($DeadOnly) { $rows = $rows | Where-Object { $_.State -ne 'Active' } }
$rows
