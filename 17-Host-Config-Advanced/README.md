# 17 · Host Configuration Advanced

Deeper host configuration: firewall rulesets, CPU power policy, scratch and core-dump config, kernel modules, cluster membership, reboots and SSH timeouts.

**12 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

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

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Set-HostPowerPolicy.ps1 -VMHost esxi01 -Policy HighPerformance
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
