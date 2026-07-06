<#
.SYNOPSIS
    Reports network adapters and IPs for each VM.
.DESCRIPTION
    Lists each VM network adapter with connected port group and MAC, plus guest
    IP addresses (requires VMware Tools for IP data).
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VMNetworkInfo.ps1 -Name web01
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM -Name $Name | ForEach-Object {
    $vm = $_
    Get-NetworkAdapter -VM $vm | Select-Object `
        @{N='VM';E={$vm.Name}}, Name, NetworkName, MacAddress, Type,
        @{N='Connected';E={$_.ConnectionState.Connected}},
        @{N='GuestIPs';E={($vm.Guest.IPAddress) -join ', '}}
}
