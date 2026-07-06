# VMware PowerCLI Automation Scripts

A curated collection of **100 production-ready VMware PowerCLI scripts** covering the
tasks a virtualization administrator runs most often: VM lifecycle, snapshots,
storage, ESXi hosts, networking, clusters (DRS/HA), performance, security and
inventory (resource pools, folders, templates, tags).

Every script is standalone, documented with PowerShell **comment-based help**
(`Get-Help ./Script.ps1 -Full`), returns objects you can pipe or export to CSV, and
guards against running without an active vCenter connection. Scripts that change
state support **`-WhatIf`** so you can preview before applying.

> **Looking for detailed articles, guides and explanations for these scripts?**  
> Visit **[www.tayfundeger.com](https://www.tayfundeger.com)**.

---

## Requirements

- **VMware PowerCLI 12 or later** (works on Windows PowerShell 5.1 and PowerShell 7)
  ```powershell
  Install-Module VMware.PowerCLI -Scope CurrentUser
  ```
- An active connection to a vCenter Server or ESXi host:
  ```powershell
  Connect-VIServer -Server vcenter.example.com
  ```
- Appropriate vSphere privileges for the action being performed.

> Optional (silences certificate prompts in lab environments):
> ```powershell
> Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
> ```

---

## How to use

1. Connect to vCenter with `Connect-VIServer`.
2. Run any script directly, e.g.:
   ```powershell
   ./01-VM-Management/Get-VMInventory.ps1
   ./01-VM-Management/Get-VMInventory.ps1 -Path C:\Reports\vms.csv
   ```
3. Read a script's help at any time:
   ```powershell
   Get-Help ./03-Datastore-Storage/Find-OrphanedVMDKs.ps1 -Full
   ```
4. For scripts that make changes, preview first with `-WhatIf`:
   ```powershell
   ./02-Snapshot-Management/Remove-OldSnapshots.ps1 -Days 30 -WhatIf
   ```

### Safety conventions

| Convention | Meaning |
|---|---|
| Connection guard | Each script stops with a warning if no `Connect-VIServer` session is active. |
| `-WhatIf` / `SupportsShouldProcess` | All state-changing scripts support previewing and confirmation. |
| Read-only by default | Reporting scripts never modify the environment. `Find-OrphanedVMDKs` only reports. |
| Object output | Scripts emit objects — pipe to `Format-Table`, `Export-Csv`, `Out-GridView`, etc. |

---

## Script catalog

### 01 · VM Management
| Script | Description |
|---|---|
| `Get-VMInventory.ps1` | Full VM inventory (CPU, RAM, disk, OS, host, cluster, Tools). |
| `New-VMFromTemplate.ps1` | Deploy a new VM from a template (optional folder & customization). |
| `New-VMClone.ps1` | Clone an existing VM to a target host/datastore. |
| `Remove-VMSafely.ps1` | Remove VM(s) with guard rails (refuses powered-on, `-WhatIf`). |
| `Start-VMsBulk.ps1` | Bulk power-on by name or cluster, with optional stagger delay. |
| `Stop-VMsBulk.ps1` | Bulk graceful guest shutdown (`-Force` for hard power off). |
| `Restart-VMGuest.ps1` | Graceful guest OS restart via VMware Tools. |
| `Set-VMResources.ps1` | Reconfigure vCPU / cores-per-socket / memory. |
| `Get-VMPowerState.ps1` | Power-state list plus a summary count. |
| `Move-VMToHost.ps1` | vMotion a VM to a specified host. |
| `Get-VMsByHost.ps1` | List VMs grouped by their ESXi host. |
| `Set-VMNotes.ps1` | Set or append the VM Notes/annotation field. |
| `Get-VMCreationDate.ps1` | Report VM creation date and age (vSphere 6.7+). |
| `Get-VMUptime.ps1` | Uptime of powered-on VMs from BootTime. |
| `Rename-VMBulk.ps1` | Bulk-rename VM display names by pattern (`-WhatIf`). |

### 02 · Snapshot Management
| Script | Description |
|---|---|
| `Get-AllSnapshots.ps1` | List every snapshot with age, size and description. |
| `Get-OldSnapshots.ps1` | Snapshots older than N days. |
| `Remove-OldSnapshots.ps1` | Delete snapshots older than N days (`-WhatIf`). |
| `New-SnapshotBulk.ps1` | Create a named snapshot across VMs/cluster (pre-patch). |
| `Get-SnapshotSizeReport.ps1` | Snapshot space consumed per VM plus grand total. |
| `Remove-AllSnapshotsForVM.ps1` | Remove all snapshots for one VM (`-WhatIf`). |
| `Get-SnapshotTree.ps1` | Indented snapshot hierarchy for a VM. |
| `Get-SnapshotCreator.ps1` | Who created snapshots (from vCenter task events). |
| `Get-VMsNeedingConsolidation.ps1` | VMs flagged as needing disk consolidation. |
| `Start-VMDiskConsolidation.ps1` | Consolidate disks for flagged VMs (`-WhatIf`). |

### 03 · Datastore & Storage
| Script | Description |
|---|---|
| `Get-DatastoreUsage.ps1` | Capacity, free, used and percent-free per datastore. |
| `Get-DatastoreVMs.ps1` | VMs residing on each datastore. |
| `Find-OrphanedVMDKs.ps1` | Detect orphaned VMDK descriptors (read-only). |
| `Get-ThinProvisionedVMs.ps1` | VMs with thin-provisioned disks. |
| `Get-DatastoreClusterInfo.ps1` | Datastore cluster (SDRS) config and capacity. |
| `Get-VMDiskUsage.ps1` | Per-VM virtual disk details. |
| `Get-LargestVMDKs.ps1` | Top-N largest virtual disks. |
| `Get-DatastoreCapacityAlert.ps1` | Datastores below a free-space threshold. |
| `Get-DatastoreMultipathing.ps1` | SCSI LUN multipath policy per host. |
| `Get-VMDatastorePath.ps1` | VMX path and datastores used per VM. |
| `Get-DatastoreOverProvisioning.ps1` | Thin over-commit ratio per datastore. |
| `Test-DatastoreConnectivity.ps1` | Datastore mount/accessibility per host. |

### 04 · ESXi Host Management
| Script | Description |
|---|---|
| `Get-HostInventory.ps1` | Host inventory: version, build, vendor, uptime, VM count. |
| `Get-HostHardware.ps1` | CPU model, sockets/cores/threads, RAM, service tag. |
| `Set-HostMaintenanceMode.ps1` | Enter/exit maintenance mode (`-Exit`, `-WhatIf`). |
| `Get-HostServices.ps1` | Host service states and startup policies. |
| `Restart-HostService.ps1` | Restart a service (e.g. SSH, ntpd) across hosts (`-WhatIf`). |
| `Get-HostNTPConfig.ps1` | NTP servers and ntpd state per host. |
| `Set-HostNTPConfig.ps1` | Configure NTP servers, enable and restart ntpd (`-WhatIf`). |
| `Get-HostUptime.ps1` | Host uptime in days. |
| `Get-HostVIBs.ps1` | Installed VIBs/patches via esxcli (name filter). |
| `Get-HostBIOSVersion.ps1` | BIOS/firmware version and release date. |
| `Get-HostSyslogConfig.ps1` | Remote syslog target per host. |
| `Get-HostDNSConfig.ps1` | Hostname, domain and DNS servers per host. |
| `Get-HostAdvancedSetting.ps1` | Audit any advanced setting across hosts. |

### 05 · Networking
| Script | Description |
|---|---|
| `Get-VirtualSwitches.ps1` | Standard vSwitches with uplinks, MTU, ports. |
| `Get-PortGroups.ps1` | Standard port groups and VLAN IDs. |
| `Get-VMKernelAdapters.ps1` | VMkernel adapters (IP, MAC, traffic types). |
| `Get-PhysicalNICs.ps1` | Physical NICs with link speed and MAC. |
| `Get-VMNetworkInfo.ps1` | VM adapters, port groups, MACs and guest IPs. |
| `Get-VLANReport.ps1` | VLAN usage summarized across port groups. |
| `New-StandardPortGroup.ps1` | Create a standard port group with VLAN (`-WhatIf`). |
| `Get-DVSwitchInfo.ps1` | Distributed switch (VDS) configuration. |
| `Get-NetworkAdapterMAC.ps1` | Flat VM/adapter/MAC/network list for auditing. |
| `Get-UnusedPortGroups.ps1` | Port groups with no VMs connected. |

### 06 · Cluster / DRS / HA
| Script | Description |
|---|---|
| `Get-ClusterInventory.ps1` | Cluster config: HA/DRS, automation, EVC, counts. |
| `Get-DRSRules.ps1` | DRS affinity/anti-affinity rules with member VMs. |
| `Get-HAConfiguration.ps1` | HA host/VM monitoring, admission control, isolation. |
| `Get-ClusterResourceUsage.ps1` | Current CPU/memory utilization per cluster. |
| `Set-DRSAutomationLevel.ps1` | Change DRS automation level (`-WhatIf`). |
| `Get-ClusterVMDistribution.ps1` | VM count and load per host within a cluster. |
| `New-DRSAntiAffinityRule.ps1` | Create a keep-apart anti-affinity rule (`-WhatIf`). |
| `Get-ClusterCapacity.ps1` | N+1 failover headroom (CPU/memory) per cluster. |
| `Get-EVCMode.ps1` | EVC baseline per cluster. |
| `Get-HAFailoverCapacity.ps1` | HA admission policy and effective vs total resources. |

### 07 · Performance & Monitoring
| Script | Description |
|---|---|
| `Get-VMCPUUsage.ps1` | Realtime CPU % (avg/peak) per VM. |
| `Get-VMMemoryUsage.ps1` | Realtime active memory % per VM. |
| `Get-HostCPUUsage.ps1` | Current CPU utilization per host. |
| `Get-HostMemoryUsage.ps1` | Current memory utilization per host. |
| `Get-TopCPUVMs.ps1` | Top CPU-consuming VMs right now. |
| `Get-TopMemoryVMs.ps1` | Top memory-consuming VMs right now. |
| `Get-VMDiskLatency.ps1` | Realtime virtual-disk latency (ms) per VM. |
| `Get-ClusterPerformance.ps1` | Historical CPU/memory trend per cluster. |
| `Get-VMNetworkUsage.ps1` | Realtime network throughput (Mbps) per VM. |
| `Get-ResourcePoolUsage.ps1` | Resource pool usage vs reservations/limits. |
| `Export-PerformanceReport.ps1` | Combined per-VM CPU/mem/latency/net CSV. |
| `Get-VMReadyTime.ps1` | CPU ready % (contention indicator) per VM. |

### 08 · Security & Compliance
| Script | Description |
|---|---|
| `Get-VIPermissions.ps1` | All assigned vCenter permissions. |
| `Get-VIRoles.ps1` | Roles and their privilege counts. |
| `Get-AdminUsers.ps1` | Principals holding the Administrator role. |
| `Get-VMToolsStatus.ps1` | VMware Tools status/version (`-OutOfDateOnly`). |
| `Get-ESXiComplianceCheck.ps1` | Quick hardening check (SSH, shell, lockdown, NTP). |
| `Get-CertificateExpiry.ps1` | ESXi host certificate expiry (`-WarnDays`). |
| `Get-SSHStatus.ps1` | SSH service state and policy per host. |
| `Get-LockdownMode.ps1` | Lockdown mode per host. |
| `Get-LocalAccounts.ps1` | Local ESXi accounts via esxcli. |
| `Export-SecurityReport.ps1` | Consolidated per-host security posture CSV. |

### 09 · Resource Pools, Folders, Templates & Tags
| Script | Description |
|---|---|
| `Get-ResourcePools.ps1` | Resource pool shares, reservations, limits, VM count. |
| `Get-FolderStructure.ps1` | VM folder hierarchy with full paths. |
| `Get-Templates.ps1` | Templates with guest OS and sizing. |
| `Get-ContentLibrary.ps1` | Content library items by library and type. |
| `Get-TagAssignments.ps1` | Tag assignments across the inventory. |
| `New-TagAndCategory.ps1` | Idempotently create a tag category and tag (`-WhatIf`). |
| `Get-CustomAttributes.ps1` | Custom attribute definitions and VM values. |
| `Get-VMFolderPath.ps1` | Full inventory folder path per VM. |

---

## Repository layout

```
vmware-automation-scripts/
├── 01-VM-Management/            (15 scripts)
├── 02-Snapshot-Management/      (10 scripts)
├── 03-Datastore-Storage/        (12 scripts)
├── 04-ESXi-Host-Management/     (13 scripts)
├── 05-Networking/               (10 scripts)
├── 06-Cluster-DRS-HA/           (10 scripts)
├── 07-Performance-Monitoring/   (12 scripts)
├── 08-Security-Compliance/      (10 scripts)
└── 09-ResourcePools-Folders-Tags/ (8 scripts)
```

Each folder has its own `README.md` describing the scripts it contains.

---

## Notes & disclaimer

- Performance scripts rely on vCenter statistics; realtime metrics require the
  relevant hosts to be connected.
- These scripts are provided as-is. Always test in a non-production environment
  first and use `-WhatIf` where available before making changes.

## Author

**Tayfun Deger**

For detailed articles and write-ups about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)**.

- Website: [www.tayfundeger.com](https://www.tayfundeger.com)
- GitHub: [github.com/tayfundeger](https://github.com/tayfundeger)
