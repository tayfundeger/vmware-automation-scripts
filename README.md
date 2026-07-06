# VMware PowerCLI Automation Scripts

A curated collection of **200 production-ready VMware PowerCLI scripts** covering the
tasks a virtualization administrator runs most often: VM lifecycle, snapshots,
storage, ESXi hosts, networking, clusters (DRS/HA), performance, security,
inventory, vCenter administration, backup/export, vMotion & migration, advanced
VM operations, alarms/events/logging, capacity planning, advanced storage
(iSCSI/NFS/VMFS) and bulk automation.

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

### 10 · vCenter & Inventory
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

### 11 · Backup, Export & Configuration
| Script | Description |
|---|---|
| `Export-VMConfig.ps1` | Export each VM's configuration to JSON. |
| `Export-VMToOVF.ps1` | Export VM(s) to OVF/OVA (-WhatIf). |
| `Export-HostConfig.ps1` | Export host NTP/syslog/DNS/services to JSON. |
| `Export-PortGroupConfig.ps1` | Standard port groups + security policy to CSV. |
| `Export-DRSRuleConfig.ps1` | DRS rules and member VMs to CSV. |
| `Export-ResourcePoolConfig.ps1` | Resource pool shares/reservations/limits to CSV. |
| `Export-TagConfig.ps1` | Tag definitions and assignments to CSV. |
| `Export-RoleConfig.ps1` | Custom roles and their privileges to JSON. |
| `Backup-VDSwitchConfig.ps1` | Native VDS backup zip per distributed switch (-WhatIf). |
| `Export-VMAnnotations.ps1` | VM notes and custom attribute values to CSV. |

### 12 · vMotion & Migration
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

### 13 · Advanced VM Operations
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

### 14 · Alarms, Events & Logging
| Script | Description |
|---|---|
| `Get-AlarmDefinitions.ps1` | All alarm definitions (-DisabledOnly). |
| `Get-TriggeredAlarms.ps1` | Currently triggered alarms across the inventory. |
| `Set-AlarmState.ps1` | Enable or disable an alarm definition (-WhatIf). |
| `Get-AlarmActionReport.ps1` | Which alarms have email/SNMP/script actions. |
| `Get-LoginEvents.ps1` | User login/logout session events. |
| `Get-VMPowerEvents.ps1` | VM power on/off/suspend events. |
| `Get-HostEvents.ps1` | Host connectivity/maintenance/hardware events. |
| `Get-PermissionChangeEvents.ps1` | Permission add/remove/update audit trail. |
| `Get-ConfigChangeEvents.ps1` | VM reconfiguration audit events. |
| `Export-EventLog.ps1` | Export events over N days to CSV. |

### 15 · Reporting & Capacity Planning
| Script | Description |
|---|---|
| `Get-IdleVMs.ps1` | Low CPU + network VMs (decommission candidates). |
| `Get-OversizedVMs.ps1` | Under-utilized VMs (downsize candidates). |
| `Get-UndersizedVMs.ps1` | Over-utilized VMs (upsize candidates). |
| `Get-PoweredOffVMs.ps1` | Powered-off VMs and reclaimable space. |
| `Get-VMDensityPerHost.ps1` | VM density and vCPU:pCPU / vRAM:pRAM per host. |
| `Get-CPUOvercommitment.ps1` | vCPU:pCPU overcommitment per cluster. |
| `Get-MemoryOvercommitment.ps1` | vRAM:pRAM overcommitment per cluster. |
| `Get-ClusterConsolidationRatio.ps1` | VMs-per-host per cluster. |
| `Get-VMRightsizingReport.ps1` | CPU/mem avg+peak with rightsizing recommendation. |
| `Get-TopProvisionedVMs.ps1` | Largest VMs by provisioned storage. |
| `Get-GuestOSReport.ps1` | VM count by guest OS. |
| `Get-VMHardwareVersionReport.ps1` | VM count by hardware version. |
| `Get-ResourceReservationReport.ps1` | VMs with reservations or limits set. |
| `Get-EmptyResourcePools.ps1` | Resource pools with no VMs. |

### 16 · Storage Advanced
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

### 17 · Host Configuration Advanced
| Script | Description |
|---|---|
| `Get-HostFirewallRules.ps1` | ESXi firewall rulesets per host (-EnabledOnly). |
| `Set-HostFirewallRule.ps1` | Enable/disable a firewall ruleset (-WhatIf). |
| `Get-HostPowerPolicy.ps1` | CPU power management policy per host. |
| `Set-HostPowerPolicy.ps1` | Set power policy (High Perf/Balanced/Low) (-WhatIf). |
| `Get-HostScratchConfig.ps1` | Current vs. configured scratch location. |
| `Get-HostCoreDumpConfig.ps1` | Core dump partition and network collector. |
| `Get-HostKernelModules.ps1` | Loaded VMkernel modules via esxcli. |
| `Add-HostToCluster.ps1` | Join an ESXi host to a cluster (-WhatIf). |
| `Remove-HostFromCluster.ps1` | Safely remove a host from inventory (-WhatIf). |
| `Restart-VMHostSafely.ps1` | Reboot a host, maintenance-guarded (-WhatIf). |
| `Set-HostShellTimeout.ps1` | Set ESXi shell/SSH idle timeouts (-WhatIf). |
| `Get-HostBootDevice.ps1` | Boot filesystem UUID and boot NIC. |

### 18 · Automation Utilities & Bulk Operations
| Script | Description |
|---|---|
| `Connect-MultipleVCenters.ps1` | Connect to several vCenters at once. |
| `New-VMsFromCSV.ps1` | Bulk-deploy VMs from a template via CSV (-WhatIf). |
| `Set-VMAttributesFromCSV.ps1` | Bulk-set notes/custom attributes via CSV (-WhatIf). |
| `Invoke-SnapshotFromCSV.ps1` | Bulk-create snapshots from a CSV list (-WhatIf). |
| `Export-FullInventory.ps1` | Export VMs/Hosts/Datastores/Clusters to CSVs. |
| `Send-VIReportEmail.ps1` | Email a plain-text vSphere health summary (-WhatIf). |
---

## Repository layout

```
vmware-automation-scripts/
├── 01-VM-Management/               (15 scripts)
├── 02-Snapshot-Management/         (10 scripts)
├── 03-Datastore-Storage/           (12 scripts)
├── 04-ESXi-Host-Management/        (13 scripts)
├── 05-Networking/                  (10 scripts)
├── 06-Cluster-DRS-HA/              (10 scripts)
├── 07-Performance-Monitoring/      (12 scripts)
├── 08-Security-Compliance/         (10 scripts)
├── 09-ResourcePools-Folders-Tags/   (8 scripts)
├── 10-vCenter-Inventory/           (12 scripts)
├── 11-Backup-Export-Config/        (10 scripts)
├── 12-vMotion-Migration/           (10 scripts)
├── 13-Advanced-VM-Operations/      (14 scripts)
├── 14-Alarms-Events-Logging/       (10 scripts)
├── 15-Reporting-Capacity/          (14 scripts)
├── 16-Storage-Advanced/            (12 scripts)
├── 17-Host-Config-Advanced/        (12 scripts)
└── 18-Automation-Utilities/         (6 scripts)
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
