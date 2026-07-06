<#
.SYNOPSIS
    Reports custom attribute definitions and VM values.
.DESCRIPTION
    Lists custom attribute definitions, then reports any non-empty custom
    attribute values set on VMs.
.EXAMPLE
    PS> ./Get-CustomAttributes.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Write-Host "=== Custom Attribute Definitions ===" -ForegroundColor Cyan
Get-CustomAttribute | Select-Object Name, TargetType | Sort-Object TargetType, Name | Format-Table -AutoSize

Write-Host "=== VM Custom Attribute Values (non-empty) ===" -ForegroundColor Cyan
Get-VM | ForEach-Object {
    $vm = $_
    Get-Annotation -Entity $vm | Where-Object { $_.Value } |
        Select-Object @{N='VM';E={$vm.Name}}, @{N='Attribute';E={$_.Name}}, Value
} | Sort-Object VM, Attribute
