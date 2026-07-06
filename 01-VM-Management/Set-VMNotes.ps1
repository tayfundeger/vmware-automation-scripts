<#
.SYNOPSIS
    Sets or appends the Notes/annotation field on a VM.
.DESCRIPTION
    Overwrites the VM Notes field, or appends to it with -Append.
.PARAMETER Name
    VM name.
.PARAMETER Notes
    Text to set.
.PARAMETER Append
    Append to existing notes instead of overwriting.
.EXAMPLE
    PS> ./Set-VMNotes.ps1 -Name app01 -Notes "Owner: Web Team" -Append
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Notes,
    [switch]$Append
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$newNotes = if ($Append) { ("{0}`n{1}" -f $vm.Notes, $Notes).Trim() } else { $Notes }

if ($PSCmdlet.ShouldProcess($Name, 'Set notes')) {
    Set-VM -VM $vm -Notes $newNotes -Confirm:$false
}
