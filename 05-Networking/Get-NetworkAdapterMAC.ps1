<#
.SYNOPSIS
    Reports MAC addresses for all VM network adapters.
.DESCRIPTION
    Produces a flat list of VM / adapter / MAC / network for MAC auditing or
    duplicate-MAC investigation.
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-NetworkAdapterMAC.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$report = Get-VM | ForEach-Object {
    $vm = $_
    Get-NetworkAdapter -VM $vm | Select-Object @{N='VM';E={$vm.Name}}, Name, MacAddress, NetworkName
} | Sort-Object MacAddress

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
