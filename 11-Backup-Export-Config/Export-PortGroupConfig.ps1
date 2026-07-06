<#
.SYNOPSIS
    Exports standard port group configuration to CSV.
.DESCRIPTION
    Documents each standard port group per host with its vSwitch, VLAN and
    security policy (promiscuous mode, forged transmits, MAC changes).
.PARAMETER Path
    CSV output path (default .\PortGroupConfig.csv).
.EXAMPLE
    PS> ./Export-PortGroupConfig.ps1 -Path C:\Backup\pg.csv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path = '.\PortGroupConfig.csv')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$rows = foreach ($h in (Get-VMHost | Sort-Object Name)) {
    foreach ($pg in (Get-VirtualPortGroup -VMHost $h -Standard)) {
        $sec = $pg | Get-SecurityPolicy
        [pscustomobject]@{
            VMHost           = $h.Name
            PortGroup        = $pg.Name
            vSwitch          = $pg.VirtualSwitchName
            VLAN             = $pg.VLanId
            AllowPromiscuous = $sec.AllowPromiscuous
            ForgedTransmits  = $sec.ForgedTransmits
            MacChanges       = $sec.MacChanges
        }
    }
}
$rows | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($rows.Count) port groups to $Path"
