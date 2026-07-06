<#
.SYNOPSIS
    Reports a specific advanced setting across all hosts.
.DESCRIPTION
    Retrieves an advanced host setting (by name or wildcard) for every host, so
    you can audit settings such as Syslog.global.logHost or
    UserVars.SuppressShellWarning consistently.
.PARAMETER Name
    Advanced setting name or wildcard pattern.
.PARAMETER VMHost
    Optional host name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-HostAdvancedSetting.ps1 -Name UserVars.SuppressShellWarning
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Name,
    [string]$VMHost = '*'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($h in (Get-VMHost -Name $VMHost | Sort-Object Name)) {
    Get-AdvancedSetting -Entity $h -Name $Name |
        Select-Object @{N='VMHost';E={$h.Name}}, Name, Value
}
