<#
.SYNOPSIS
    Reconfigures CPU and/or memory of a VM.
.DESCRIPTION
    Updates vCPU count, cores-per-socket and/or memory. Most changes require the
    VM to be powered off unless CPU/Memory hot-add is enabled on the guest.
.PARAMETER Name
    VM name.
.PARAMETER NumCpu
    New total vCPU count.
.PARAMETER CoresPerSocket
    New cores-per-socket value.
.PARAMETER MemoryGB
    New memory size in GB.
.EXAMPLE
    PS> ./Set-VMResources.ps1 -Name db01 -NumCpu 8 -MemoryGB 32
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [int]$NumCpu,
    [int]$CoresPerSocket,
    [decimal]$MemoryGB
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$vm = Get-VM -Name $Name -ErrorAction Stop
$params = @{ VM = $vm; Confirm = $false }
if ($NumCpu)         { $params.NumCpu         = $NumCpu }
if ($CoresPerSocket) { $params.CoresPerSocket = $CoresPerSocket }
if ($MemoryGB)       { $params.MemoryGB       = $MemoryGB }

if ($params.Count -le 2) { Write-Warning 'Nothing to change. Specify -NumCpu, -CoresPerSocket or -MemoryGB.'; return }
if ($vm.PowerState -eq 'PoweredOn') { Write-Warning 'VM is powered on; changes may fail without hot-add enabled.' }

if ($PSCmdlet.ShouldProcess($Name, 'Reconfigure CPU/Memory')) {
    Set-VM @params
}
