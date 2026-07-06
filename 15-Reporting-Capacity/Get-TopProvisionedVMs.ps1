<#
.SYNOPSIS
    Lists the largest VMs by provisioned storage.
.DESCRIPTION
    Returns the top N VMs ranked by total provisioned disk space, with used space
    and power state.
.PARAMETER Top
    Number of VMs to return (default 20).
.EXAMPLE
    PS> ./Get-TopProvisionedVMs.ps1 -Top 10
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([int]$Top = 20)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | Sort-Object ProvisionedSpaceGB -Descending | Select-Object -First $Top `
    Name,
    @{N='ProvisionedGB';E={[math]::Round($_.ProvisionedSpaceGB,1)}},
    @{N='UsedGB';E={[math]::Round($_.UsedSpaceGB,1)}},
    PowerState,
    @{N='VMHost';E={$_.VMHost.Name}}
