<#
.SYNOPSIS
    Reports the inventory folder path of each VM.
.DESCRIPTION
    Walks each VM's blue-folder hierarchy to produce its full logical path,
    handy for exporting inventory structure or auditing placement.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-VMFolderPath.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*', [string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

function Get-VMFolder($vm) {
    $parts = @()
    $f = $vm.Folder
    while ($f -and $f.Name -ne 'vm' -and $f.Name -ne 'Datacenters') {
        $parts = ,$f.Name + $parts
        $f = $f.Parent
    }
    '/' + ($parts -join '/')
}

$report = Get-VM -Name $Name | ForEach-Object {
    [pscustomobject]@{ VM = $_.Name; FolderPath = Get-VMFolder $_ }
} | Sort-Object FolderPath, VM

if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
