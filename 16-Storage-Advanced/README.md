# 16 · Storage Advanced

Advanced storage administration: create/remove NFS & VMFS datastores, HBA rescans, iSCSI targets, VMFS version/properties, LUN mapping and path state.

**12 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `New-NFSDatastore.ps1` | Mount an NFS datastore on hosts (-WhatIf). |
| `New-VMFSDatastore.ps1` | Create a VMFS datastore on a LUN (-WhatIf). |
| `Remove-DatastoreSafely.ps1` | Remove a datastore only if empty (-WhatIf). |
| `Get-StorageAdapters.ps1` | HBAs per host (type/model/driver/status). |
| `Update-StorageAdapterRescan.ps1` | Rescan all HBAs + VMFS (-WhatIf). |
| `Get-iSCSIConfiguration.ps1` | iSCSI adapter IQN and configured targets. |
| `New-iSCSITarget.ps1` | Add a send/static iSCSI target (-WhatIf). |
| `Get-VMFSVersion.ps1` | VMFS major version per datastore. |
| `Get-DatastoreLUNMapping.ps1` | VMFS datastore to backing LUN canonical name. |
| `Get-ScsiDeviceInfo.ps1` | Disk LUNs per host (vendor/model/capacity). |
| `Get-StoragePathState.ps1` | Path state per LUN, detect dead paths (-DeadOnly). |
| `Get-VMFSProperties.ps1` | VMFS version, block size, UUID, capacity. |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-StoragePathState.ps1 -DeadOnly
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
