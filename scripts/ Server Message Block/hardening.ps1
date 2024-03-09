# https://learn.microsoft.com/en-us/windows-server/storage/file-server/troubleshoot/detect-enable-and-disable-smbv1-v2-v3?tabs=server#disabling-smbv2-or-smbv3-for-troubleshooting

# $ScriptName = $MyInvocation.MyCommand.Name
# $RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
# $Service = 'SMB2'

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

# Update
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (SMB-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (NB-Session-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (NB-Name-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (NB-Datagram-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (LLMNR-UDP-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv6-In)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Spooler Service - RPC)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP
Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Spooler Service - RPC-EPMAP)' | Where-Object { $_.Profile -eq 'Private' } | Set-NetFirewallRule -RemoteAddress $RIP

Get-NetFirewallRule -DisplayName 'Remote Assistance (DCOM-In)' | Where-Object { $_.Profile -eq 'Domain' } | Set-NetFirewallRule -RemoteAddress $RIP

# Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (NB-Session-In)'
# Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (NB-Name-In)'
# Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (NB-Datagram-In)'
# Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (LLMNR-UDP-In)'
# Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)'
# Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv6-In)'

# Detect
# Get-ItemProperty $RegistryPath | ForEach-Object {Get-ItemProperty $_.pspath}

# Disable
# Set-ItemProperty -Path $RegistryPath $Service -Type DWORD -Value 0 -Force

Read-Host -Prompt "Press Enter to exit"