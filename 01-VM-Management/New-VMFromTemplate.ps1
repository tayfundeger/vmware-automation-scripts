<#
.SYNOPSIS
    Deploys a new VM from an existing template.
.DESCRIPTION
    Wraps New-VM to deploy from a template with optional folder placement and
    guest OS customization. Supports -WhatIf.
.PARAMETER Name
    Name of the new virtual machine.
.PARAMETER Template
    Source template name.
.PARAMETER Datastore
    Target datastore or datastore cluster.
.PARAMETER VMHost
    Target ESXi host.
.PARAMETER Folder
    Optional destination VM folder.
.PARAMETER OSCustomizationSpec
    Optional OS customization specification name.
.EXAMPLE
    PS> ./New-VMFromTemplate.ps1 -Name web01 -Template W2022-Tpl -Datastore DS01 -VMHost esxi01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Template,
    [Parameter(Mandatory)][string]$Datastore,
    [Parameter(Mandatory)][string]$VMHost,
    [string]$Folder,
    [string]$OSCustomizationSpec
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$params = @{
    Name      = $Name
    Template  = (Get-Template -Name $Template -ErrorAction Stop)
    Datastore = (Get-Datastore -Name $Datastore -ErrorAction Stop)
    VMHost    = (Get-VMHost -Name $VMHost -ErrorAction Stop)
}
if ($Folder)              { $params.Location            = (Get-Folder -Name $Folder -ErrorAction Stop) }
if ($OSCustomizationSpec) { $params.OSCustomizationSpec = (Get-OSCustomizationSpec -Name $OSCustomizationSpec -ErrorAction Stop) }

if ($PSCmdlet.ShouldProcess($Name, "Deploy from template '$Template'")) {
    New-VM @params
}
