<#
.SYNOPSIS
    Lists all snapshots across the environment.
.DESCRIPTION
    Enumerates every snapshot on every VM with age, size and description.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-AllSnapshots.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string]$Path
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VM | Get-Snapshot | Select-Object `
    @{N='VM';E={$_.VM.Name}}, Name,
    @{N='Created';E={$_.Created}},
    @{N='AgeDays';E={[math]::Round((New-TimeSpan -Start $_.Created -End (Get-Date)).TotalDays)}},
    @{N='SizeGB';E={[math]::Round($_.SizeGB,2)}},
    @{N='PowerState';E={$_.PowerState}},
    Description |
    Sort-Object AgeDays -Descending

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path ($($report.Count) snapshots)." }
else       { $report }
