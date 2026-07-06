<#
.SYNOPSIS
    Lists all VM templates.
.DESCRIPTION
    Reports each template with guest OS, vCPU/memory sizing and the datastore(s)
    it lives on.
.EXAMPLE
    PS> ./Get-Templates.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$tpls = Get-Template
if (-not $tpls) { Write-Host 'No templates found.'; return }

$tpls | Select-Object Name,
    @{N='GuestOS';E={$_.ExtensionData.Config.GuestFullName}},
    @{N='NumCPU';E={$_.ExtensionData.Config.Hardware.NumCPU}},
    @{N='MemoryGB';E={[math]::Round($_.ExtensionData.Config.Hardware.MemoryMB/1024,1)}},
    @{N='Datastore';E={(Get-Datastore -RelatedObject $_).Name -join ', '}} |
    Sort-Object Name
