# 05 · Networking

Virtual and physical networking reporting for standard and distributed switches, port groups, VMkernel/physical adapters and VLANs.

**10 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-VirtualSwitches.ps1` | Standard vSwitches with uplinks, MTU, ports. |
| `Get-PortGroups.ps1` | Standard port groups and VLAN IDs. |
| `Get-VMKernelAdapters.ps1` | VMkernel adapters (IP, MAC, traffic types). |
| `Get-PhysicalNICs.ps1` | Physical NICs with link speed and MAC. |
| `Get-VMNetworkInfo.ps1` | VM adapters, port groups, MACs and guest IPs. |
| `Get-VLANReport.ps1` | VLAN usage summarized across port groups. |
| `New-StandardPortGroup.ps1` | Create a standard port group with VLAN (-WhatIf). |
| `Get-DVSwitchInfo.ps1` | Distributed switch (VDS) configuration. |
| `Get-NetworkAdapterMAC.ps1` | Flat VM/adapter/MAC/network list for auditing. |
| `Get-UnusedPortGroups.ps1` | Port groups with no VMs connected. |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./Get-VMNetworkInfo.ps1 -Name web01
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger** ([github.com/tayfundeger](https://github.com/tayfundeger)).
