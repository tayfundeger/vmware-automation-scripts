# 13 · Advanced VM Operations

Reconfigure VMs in depth: hardware version, disks, NICs, ISO media, boot and advanced settings, in-guest command/file operations and resource limits.

**14 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Update-VMHardwareVersion.ps1` | Upgrade VM hardware/compatibility version (-WhatIf). |
| `New-VMHardDisk.ps1` | Add a virtual disk (size/format/datastore) (-WhatIf). |
| `Remove-VMHardDisk.ps1` | Detach a disk, optionally delete files (-WhatIf). |
| `Expand-VMHardDisk.ps1` | Grow a virtual disk (-WhatIf). |
| `New-VMNetworkAdapter.ps1` | Add a NIC on a port group (-WhatIf). |
| `Remove-VMNetworkAdapter.ps1` | Remove a NIC (-WhatIf). |
| `Set-VMCDDrive.ps1` | Mount an ISO or disconnect media (-WhatIf). |
| `Get-VMGuestDiskUsage.ps1` | Guest filesystem capacity/free (needs Tools). |
| `Set-VMBootOptions.ps1` | Set boot delay / enter firmware setup (-WhatIf). |
| `Set-VMAdvancedSetting.ps1` | Set a VM advanced (extraConfig) key (-WhatIf). |
| `Invoke-VMGuestCommand.ps1` | Run a command in the guest via Tools (-WhatIf). |
| `Copy-FileToGuest.ps1` | Upload a file into the guest via Tools (-WhatIf). |
| `Update-VMTools.ps1` | Upgrade VMware Tools, optional -NoReboot (-WhatIf). |
| `Set-VMResourceLimits.ps1` | Set CPU/memory reservations, limits, shares (-WhatIf). |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./New-VMHardDisk.ps1 -Name db01 -CapacityGB 100 -Format Thin
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
