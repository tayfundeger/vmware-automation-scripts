# 06 · Cluster / DRS / HA

Cluster configuration, DRS rules and automation, HA settings, resource usage and failover-capacity planning.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-ClusterInventory.ps1` | Cluster config: HA/DRS, automation, EVC, counts. |
| `Get-DRSRules.ps1` | DRS affinity/anti-affinity rules with member VMs. |
| `Get-HAConfiguration.ps1` | HA host/VM monitoring, admission control, isolation. |
| `Get-ClusterResourceUsage.ps1` | Current CPU/memory utilization per cluster. |
| `Set-DRSAutomationLevel.ps1` | Change DRS automation level (-WhatIf). |
| `Get-ClusterVMDistribution.ps1` | VM count and load per host within a cluster. |
| `New-DRSAntiAffinityRule.ps1` | Create a keep-apart anti-affinity rule (-WhatIf). |
| `Get-ClusterCapacity.ps1` | N+1 failover headroom (CPU/memory) per cluster. |
| `Get-EVCMode.ps1` | EVC baseline per cluster. |
| `Get-HAFailoverCapacity.ps1` | HA admission policy and effective vs total resources. |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-ClusterResourceUsage.ps1
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
