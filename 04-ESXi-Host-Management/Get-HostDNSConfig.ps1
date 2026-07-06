<#
.SYNOPSIS
    Reports DNS and hostname configuration for each host.
.DESCRIPTION
    Lists hostname, domain and configured DNS servers per host.
.EXAMPLE
    PS> ./Get-HostDNSConfig.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Sort-Object Name | ForEach-Object {
    $net = Get-VMHostNetwork -VMHost $_
    [pscustomobject]@{
        Host       = $_.Name
        HostName   = $net.HostName
        DomainName = $net.DomainName
        DNSServers = ($net.DnsAddress) -join ', '
    }
}
