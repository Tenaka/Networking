########################################################################################
###################################  SET STATIC IP  ####################################
########################################################################################

Write-Host "Set a Static IP Address" -ForegroundColor yellow
$gNetAdp = Get-NetAdapter | where {$_.Status -eq "up"}
$intAlias = $gNetAdp.InterfaceAlias

$gNetIPC = Get-NetIPConfiguration -InterfaceAlias $gNetAdp.Name
$IPAddress = $gNetIPC.IPv4Address.ipaddress
$DHCPRouter = $gNetIPC.IPv4DefaultGateway.nexthop
$dnsAddress = $gNetIPC.dnsserver.serveraddresses

$gNetIPC | Remove-NetIPAddress -Confirm:$false
$gNetIPC.IPv4DefaultGateway |Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

$IPAddress = Read-Host "Enter the Static IP"
$DefGate = Read-Host "Enter the Default Gateway eg 192.168.0.254"
$dnsServer = Read-Host "Enter DNS IP(s) eg 192.168.0.22 or 192.168.0.22,192.168.0.23"
$dnsName = Read-Host "Enter an FQDN eg Contoso.net"
    
#Set Static IP
New-NetIPAddress -InterfaceAlias $gNetAdp.Name `
                 -IPAddress $IPAddress `
                 -AddressFamily IPv4 `
                 -PrefixLength 24 `
                 -DefaultGateway $DefGate
#Set DNS Server                 
Set-DnsClientServerAddress -ServerAddresses $dnsServer -InterfaceAlias $intAlias
