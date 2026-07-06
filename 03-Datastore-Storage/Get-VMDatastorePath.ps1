<#
.SYNOPSIS
    Shows the datastore path and datastores used by each VM.
.DESCRIPTION
    Reports the .vmx path (VmPathName) and the list of datastores each VM
    occupies.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VMDatastorePath.ps1 -Name app01
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM -Name $Name | Select-Object Name,
    @{N='VmxPath';E={$_.ExtensionData.Config.Files.VmPathName}},
    @{N='Datastores';E={ (Get-Datastore -RelatedObject $_).Name -join ', ' }} |
    Sort-Object Name
