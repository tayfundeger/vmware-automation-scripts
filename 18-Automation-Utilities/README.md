# 18 · Automation Utilities & Bulk Operations

Automation helpers and bulk operations: multi-vCenter connect, CSV-driven VM creation, attribute and snapshot bulk edits, full inventory export and email reports.

**6 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Connect-MultipleVCenters.ps1` | Connect to several vCenters at once. |
| `New-VMsFromCSV.ps1` | Bulk-deploy VMs from a template via CSV (-WhatIf). |
| `Set-VMAttributesFromCSV.ps1` | Bulk-set notes/custom attributes via CSV (-WhatIf). |
| `Invoke-SnapshotFromCSV.ps1` | Bulk-create snapshots from a CSV list (-WhatIf). |
| `Export-FullInventory.ps1` | Export VMs/Hosts/Datastores/Clusters to CSVs. |
| `Send-VIReportEmail.ps1` | Email a plain-text vSphere health summary (-WhatIf). |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Export-FullInventory.ps1 -OutputFolder C:\Reports\Inv
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
