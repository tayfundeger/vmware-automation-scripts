# 03 · Datastore & Storage

Capacity, provisioning, disk placement and storage-connectivity reporting for datastores and virtual disks.

**12 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

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

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-DatastoreCapacityAlert.ps1 -ThresholdPercent 10
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
