<#
.SYNOPSIS
    Exports VM notes and custom attribute values to CSV.
.DESCRIPTION
    Produces a documentation export of each VM's Notes field plus all non-empty
    custom attribute values.
.PARAMETER Path
    CSV output path (default .\VMAnnotations.csv).
.EXAMPLE
    PS> ./Export-VMAnnotations.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Path = '.\VMAnnotations.csv')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$rows = foreach ($vm in (Get-VM | Sort-Object Name)) {
    $attrs = Get-Annotation -Entity $vm | Where-Object { $_.Value }
    if ($attrs) {
        foreach ($a in $attrs) {
            [pscustomobject]@{ VM=$vm.Name; Notes=$vm.Notes; Attribute=$a.Name; Value=$a.Value }
        }
    } else {
        [pscustomobject]@{ VM=$vm.Name; Notes=$vm.Notes; Attribute=''; Value='' }
    }
}
$rows | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
Write-Host "Exported annotations for $((Get-VM).Count) VMs to $Path"
