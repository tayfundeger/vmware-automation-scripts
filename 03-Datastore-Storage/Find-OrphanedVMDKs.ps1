<#
.SYNOPSIS
    Finds orphaned VMDK descriptor files not attached to any VM.
.DESCRIPTION
    Enumerates VM disk descriptor files on each datastore and compares them
    against disks registered to VMs and templates. Files with no owner are
    reported as potential orphans. This script is READ-ONLY - always verify a
    result manually before deleting anything.
.PARAMETER Datastore
    Optional datastore name filter (wildcards allowed).
.EXAMPLE
    PS> ./Find-OrphanedVMDKs.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Datastore = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

# Build the set of VMDK paths that ARE in use (datastore-path form: "[DS] folder/disk.vmdk").
$used = New-Object System.Collections.Generic.HashSet[string]
Get-VM       | Get-HardDisk | ForEach-Object { [void]$used.Add($_.Filename) }
Get-Template | Get-HardDisk | ForEach-Object { [void]$used.Add($_.Filename) }

foreach ($ds in Get-Datastore -Name $Datastore) {
    $browser = Get-View -Id $ds.ExtensionData.Browser
    $spec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
    $spec.matchPattern = '*.vmdk'
    $spec.details = New-Object VMware.Vim.FileQueryFlags
    $spec.details.fileSize = $true
    # VmDiskFileQuery returns only descriptor .vmdk files (hides -flat/-delta).
    $spec.query = @( (New-Object VMware.Vim.VmDiskFileQuery) )

    try   { $results = $browser.SearchDatastoreSubFolders("[$($ds.Name)]", $spec) }
    catch { Write-Warning "Could not browse $($ds.Name): $($_.Exception.Message)"; continue }

    foreach ($folder in $results) {
        foreach ($file in $folder.File) {
            $path = "$($folder.FolderPath)$($file.Path)"
            if (-not $used.Contains($path)) {
                [pscustomobject]@{
                    Datastore = $ds.Name
                    Path      = $path
                    SizeGB    = [math]::Round($file.FileSize/1GB, 2)
                    Modified  = $file.Modification
                }
            }
        }
    }
}
