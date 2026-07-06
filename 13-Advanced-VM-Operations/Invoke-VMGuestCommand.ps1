<#
.SYNOPSIS
    Runs a command inside a VM's guest OS.
.DESCRIPTION
    Executes a script/command in the guest via VMware Tools (Invoke-VMScript).
    Requires Tools running and valid guest credentials. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER ScriptText
    The command/script to run.
.PARAMETER GuestCredential
    Guest OS credentials (PSCredential).
.PARAMETER ScriptType
    Bash, PowerShell or Bat (default Bash).
.EXAMPLE
    PS> $cred = Get-Credential
    PS> ./Invoke-VMGuestCommand.ps1 -Name web01 -ScriptText "df -h" -GuestCredential $cred
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$ScriptText,
    [Parameter(Mandatory)][System.Management.Automation.PSCredential]$GuestCredential,
    [ValidateSet('Bash','PowerShell','Bat')][string]$ScriptType = 'Bash'
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
if ($vm.ExtensionData.Guest.ToolsRunningStatus -ne 'guestToolsRunning') { Write-Warning "$Name: VMware Tools not running."; return }

if ($PSCmdlet.ShouldProcess($Name, "Run guest $ScriptType command")) {
    Invoke-VMScript -VM $vm -ScriptText $ScriptText -GuestCredential $GuestCredential -ScriptType $ScriptType
}
