param (
    [int]$Port
)

$ScriptName = $MyInvocation.MyCommand.Name
# $Program = "$env:SystemRoot\System32\svchost.exe"

if (-not $Port) {
    Write-Host "Error: Port argument is missing."
    Write-Host "Usage: .\$ScriptName -Port <PortNumber>"
    exit 1
}

$RegistryPath = 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
$RName = 'PortNumber'
$RIP = @('0.0.0.0', '127.0.0.1')

function Test-AdminPrivilege {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}


if (-not (Test-AdminPrivilege)) {
    # Relaunch the script with elevated privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Port $Port" -Verb RunAs
    exit
}

Disable-NetFirewallRule -DisplayName 'Remote Desktop - Shadow (TCP-In)'
Disable-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)'
Disable-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (UDP-In)'

Remove-NetFirewallRule -DisplayName 'RDPPORTLatest-TCP-In' -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName 'RDPPORTLatest-UDP-In' -ErrorAction SilentlyContinue

#  Get-ItemProperty -Path $RegistryPath -name $RName

Set-ItemProperty -Path $RegistryPath -name $RName -Value $Port

New-NetFirewallRule -DisplayName 'RDPPORTLatest-TCP-In' -Profile @('Domain', 'Private', 'Public') -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port -RemoteAddress $RIP
New-NetFirewallRule -DisplayName 'RDPPORTLatest-UDP-In' -Profile @('Domain', 'Private', 'Public') -Direction Inbound -Action Allow -Protocol UDP -LocalPort $Port -RemoteAddress $RIP

Restart-Service -Name TermService -Force

Read-Host -Prompt "Press Enter to exit"
