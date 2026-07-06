<#
.SYNOPSIS
    Reports the creation date of each VM.
.DESCRIPTION
    Reads Config.CreateDate (available on vSphere 6.7+). VMs created on older
    versions may show an empty value; for those, creation events would be needed.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-VMCreationDate.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [string]$Path
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VM | Select-Object Name,
    @{N='CreatedOn';E={$_.ExtensionData.Config.CreateDate}},
    @{N='AgeDays';  E={ if ($_.ExtensionData.Config.CreateDate) { [math]::Round((New-TimeSpan -Start $_.ExtensionData.Config.CreateDate -End (Get-Date)).TotalDays) } }} |
    Sort-Object CreatedOn

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
