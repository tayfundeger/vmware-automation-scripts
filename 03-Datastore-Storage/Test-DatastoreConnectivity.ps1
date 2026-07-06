<#
.SYNOPSIS
    Verifies datastore accessibility from every host.
.DESCRIPTION
    Reports, per datastore and per host, whether the datastore is mounted and
    accessible. Rows where Accessible is false indicate a connectivity problem.
.PARAMETER Datastore
    Optional datastore name filter (wildcards allowed).
.EXAMPLE
    PS> ./Test-DatastoreConnectivity.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param([string]$Datastore = '*')

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($ds in Get-Datastore -Name $Datastore) {
    foreach ($mount in $ds.ExtensionData.Host) {
        $hostView = Get-View -Id $mount.Key -Property Name
        [pscustomobject]@{
            Datastore  = $ds.Name
            VMHost     = $hostView.Name
            Mounted    = $mount.MountInfo.Mounted
            Accessible = $mount.MountInfo.Accessible
        }
    }
}
