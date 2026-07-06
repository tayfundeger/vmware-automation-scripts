<#
.SYNOPSIS
    Sets CPU/memory reservations, limits and shares on a VM.
.DESCRIPTION
    Adjusts a VM's resource allocation (reservations, limits and shares level)
    via its resource configuration. Only the parameters you supply are changed.
    Supports -WhatIf.
.PARAMETER Name
    VM name.
.PARAMETER CpuReservationMhz
    CPU reservation in MHz.
.PARAMETER CpuLimitMhz
    CPU limit in MHz (-1 = unlimited).
.PARAMETER MemReservationMB
    Memory reservation in MB.
.PARAMETER MemLimitMB
    Memory limit in MB (-1 = unlimited).
.PARAMETER CpuShares
    CPU shares level: Low, Normal or High.
.PARAMETER MemShares
    Memory shares level: Low, Normal or High.
.EXAMPLE
    PS> ./Set-VMResourceLimits.ps1 -Name db01 -MemReservationMB 4096 -CpuShares High
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [int]$CpuReservationMhz,
    [int]$CpuLimitMhz,
    [int]$MemReservationMB,
    [int]$MemLimitMB,
    [ValidateSet('Low','Normal','High')][string]$CpuShares,
    [ValidateSet('Low','Normal','High')][string]$MemShares
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$rc = $vm | Get-VMResourceConfiguration

$p = @{ Confirm = $false }
if ($PSBoundParameters.ContainsKey('CpuReservationMhz')) { $p.CpuReservationMhz = $CpuReservationMhz }
if ($PSBoundParameters.ContainsKey('CpuLimitMhz'))       { $p.CpuLimitMhz       = $CpuLimitMhz }
if ($PSBoundParameters.ContainsKey('MemReservationMB'))  { $p.MemReservationMB  = $MemReservationMB }
if ($PSBoundParameters.ContainsKey('MemLimitMB'))        { $p.MemLimitMB        = $MemLimitMB }
if ($PSBoundParameters.ContainsKey('CpuShares'))         { $p.CpuSharesLevel    = $CpuShares }
if ($PSBoundParameters.ContainsKey('MemShares'))         { $p.MemSharesLevel    = $MemShares }

if ($p.Count -le 1) { Write-Warning 'Nothing to change. Specify at least one resource parameter.'; return }
if ($PSCmdlet.ShouldProcess($Name, 'Set resource limits/reservations/shares')) {
    $rc | Set-VMResourceConfiguration @p
}
