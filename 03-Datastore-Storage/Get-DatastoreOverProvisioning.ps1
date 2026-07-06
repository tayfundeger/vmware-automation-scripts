<#
.SYNOPSIS
    Reports thin-provisioning over-commit per datastore.
.DESCRIPTION
    Calculates provisioned vs. physical capacity for each datastore and the
    over-provisioning ratio (values > 1.0 mean the datastore is over-committed).
.EXAMPLE
    PS> ./Get-DatastoreOverProvisioning.ps1
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

Get-Datastore | ForEach-Object {
    $s = $_.ExtensionData.Summary
    $capGB  = [math]::Round($s.Capacity/1GB, 1)
    $provGB = [math]::Round(($s.Capacity - $s.FreeSpace + $s.Uncommitted)/1GB, 1)
    [pscustomobject]@{
        Datastore     = $_.Name
        CapacityGB    = $capGB
        ProvisionedGB = $provGB
        OverProvRatio = if ($capGB) { [math]::Round($provGB/$capGB, 2) } else { $null }
    }
} | Sort-Object OverProvRatio -Descending
