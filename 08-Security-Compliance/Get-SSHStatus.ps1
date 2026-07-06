<#
.SYNOPSIS
    Reports SSH service state on all hosts.
.DESCRIPTION
    Lists whether the SSH (TSM-SSH) service is running and its startup policy on
    every host - SSH left running is a common audit finding.
.EXAMPLE
    PS> ./Get-SSHStatus.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VMHost | Sort-Object Name | ForEach-Object {
    $h   = $_
    $ssh = Get-VMHostService -VMHost $h | Where-Object { $_.Key -eq 'TSM-SSH' }
    [pscustomobject]@{
        Host        = $h.Name
        SSH_Running = $ssh.Running
        StartPolicy = $ssh.Policy
    }
}
