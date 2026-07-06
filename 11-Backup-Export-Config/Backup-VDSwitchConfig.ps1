<#
.SYNOPSIS
    Backs up distributed switch configuration to a zip file.
.DESCRIPTION
    Exports each vSphere Distributed Switch (VDS) to a native backup zip (into
    -OutputFolder) that can later be restored/imported. Supports -WhatIf.
.PARAMETER OutputFolder
    Destination folder (default .\VDSBackup).
.EXAMPLE
    PS> ./Backup-VDSwitchConfig.ps1 -OutputFolder C:\Backup\VDS
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ (VDS module) and an active Connect-VIServer session.
#>
[CmdletBinding(SupportsShouldProcess)]
param([string]$OutputFolder = '.\VDSBackup')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$switches = Get-VDSwitch -ErrorAction SilentlyContinue
if (-not $switches) { Write-Host 'No distributed switches found.'; return }
if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

foreach ($vds in $switches) {
    $file = Join-Path $OutputFolder ("{0}_{1:yyyyMMdd}.zip" -f ($vds.Name -replace '[\\/:*?"<>|]', '_'), (Get-Date))
    if ($PSCmdlet.ShouldProcess($vds.Name, "Export VDS backup to $file")) {
        Export-VDSwitch -VDSwitch $vds -Destination $file -Force
        Write-Host "Backed up $($vds.Name) -> $file"
    }
}
