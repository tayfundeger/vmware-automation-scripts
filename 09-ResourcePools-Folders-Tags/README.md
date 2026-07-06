# 09 · Resource Pools, Folders, Templates & Tags

Logical inventory organization: resource pools, VM folders, templates, content libraries, tags and custom attributes.

**8 scripts.** Each supports `Get-Help ./<Script>.ps1 -Full`. Reporting scripts return objects (pipe to `Format-Table`/`Export-Csv`); state-changing scripts support `-WhatIf`.

| Script | Description |
|---|---|
| `Get-ResourcePools.ps1` | Resource pool shares, reservations, limits, VM count. |
| `Get-FolderStructure.ps1` | VM folder hierarchy with full paths. |
| `Get-Templates.ps1` | Templates with guest OS and sizing. |
| `Get-ContentLibrary.ps1` | Content library items by library and type. |
| `Get-TagAssignments.ps1` | Tag assignments across the inventory. |
| `New-TagAndCategory.ps1` | Idempotently create a tag category and tag (-WhatIf). |
| `Get-CustomAttributes.ps1` | Custom attribute definitions and VM values. |
| `Get-VMFolderPath.ps1` | Full inventory folder path per VM. |

## Example

```powershell
Connect-VIServer -Server vcenter.example.com
./New-TagAndCategory.ps1 -Category Environment -Tag Production
```

---

Part of the [VMware PowerCLI Automation Scripts](../README.md) collection by **Tayfun Deger**.

For detailed articles about these scripts, visit **[www.tayfundeger.com](https://www.tayfundeger.com)** · [github.com/tayfundeger](https://github.com/tayfundeger)
