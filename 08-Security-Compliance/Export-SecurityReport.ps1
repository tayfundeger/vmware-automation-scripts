<#
.SYNOPSIS
    Exports a consolidated per-host security posture report.
.DESCRIPTION
    Combines lockdown mode, SSH/Shell state, shell warning suppression and NTP
    configuration into a single report and writes it to CSV (or the pipeline).
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Export-SecurityReport.ps1 -Path C:\Reports\security.csv
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VMHost | Sort-Object Name | ForEach-Object {
    $h   = $_
    $svc = Get-VMHostService -VMHost $h
    [pscustomobject]@{
        Host             = $h.Name
        LockdownMode     = $h.ExtensionData.Config.LockdownMode
        SSH_Running      = ($svc | Where-Object { $_.Key -eq 'TSM-SSH' }).Running
        Shell_Running    = ($svc | Where-Object { $_.Key -eq 'TSM' }).Running
        ShellWarningSupp = ((Get-AdvancedSetting -Entity $h -Name 'UserVars.SuppressShellWarning' -ErrorAction SilentlyContinue).Value -eq 1)
        NTPConfigured    = ([bool](Get-VMHostNtpServer -VMHost $h))
        Version          = $h.Version
        Build            = $h.Build
    }
}

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
