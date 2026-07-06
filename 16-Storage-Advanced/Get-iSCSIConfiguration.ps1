<#
.SYNOPSIS
    Reports iSCSI adapter and target configuration.
.DESCRIPTION
    For each host with an iSCSI HBA, lists the adapter IQN and its configured
    send/static targets.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-iSCSIConfiguration.ps1
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
    $hbas = Get-VMHostHba -VMHost $h -Type IScsi -ErrorAction SilentlyContinue
    foreach ($hba in $hbas) {
        $targets = Get-IScsiHbaTarget -IScsiHba $hba -ErrorAction SilentlyContinue
        if (-not $targets) {
            [pscustomobject]@{ VMHost=$h.Name; Adapter=$hba.Device; IQN=$hba.IScsiName; TargetType=''; Target='(none)' }
        }
        foreach ($t in $targets) {
            [pscustomobject]@{
                VMHost     = $h.Name
                Adapter    = $hba.Device
                IQN        = $hba.IScsiName
                TargetType = $t.Type
                Target     = "$($t.Address):$($t.Port)"
            }
        }
    }
}
