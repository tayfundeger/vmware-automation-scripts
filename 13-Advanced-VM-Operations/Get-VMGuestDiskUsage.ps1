<#
.SYNOPSIS
    Reports guest OS disk (filesystem) usage per VM.
.DESCRIPTION
    Uses VMware Tools guest disk data to report capacity, free space and percent
    free for each mounted guest filesystem. Requires Tools running.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.EXAMPLE
    PS> ./Get-VMGuestDiskUsage.ps1 -Name web01
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-VM -Name $Name | Where-Object { $_.PowerState -eq 'PoweredOn' } | ForEach-Object {
    $vm = $_
    $vm.ExtensionData.Guest.Disk | ForEach-Object {
        [pscustomobject]@{
            VM         = $vm.Name
            Mount      = $_.DiskPath
            CapacityGB = [math]::Round($_.Capacity/1GB,1)
            FreeGB     = [math]::Round($_.FreeSpace/1GB,1)
            PctFree    = if ($_.Capacity) { [math]::Round(($_.FreeSpace/$_.Capacity)*100,1) } else { 0 }
        }
    }
} | Sort-Object VM, Mount
