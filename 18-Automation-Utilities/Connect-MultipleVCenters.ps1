<#
.SYNOPSIS
    Connects to multiple vCenter servers at once.
.DESCRIPTION
    Connects to a list of vCenter servers using the same credentials and reports
    the resulting sessions. Useful before running cross-vCenter reports.
.PARAMETER Server
    One or more vCenter server names/IPs.
.PARAMETER Credential
    Optional credentials (PSCredential). If omitted you will be prompted / SSO used.
.EXAMPLE
    PS> ./Connect-MultipleVCenters.ps1 -Server vc01,vc02,vc03 -Credential (Get-Credential)
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string[]]$Server,
    [System.Management.Automation.PSCredential]$Credential
)

$p = @{ Server = $Server }
if ($Credential) { $p.Credential = $Credential }

Connect-VIServer @p | Select-Object Name, Version, Build, User, IsConnected
