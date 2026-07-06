# 01 · VM Management

Day-to-day virtual machine lifecycle and configuration tasks: inventory, deploy, clone, power operations, reconfigure, migrate and bulk edits.

**15 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-VMInventory.ps1` | Full VM inventory (CPU, RAM, disk, OS, host, cluster, Tools). |
| `New-VMFromTemplate.ps1` | Deploy a new VM from a template (optional folder & customization). |
| `New-VMClone.ps1` | Clone an existing VM to a target host/datastore. |
| `Remove-VMSafely.ps1` | Remove VM(s) with guard rails (refuses powered-on, -WhatIf). |
| `Start-VMsBulk.ps1` | Bulk power-on by name or cluster, with optional stagger delay. |
| `Stop-VMsBulk.ps1` | Bulk graceful guest shutdown (-Force for hard power off). |
| `Restart-VMGuest.ps1` | Graceful guest OS restart via VMware Tools. |
| `Set-VMResources.ps1` | Reconfigure vCPU / cores-per-socket / memory. |
| `Get-VMPowerState.ps1` | Power-state list plus a summary count. |
| `Move-VMToHost.ps1` | vMotion a VM to a specified host. |
| `Get-VMsByHost.ps1` | List VMs grouped by their ESXi host. |
| `Set-VMNotes.ps1` | Set or append the VM Notes/annotation field. |
| `Get-VMCreationDate.ps1` | Report VM creation date and age (vSphere 6.7+). |
| `Get-VMUptime.ps1` | Uptime of powered-on VMs from BootTime. |
| `Rename-VMBulk.ps1` | Bulk-rename VM display names by pattern (-WhatIf). |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-VMInventory.ps1 -Path C:\Reports\vms.csv
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
