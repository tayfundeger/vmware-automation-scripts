<#
.SYNOPSIS
    Exports each VM's configuration to a JSON file.
.DESCRIPTION
    Writes one JSON file per VM (into -OutputFolder) capturing key configuration:
    CPU, memory, hardware version, guest OS, notes, disks and network adapters.
    Useful as a lightweight documentation/backup of VM settings.
.PARAMETER Name
    Optional VM name filter (wildcards allowed).
.PARAMETER OutputFolder
    Destination folder for the JSON files (default .\VMConfigs).
.EXAMPLE
    PS> ./Export-VMConfig.ps1 -OutputFolder C:\Backup\VMConfigs
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Name = '*', [string]$OutputFolder = '.\VMConfigs')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

foreach ($vm in (Get-VM -Name $Name)) {
    $cfg = [ordered]@{
        Name            = $vm.Name
        PowerState      = "$($vm.PowerState)"
        NumCpu          = $vm.NumCpu
        CoresPerSocket  = $vm.CoresPerSocket
        MemoryGB        = $vm.MemoryGB
        HardwareVersion = $vm.HardwareVersion
        GuestOS         = $vm.ExtensionData.Config.GuestFullName
        Notes           = $vm.Notes
        Folder          = $vm.Folder.Name
        ResourcePool    = $vm.ResourcePool.Name
        Disks   = @(Get-HardDisk -VM $vm | ForEach-Object {
                    [ordered]@{ Name=$_.Name; CapacityGB=[math]::Round($_.CapacityGB,2); Format="$($_.StorageFormat)"; File=$_.Filename } })
        Nics    = @(Get-NetworkAdapter -VM $vm | ForEach-Object {
                    [ordered]@{ Name=$_.Name; Network=$_.NetworkName; Mac=$_.MacAddress; Type="$($_.Type)" } })
    }
    $file = Join-Path $OutputFolder ("{0}.json" -f ($vm.Name -replace '[\\/:*?"<>|]', '_'))
    $cfg | ConvertTo-Json -Depth 5 | Out-File -FilePath $file -Encoding UTF8
    Write-Host "Exported $($vm.Name) -> $file"
}
