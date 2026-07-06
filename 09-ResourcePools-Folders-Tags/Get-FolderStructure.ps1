<#
.SYNOPSIS
    Reports the VM folder hierarchy.
.DESCRIPTION
    Lists every VM folder with its full inventory path and the number of VMs
    directly contained in it.
.EXAMPLE
    PS> ./Get-FolderStructure.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

function Get-FolderPath($folder) {
    $parts = @()
    $f = $folder
    while ($f -and $f.Name -ne 'vm' -and $f.Name -ne 'Datacenters') {
        $parts = ,$f.Name + $parts
        $f = $f.Parent
    }
    '/' + ($parts -join '/')
}

Get-Folder -Type VM | Sort-Object Name | ForEach-Object {
    [pscustomobject]@{
        Folder = $_.Name
        Path   = Get-FolderPath $_
        VMs    = (Get-VM -Location $_ -NoRecursion -ErrorAction SilentlyContinue).Count
    }
}
