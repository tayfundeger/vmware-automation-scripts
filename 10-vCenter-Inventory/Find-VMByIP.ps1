<#
.SYNOPSIS
    Finds the VM that owns a given IP address.
.DESCRIPTION
    Searches guest-reported IP addresses (requires VMware Tools) to locate the VM
    matching the supplied IP.
.PARAMETER IPAddress
    IP address to search for.
.EXAMPLE
    PS> ./Find-VMByIP.ps1 -IPAddress 10.20.30.40
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$IPAddress)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$match = Get-VM | Where-Object { $_.Guest.IPAddress -contains $IPAddress }
if (-not $match) { Write-Host "No VM found with IP $IPAddress (guest must have Tools running)."; return }

$match | Select-Object Name, PowerState,
    @{N='GuestOS';E={$_.Guest.OSFullName}},
    @{N='AllIPs';E={($_.Guest.IPAddress) -join ', '}},
    @{N='VMHost';E={$_.VMHost.Name}}
