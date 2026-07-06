<#
.SYNOPSIS
    Reports uptime of powered-on VMs.
.DESCRIPTION
    Uses Runtime.BootTime to calculate how long each running VM has been up.
.EXAMPLE
    PS> ./Get-VMUptime.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' } | Select-Object Name,
    @{N='BootTime';  E={$_.ExtensionData.Runtime.BootTime}},
    @{N='UptimeDays';E={ if ($_.ExtensionData.Runtime.BootTime) { [math]::Round((New-TimeSpan -Start $_.ExtensionData.Runtime.BootTime -End (Get-Date)).TotalDays,1) } }} |
    Sort-Object UptimeDays -Descending
