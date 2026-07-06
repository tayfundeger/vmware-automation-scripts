<#
.SYNOPSIS
    Emails a plain-text vSphere health summary.
.DESCRIPTION
    Builds a concise plain-text summary (host and VM counts, low-space datastores,
    triggered alarm count) and sends it via SMTP. Supports -WhatIf.
.PARAMETER SmtpServer
    SMTP server host.
.PARAMETER From
    Sender address.
.PARAMETER To
    One or more recipient addresses.
.PARAMETER Subject
    Email subject (default includes the vCenter name).
.PARAMETER Port
    SMTP port (default 25).
.PARAMETER Credential
    Optional SMTP credentials.
.PARAMETER UseSsl
    Use SSL/TLS for the SMTP connection.
.EXAMPLE
    PS> ./Send-VIReportEmail.ps1 -SmtpServer smtp.lab.local -From vcenter@lab.local -To ops@lab.local
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$SmtpServer,
    [Parameter(Mandatory)][string]$From,
    [Parameter(Mandatory)][string[]]$To,
    [string]$Subject,
    [int]$Port = 25,
    [System.Management.Automation.PSCredential]$Credential,
    [switch]$UseSsl
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vc      = $global:DefaultVIServer.Name
$hosts   = Get-VMHost
$vms     = Get-VM
$lowDs   = Get-Datastore | Where-Object { $_.CapacityGB -and (($_.FreeSpaceGB / $_.CapacityGB) -lt 0.10) }
$alarms  = 0
foreach ($e in (@(Get-VMHost) + @(Get-Cluster) + @(Get-Datastore))) { $alarms += @($e.ExtensionData.TriggeredAlarmState).Count }

if (-not $Subject) { $Subject = "vSphere daily summary - $vc - $(Get-Date -Format 'yyyy-MM-dd')" }

$lines = @()
$lines += "vSphere summary for $vc"
$lines += "Generated: $(Get-Date)"
$lines += ""
$lines += "Hosts total       : $($hosts.Count)"
$lines += "Hosts connected   : $(($hosts | Where-Object { $_.ConnectionState -eq 'Connected' }).Count)"
$lines += "VMs total         : $($vms.Count)"
$lines += "VMs powered on    : $(($vms | Where-Object { $_.PowerState -eq 'PoweredOn' }).Count)"
$lines += "Triggered alarms  : $alarms"
$lines += ""
$lines += "Datastores below 10% free:"
if ($lowDs) { foreach ($d in $lowDs) { $lines += "  - $($d.Name): $([math]::Round(($d.FreeSpaceGB/$d.CapacityGB)*100,1))% free" } }
else        { $lines += "  (none)" }
$body = $lines -join "`n"

$mail = @{ SmtpServer = $SmtpServer; From = $From; To = $To; Subject = $Subject; Body = $body; Port = $Port }
if ($Credential) { $mail.Credential = $Credential }
if ($UseSsl)     { $mail.UseSsl = $true }

if ($PSCmdlet.ShouldProcess(($To -join ', '), 'Send vSphere summary email')) {
    Send-MailMessage @mail
    Write-Host "Report sent to $($To -join ', ')."
}
