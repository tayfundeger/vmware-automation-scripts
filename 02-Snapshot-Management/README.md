# 02 · Snapshot Management

Find, create, report on and clean up snapshots, plus detect and fix VMs needing disk consolidation.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-AllSnapshots.ps1` | List every snapshot with age, size and description. |
| `Get-OldSnapshots.ps1` | Snapshots older than N days. |
| `Remove-OldSnapshots.ps1` | Delete snapshots older than N days (-WhatIf). |
| `New-SnapshotBulk.ps1` | Create a named snapshot across VMs/cluster (pre-patch). |
| `Get-SnapshotSizeReport.ps1` | Snapshot space consumed per VM plus grand total. |
| `Remove-AllSnapshotsForVM.ps1` | Remove all snapshots for one VM (-WhatIf). |
| `Get-SnapshotTree.ps1` | Indented snapshot hierarchy for a VM. |
| `Get-SnapshotCreator.ps1` | Who created snapshots (from vCenter task events). |
| `Get-VMsNeedingConsolidation.ps1` | VMs flagged as needing disk consolidation. |
| `Start-VMDiskConsolidation.ps1` | Consolidate disks for flagged VMs (-WhatIf). |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Remove-OldSnapshots.ps1 -Days 30 -WhatIf
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
