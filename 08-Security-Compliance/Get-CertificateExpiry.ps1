<#
.SYNOPSIS
    Checks SSL certificate expiry for each ESXi host.
.DESCRIPTION
    Opens a TLS connection to port 443 on every host, reads the presented
    certificate and reports days remaining until expiry. Flags any certificate
    expiring within -WarnDays. Useful ahead of certificate-renewal projects.
.PARAMETER WarnDays
    Threshold in days below which a certificate is flagged (default 30).
.PARAMETER Path
    Optional CSV output path.
.EXAMPLE
    PS> ./Get-CertificateExpiry.ps1 -WarnDays 60
.NOTES
    Author : Tayfun Deger | github.com/tayfundeger
    Requires: VMware PowerCLI 12+ and an active Connect-VIServer session.
    Network access to host port 443 from where the script runs is required.
#>
[CmdletBinding()]
param([int]$WarnDays = 30, [string]$Path)

if (-not $global:DefaultVIServer) { Write-Warning 'No active vCenter connection. Run Connect-VIServer first.'; return }

$callback = [System.Net.Security.RemoteCertificateValidationCallback]{ param($sndr,$cert,$chain,$err) $true }

$report = foreach ($h in (Get-VMHost | Sort-Object Name)) {
    $name = $h.Name
    $tcp  = New-Object System.Net.Sockets.TcpClient
    try {
        $iar = $tcp.BeginConnect($name, 443, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne(5000)) { throw 'Connection timeout' }
        $tcp.EndConnect($iar)

        $ssl = New-Object System.Net.Security.SslStream($tcp.GetStream(), $false, $callback)
        $ssl.AuthenticateAsClient($name)
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($ssl.RemoteCertificate)
        $days = [math]::Round((New-TimeSpan -Start (Get-Date) -End $cert.NotAfter).TotalDays)
        $ssl.Dispose()

        [pscustomobject]@{
            Host      = $name
            NotAfter  = $cert.NotAfter
            DaysLeft  = $days
            Status    = if ($days -le $WarnDays) { 'WARNING' } else { 'OK' }
        }
    }
    catch {
        [pscustomobject]@{ Host = $name; NotAfter = $null; DaysLeft = $null; Status = "ERROR: $($_.Exception.Message)" }
    }
    finally { $tcp.Close() }
}

$report = $report | Sort-Object DaysLeft
if ($Path) { $report | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8; Write-Host "Saved to $Path" }
else       { $report }
