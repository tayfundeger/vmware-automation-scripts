# 15 · Reporting & Capacity Planning

Right-sizing and capacity planning: idle/oversized/undersized VMs, overcommitment and consolidation ratios, guest-OS and hardware-version distributions.

**14 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

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

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-VMRightsizingReport.ps1 -Days 30 | Export-Csv rightsizing.csv -NoTypeInformation
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
