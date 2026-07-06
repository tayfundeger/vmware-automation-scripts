# 10 · vCenter & Inventory

vCenter server details, sessions, licensing, tasks, events and inventory lookups - plus finding VMs by IP/MAC and cleaning up orphaned objects.

**12 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-VCenterInfo.ps1` | vCenter version, build, API and instance UUID. |
| `Get-VISession.ps1` | Active vCenter sessions (user, IP, last active). |
| `Get-VILicense.ps1` | License products, editions and used vs. total capacity. |
| `Get-RecentTasks.ps1` | Recent tasks with state and initiating user (-FailedOnly). |
| `Get-VIEventReport.ps1` | Events over the last N days (optional text filter). |
| `Get-DatacenterInventory.ps1` | Cluster/host/VM/datastore counts per datacenter. |
| `Get-OrphanedVMs.ps1` | Orphaned, inaccessible or invalid VMs. |
| `Find-VMByIP.ps1` | Locate the VM owning a given guest IP. |
| `Find-VMByMAC.ps1` | Locate the VM owning a given MAC address. |
| `Get-VMHostInMaintenance.ps1` | Hosts currently in maintenance mode. |
| `Get-VIRoleUsage.ps1` | Roles cross-referenced with permission assignments. |
| `Stop-IdleVISession.ps1` | Terminate idle vCenter sessions (-WhatIf). |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-VCenterInfo.ps1
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
