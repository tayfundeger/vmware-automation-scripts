<#
.SYNOPSIS
    Finds snapshots older than a threshold.
.DESCRIPTION
    Returns snapshots whose age exceeds -Days. Useful for hygiene reporting
    before cleanup.
.PARAMETER Days
    Age threshold in days (default 7).
.EXAMPLE
    PS> ./Get-OldSnapshots.ps1 -Days 14
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [int]$Days = 7
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$cutoff = (Get-Date).AddDays(-$Days)
Get-VM | Get-Snapshot | Where-Object { $_.Created -lt $cutoff } | Select-Object `
    @{N='VM';E={$_.VM.Name}}, Name,
    @{N='Created';E={$_.Created}},
    @{N='AgeDays';E={[math]::Round((New-TimeSpan -Start $_.Created -End (Get-Date)).TotalDays)}},
    @{N='SizeGB';E={[math]::Round($_.SizeGB,2)}} |
    Sort-Object AgeDays -Descending
