# 11 · Backup, Export & Configuration

Export and back up configuration: VM and host configs, port groups, DRS rules, resource pools, tags, roles, distributed switches and annotations.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

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

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Export-HostConfig.ps1 -OutputFolder C:\Backup\Hosts
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
