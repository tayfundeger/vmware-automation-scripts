<#
.SYNOPSIS
    Copies a local file into a VM's guest OS.
.DESCRIPTION
    Uploads a file from the machine running PowerCLI into the guest via VMware
    Tools (Copy-VMGuestFile). Requires Tools running and guest credentials.
    Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER Source
    Local source file path.
.PARAMETER Destination
    Destination path inside the guest.
.PARAMETER GuestCredential
    Guest OS credentials (PSCredential).
.EXAMPLE
    PS> ./Copy-FileToGuest.ps1 -Name web01 -Source C:\setup.sh -Destination /tmp/setup.sh -GuestCredential (Get-Credential)
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Source,
    [Parameter(Mandatory)][string]$Destination,
    [Parameter(Mandatory)][System.Management.Automation.PSCredential]$GuestCredential
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }
if (-not (Test-Path $Source)) { Write-Warning "Source not found: $Source"; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
if ($PSCmdlet.ShouldProcess($Name, "Copy $Source -> $Destination")) {
    Copy-VMGuestFile -VM $vm -Source $Source -Destination $Destination -LocalToGuest -GuestCredential $GuestCredential -Force
}
