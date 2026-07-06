# 12 · vMotion & Migration

Move workloads around: storage vMotion, host and datastore evacuation, cluster/pool/folder moves, CSV-driven bulk migration and DRS recommendations.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Move-VMDatastore.ps1` | Storage vMotion a VM (optional disk format) (-WhatIf). |
| `Move-VMToDatastoreCluster.ps1` | Storage vMotion into an SDRS cluster (-WhatIf). |
| `Invoke-HostEvacuation.ps1` | vMotion all powered-on VMs off a host (-WhatIf). |
| `Invoke-DatastoreEvacuation.ps1` | Storage vMotion all VMs off a datastore (-WhatIf). |
| `Move-VMsBulkByCSV.ps1` | CSV-driven bulk compute/storage migration (-WhatIf). |
| `Move-VMToCluster.ps1` | Migrate a VM to another cluster (-WhatIf). |
| `Move-VMToResourcePool.ps1` | Move a VM into a resource pool (-WhatIf). |
| `Move-VMToFolder.ps1` | Move a VM to another inventory folder (-WhatIf). |
| `Get-VMotionHistory.ps1` | Recent vMotion/migration events. |
| `Get-DRSRecommendations.ps1` | List or apply pending DRS recommendations (-WhatIf). |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Invoke-HostEvacuation.ps1 -VMHost esxi04 -WhatIf
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
