<#
An example of a csv file mappings between CIDR and Subnet eg 24,255.255.255.0 
The JSON input uses the subnet eg 255.255.255.0
However the New-NetIPAddress -Prefixlength requires '24'

This example shows how to match lines in a csv with an external value

#>

#PWD for ISE or Powershell 
if($psise -ne $null)
    {
        $ISEPath = $psise.CurrentFile.FullPath
        $ISEDisp = $psise.CurrentFile.DisplayName.Replace("*","")
        $Pwdir = $ISEPath.TrimEnd("$ISEDisp")
    }
    else
    {
        $Pwdir = split-path -parent $MyInvocation.MyCommand.Path
    }

#JSON File for DCPromo
$dcPromoJson = "DCPromov.0.1.json"

#Lists of Subnets and their CIDRs
$dcPromoSubnet = "Subnet.csv"

#Import JSON
$gtDCPromoJ = Get-Content -raw -Path "$($Pwdir)\$($dcPromoJson)" | ConvertFrom-Json

#Import csv of Subnets 
[array]$gtSubnet = Import-Csv -Path "$($Pwdir)\$($dcPromoSubnet)"

#Var the subnet value eg 255.255.255.0
$PDC_Subnet = $gtDCPromoJ.FirstDC.Subnet

#Subnet to CIDR conversion table - Match the 255.255.255.0 to the CIDR in the table
foreach($lnSubnet in $gtSubnet)
    {
        if ($lnSubnet.mask -cmatch $PDC_Subnet)
            {
                $prefix = $lnSubnet.cidr
            }
    }
#
New-NetIPAddress -InterfaceAlias $gtNetAdpap.Name `
                 -IPAddress $PDC_IP                       `
                 -AddressFamily IPv4                      `
                 -PrefixLength $prefix                    `
                 -DefaultGateway $PDC_Route
        
#Set DNS Server                 
Set-DnsClientServerAddress -ServerAddresses $PDC_IP -InterfaceAlias $intAlias

