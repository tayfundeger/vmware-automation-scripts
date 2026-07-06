<#
.SYNOPSIS
    Removes a datastore only if it is empty.
.DESCRIPTION
    Verifies the datastore hosts no registered VMs, then unmounts/removes it.
    Aborts if any VMs are found. Supports -WhatIf.
.PARAMETER Name
    Datastore name.
.EXAMPLE
    PS> ./Remove-DatastoreSafely.ps1 -Name DS_OLD -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][string]$Name)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$ds = Get-Datastore -Name $Name -ErrorAction Stop
$vmCount = (Get-VM -Datastore $ds -ErrorAction SilentlyContinue).Count
if ($vmCount -gt 0) { Write-Warning "$Name still has $vmCount VM(s). Aborting."; return }

$h = Get-VMHost -Datastore $ds | Select-Object -First 1
if ($PSCmdlet.ShouldProcess($Name, 'Remove datastore')) {
    Remove-Datastore -Datastore $ds -VMHost $h -Confirm:$false
    Write-Host "Removed datastore $Name."
}
