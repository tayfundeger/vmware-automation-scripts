# 14 · Alarms, Events & Logging

Alarm definitions and triggered alarms, alarm actions, and event-based audit trails for logins, power operations, permission and configuration changes.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

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

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-TriggeredAlarms.ps1
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
