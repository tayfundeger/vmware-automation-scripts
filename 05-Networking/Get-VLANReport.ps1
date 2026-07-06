<#
.SYNOPSIS
    Summarizes VLAN usage across port groups.
.DESCRIPTION
    Aggregates standard port groups by VLAN ID and lists the port groups mapped
    to each VLAN, helping spot inconsistencies or unused VLANs.
.EXAMPLE
    PS> ./Get-VLANReport.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VirtualPortGroup -Standard |
    Group-Object VLanId |
    Sort-Object { [int]$_.Name } |
    ForEach-Object {
        [pscustomobject]@{
            VLAN            = $_.Name
            PortGroupCount  = ($_.Group.Name | Select-Object -Unique).Count
            PortGroups      = ($_.Group.Name | Select-Object -Unique) -join ', '
        }
    }
