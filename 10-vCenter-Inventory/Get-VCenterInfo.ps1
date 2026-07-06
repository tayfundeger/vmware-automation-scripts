<#
.SYNOPSIS
    Reports vCenter Server version and instance details.
.DESCRIPTION
    Reads the ServiceInstance "About" info for each connected server: full name,
    version, build, API version, OS type and the unique instance UUID.
.EXAMPLE
    PS> ./Get-VCenterInfo.ps1
.NOTES
    Author  : Tayfun Deger
    Website : https://www.tayfundeger.com
    GitHub  : https://github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
#>
[CmdletBinding()]
param()

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

foreach ($srv in $global:DefaultVIServers) {
    $about = (Get-View ServiceInstance -Server $srv).Content.About
    [pscustomobject]@{
        Server       = $srv.Name
        FullName     = $about.FullName
        Version      = $about.Version
        Build        = $about.Build
        ApiVersion   = $about.ApiVersion
        OsType       = $about.OsType
        InstanceUUID = $about.InstanceUuid
    }
}
