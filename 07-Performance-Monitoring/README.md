# 07 · Performance & Monitoring

Realtime and historical performance metrics for VMs, hosts and clusters: CPU, memory, disk latency, network and CPU ready time.

**12 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

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

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Export-PerformanceReport.ps1 -Hours 24 -Path C:\Reports\perf.csv
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger** ([github.com/tayfundeger](https://github.com/tayfundeger)).
