<#
.SYNOPSIS
    Runs a lightweight ESXi hardening check.
.DESCRIPTION
    Reports common hardening items per host: SSH service state, ESXi Shell state,
    shell warning suppression, lockdown mode and whether NTP is configured. This
    is a quick sanity check, not a full compliance benchmark.
.EXAMPLE
    PS> ./Get-ESXiComplianceCheck.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Sort-Object Name | ForEach-Object {
    $h    = $_
    $svc  = Get-VMHostService -VMHost $h
    $ssh  = ($svc | Where-Object { $_.Key -eq 'TSM-SSH' }).Running
    $shell= ($svc | Where-Object { $_.Key -eq 'TSM' }).Running
    $supp = (Get-AdvancedSetting -Entity $h -Name 'UserVars.SuppressShellWarning' -ErrorAction SilentlyContinue).Value
    [pscustomobject]@{
        Host             = $h.Name
        SSH_Running      = $ssh
        Shell_Running    = $shell
        ShellWarningSupp = ($supp -eq 1)
        LockdownMode     = $h.ExtensionData.Config.LockdownMode
        NTPConfigured    = ([bool](Get-VMHostNtpServer -VMHost $h))
    }
}
