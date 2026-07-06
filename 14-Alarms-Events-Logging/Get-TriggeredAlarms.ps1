<#
.SYNOPSIS
    Lists currently triggered alarms across the inventory.
.DESCRIPTION
    Scans datacenters, clusters, hosts, VMs and datastores for active
    (triggered) alarm states and reports the object, alarm name, severity, time
    and acknowledgement status.
.EXAMPLE
    PS> ./Get-TriggeredAlarms.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$alarmNameCache = @{}
function Resolve-AlarmName($ref) {
    if (-not $alarmNameCache.ContainsKey($ref.Value)) {
        $alarmNameCache[$ref.Value] = (Get-View -Id $ref).Info.Name
    }
    $alarmNameCache[$ref.Value]
}

$entities = @()
$entities += Get-Datacenter
$entities += Get-Cluster
$entities += Get-VMHost
$entities += Get-VM
$entities += Get-Datastore

$results = foreach ($e in $entities) {
    foreach ($ta in $e.ExtensionData.TriggeredAlarmState) {
        [pscustomobject]@{
            Entity       = $e.Name
            EntityType   = $e.GetType().Name -replace 'Impl$',''
            Alarm        = Resolve-AlarmName $ta.Alarm
            Severity     = $ta.OverallStatus
            Time         = $ta.Time
            Acknowledged = $ta.Acknowledged
        }
    }
}

if (-not $results) { Write-Host 'No triggered alarms.' -ForegroundColor Green; return }
$results | Sort-Object Severity, Entity
