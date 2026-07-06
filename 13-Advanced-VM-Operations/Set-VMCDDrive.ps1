<#
.SYNOPSIS
    Mounts or disconnects an ISO on a VM's CD/DVD drive.
.DESCRIPTION
    Attaches an ISO (datastore path) to the first CD drive, or disconnects the
    media with -Disconnect. Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER IsoPath
    Datastore ISO path, e.g. "[ISO_DS] linux/ubuntu.iso".
.PARAMETER Disconnect
    Remove any mounted media instead of attaching an ISO.
.EXAMPLE
    PS> ./Set-VMCDDrive.ps1 -Name app01 -IsoPath "[ISO_DS] tools/tools.iso"
.EXAMPLE
    PS> ./Set-VMCDDrive.ps1 -Name app01 -Disconnect
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [string]$IsoPath,
    [switch]$Disconnect
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$cd = Get-CDDrive -VM $vm | Select-Object -First 1
if (-not $cd) { Write-Warning "$Name has no CD/DVD drive."; return }

if ($Disconnect) {
    if ($PSCmdlet.ShouldProcess($Name, 'Disconnect CD media')) {
        Set-CDDrive -CD $cd -NoMedia -Confirm:$false
    }
} elseif ($IsoPath) {
    if ($PSCmdlet.ShouldProcess($Name, "Mount ISO $IsoPath")) {
        Set-CDDrive -CD $cd -IsoPath $IsoPath -Connected $true -Confirm:$false
    }
} else {
    Write-Warning 'Specify -IsoPath to mount, or -Disconnect to eject.'
}
