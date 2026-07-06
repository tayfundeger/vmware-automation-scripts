<#
.SYNOPSIS
    Summarizes VMs by configured guest OS.
.DESCRIPTION
    Groups all VMs by their configured guest operating system and reports the
    count of each - useful for OS lifecycle and licensing planning.
.EXAMPLE
    PS> ./Get-GuestOSReport.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM |
    Group-Object { $_.ExtensionData.Config.GuestFullName } |
    Select-Object @{N='GuestOS';E={$_.Name}}, Count |
    Sort-Object Count -Descending
