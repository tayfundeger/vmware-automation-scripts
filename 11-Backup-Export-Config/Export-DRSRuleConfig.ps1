<#
.SYNOPSIS
    Exports DRS rules to CSV for backup.
.DESCRIPTION
    Captures every DRS VM-to-VM rule (cluster, name, type, enabled, member VMs)
    so rules can be documented or recreated after changes.
.PARAMETER Path
    CSV output path (default .\DRSRules.csv).
.EXAMPLE
    PS> ./Export-DRSRuleConfig.ps1 -Path C:\Backup\drs.csv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path = '.\DRSRules.csv')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$rows = foreach ($c in (Get-Cluster | Sort-Object Name)) {
    Get-DrsRule -Cluster $c | ForEach-Object {
        [pscustomobject]@{
            Cluster = $c.Name
            Name    = $_.Name
            Type    = $_.Type
            Enabled = $_.Enabled
            VMs     = (Get-VM -Id $_.VMIds -ErrorAction SilentlyContinue).Name -join ';'
        }
    }
}
if (-not $rows) { Write-Host 'No DRS rules found.'; return }
$rows | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($rows.Count) DRS rules to $Path"
