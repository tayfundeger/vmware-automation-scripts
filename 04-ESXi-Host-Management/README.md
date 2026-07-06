# 04 · ESXi Host Management

Inventory, hardware, services, time, patching and configuration reporting/administration for ESXi hosts.

**13 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-HostInventory.ps1` | Host inventory: version, build, vendor, uptime, VM count. |
| `Get-HostHardware.ps1` | CPU model, sockets/cores/threads, RAM, service tag. |
| `Set-HostMaintenanceMode.ps1` | Enter/exit maintenance mode (-Exit, -WhatIf). |
| `Get-HostServices.ps1` | Host service states and startup policies. |
| `Restart-HostService.ps1` | Restart a service (e.g. SSH, ntpd) across hosts (-WhatIf). |
| `Get-HostNTPConfig.ps1` | NTP servers and ntpd state per host. |
| `Set-HostNTPConfig.ps1` | Configure NTP servers, enable and restart ntpd (-WhatIf). |
| `Get-HostUptime.ps1` | Host uptime in days. |
| `Get-HostVIBs.ps1` | Installed VIBs/patches via esxcli (name filter). |
| `Get-HostBIOSVersion.ps1` | BIOS/firmware version and release date. |
| `Get-HostSyslogConfig.ps1` | Remote syslog target per host. |
| `Get-HostDNSConfig.ps1` | Hostname, domain and DNS servers per host. |
| `Get-HostAdvancedSetting.ps1` | Audit any advanced setting across hosts. |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Set-HostMaintenanceMode.ps1 -VMHost esxi03 -WhatIf
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger** ([github.com/tayfundeger](https://github.com/tayfundeger)).
