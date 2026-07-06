<#
.SYNOPSIS
    Finds port groups with no VMs connected.
.DESCRIPTION
    Compares all standard and distributed port groups against the networks
    actually used by VM adapters and reports port groups that appear unused -
    candidates for cleanup.
.EXAMPLE
    PS> ./Get-UnusedPortGroups.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

# Networks actually in use by VMs
$used = New-Object System.Collections.Generic.HashSet[string]
Get-VM | Get-NetworkAdapter | ForEach-Object { if ($_.NetworkName) { [void]$used.Add($_.NetworkName) } }

$std = Get-VirtualPortGroup -Standard | Select-Object -ExpandProperty Name -Unique
$vds = @()
if (Get-VDSwitch -ErrorAction SilentlyContinue) {
    $vds = Get-VDPortgroup | Where-Object { -not $_.IsUplink } | Select-Object -ExpandProperty Name -Unique
}

@($std + $vds | Select-Object -Unique) | Where-Object { -not $used.Contains($_) } |
    ForEach-Object { [pscustomobject]@{ PortGroup = $_; Status = 'No VMs connected' } }
