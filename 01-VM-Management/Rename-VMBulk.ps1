<#
.SYNOPSIS
    Bulk-renames VM display names by pattern.
.DESCRIPTION
    Replaces a substring (or regex with -UseRegex) in the display name of every
    VM. This changes the inventory display name only, not the underlying files.
    Supports -WhatIf so you can preview changes safely.
.PARAMETER Match
    Text or regex pattern to find.
.PARAMETER Replace
    Replacement text.
.PARAMETER UseRegex
    Treat -Match as a regular expression.
.EXAMPLE
    PS> ./Rename-VMBulk.ps1 -Match "-old" -Replace "-legacy" -WhatIf
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Match,
    [Parameter(Mandatory)][string]$Replace,
    [switch]$UseRegex
)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM | ForEach-Object {
    $old = $_.Name
    $new = if ($UseRegex) { $old -replace $Match, $Replace } else { $old.Replace($Match, $Replace) }
    if ($new -ne $old) {
        if ($PSCmdlet.ShouldProcess($old, "Rename to '$new'")) {
            Set-VM -VM $_ -Name $new -Confirm:$false
        }
    }
}
