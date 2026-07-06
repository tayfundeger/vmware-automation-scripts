# 08 · Security & Compliance

Access, roles, hardening posture, certificate expiry and VMware Tools compliance reporting.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-VIPermissions.ps1` | All assigned vCenter permissions. |
| `Get-VIRoles.ps1` | Roles and their privilege counts. |
| `Get-AdminUsers.ps1` | Principals holding the Administrator role. |
| `Get-VMToolsStatus.ps1` | VMware Tools status/version (-OutOfDateOnly). |
| `Get-ESXiComplianceCheck.ps1` | Quick hardening check (SSH, shell, lockdown, NTP). |
| `Get-CertificateExpiry.ps1` | ESXi host certificate expiry (-WarnDays). |
| `Get-SSHStatus.ps1` | SSH service state and policy per host. |
| `Get-LockdownMode.ps1` | Lockdown mode per host. |
| `Get-LocalAccounts.ps1` | Local ESXi accounts via esxcli. |
| `Export-SecurityReport.ps1` | Consolidated per-host security posture CSV. |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-CertificateExpiry.ps1 -WarnDays 60
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger** ([github.com/tayfundeger](https://github.com/tayfundeger)).
