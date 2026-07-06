<#
.SYNOPSIS
    Finds the VM that owns a given MAC address.
.DESCRIPTION
    Searches all VM network adapters for the supplied MAC address.
.PARAMETER MacAddress
    MAC address to search for (e.g. 00:50:56:aa:bb:cc).
.EXAMPLE
    PS> ./Find-VMByMAC.ps1 -MacAddress 00:50:56:aa:bb:cc
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$MacAddress)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$mac = $MacAddress.ToLower()
Get-VM | Get-NetworkAdapter | Where-Object { $_.MacAddress.ToLower() -eq $mac } |
    Select-Object @{N='VM';E={$_.Parent.Name}}, Name, MacAddress, NetworkName
