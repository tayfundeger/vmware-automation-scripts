<#
.SYNOPSIS
    Mounts an NFS datastore on one or more hosts.
.DESCRIPTION
    Creates/mounts an NFS datastore pointing at a given server and export path on
    each specified host. Supports -WhatIf.
.PARAMETER Name
    Datastore name.
.PARAMETER NfsHost
    NFS server IP/hostname.
.PARAMETER Path
    Export path on the NFS server (e.g. /vol/nfs01).
.PARAMETER VMHost
    One or more host names to mount on.
.PARAMETER ReadOnly
    Mount read-only.
.EXAMPLE
    PS> ./New-NFSDatastore.ps1 -Name NFS01 -NfsHost 10.0.0.9 -Path /export/nfs01 -VMHost esxi01,esxi02
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$NfsHost,
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string[]]$VMHost,
    [switch]$ReadOnly
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($hn in $VMHost) {
    $h = Get-VMHost -Name $hn -ErrorAction SilentlyContinue
    if (-not $h) { Write-Warning "Host not found: $hn"; continue }
    if ($PSCmdlet.ShouldProcess($hn, "Mount NFS $NfsHost`:$Path as $Name")) {
        New-Datastore -VMHost $h -Nfs -Name $Name -NfsHost $NfsHost -Path $Path -ReadOnly:$ReadOnly
    }
}
