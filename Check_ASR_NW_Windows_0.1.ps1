####To Test ONLY#####
#This is for the OS version more than Windows 8.1 / Windows Server 2012 R2 , basically.
#This script is for testing , You must not copy , and must not use commercially.
#For checking Azure Site Recovery Network Connectivity.
#version:0.1
#Copyright:yukiokutani
# Set Parameters
Param(
    [parameter(position = 0,Mandatory = $true)]
    [String]$ChacheSA,

    [parameter(position = 1)]
    [bool]$PrivateEndpointEnabled,
    
    [parameter(position = 2)]
    [String]$SubscriptionId,
    
    [parameter(position = 3)]
    [String]$PEName,
    
    [parameter(position = 4)]
    [String]$PERg
)

Write-Output "Start Script"

# Name directory
$static_logName = "ASR_Check_NW"

#Get Script Located Path
$logDirPath = $PSScriptRoot

# Set log location and filename
$logFilePath = "${logDirPath}\${static_logname}_$($(Get-Date).ToString("yyyyMMdd_HHmmss")).log"

#Microsoft Entra ID
$MicrosoftEntraID = "login.microsoftonline.com"

#Start Transcript
Start-Transcript -path "${logFilePath}" -Append
Write-Output "-----ScriptStart----- $(Get-Date)"

###################################
#getInfos
function getInfos {
    Write-Output ""
    Write-Output "#####getInfo######"
    Write-Output "###hostname"
    HOSTNAME.EXE
    Write-Output "###ipconfig"
    ipconfig.exe
    Write-Output "----------"
    Write-Output ""
}

## check cacheSA
function Check_ASR {
    # ASR A2A URLS
    # https://learn.microsoft.com/ja-jp/azure/site-recovery/azure-to-azure-tutorial-enable-replication#outbound-connectivity-for-urls
    if ($PrivateEndpointEnabled) {
        # Get ASR Private Endpoint 
        Set-AzContext -SubscriptionId $SubscriptionId
        Write-Output "Get ASR Private Endpoint list"
        $pelist = Get-AzPrivateEndpoint -Name $PEName -ResourceGroupName $PERg
        Write-Output "Private Endpint List : " $pelist.Name

        # Get NIC
        $networkInterface = Get-AzResource -ResourceId $pelist[0].NetworkInterfaces[0].Id -ApiVersion "2019-04-01"
        Write-Output "Get NIC with PE : " $networkInterface.ResourceId
        # Get ASR Private Endpoint FQDN
        Write-Output "Private Endpoint FQDN : " $networkInterface.properties.ipConfigurations.properties.privateLinkConnectionProperties.fqdns
        $URLs_ASR = ($networkInterface.properties.ipConfigurations.properties.privateLinkConnectionProperties.fqdns)

    }
    else {
        # Set Public ASR A2A URLs
        $URLs_ASR = @()
        $URLs_ASR += "pod01-rcm1.jpw.hypervrecoverymanager.windowsazure.com"
        $URLs_ASR += "pod01-rcm1.jpe.hypervrecoverymanager.windowsazure.com"
    }

    foreach ($URLs_ASR in $URLs_ASR) {
        Check_tnc($URLs_ASR)
        InvokeWebRequest($URLs_ASR)
    }
}

## check cacheSA
function Check_cacheSA($ChacheSA) {
    if ([string]::IsNullorEmpty($ChacheSA)) {
        Write-Host "Please add parameter for Cache Storage Account" 
        Write-Host "Skip NW connectivity chech for Cache Storage Account" 
    }
    else {
        Write-Output "Chache Storage Account Name : $ChacheSA"
        $ChacheSA_URL = $ChacheSA + ".blob.core.windows.net"
        Check_tnc($ChacheSA_URL)
        InvokeWebRequest($ChacheSA_URL)
    }
}

##tnc func
function Check_tnc ($Test_URLs) {
    Write-Output "--------------------------------------------"
    Write-Output "#TRY!! Test-NetConnection $Test_URLs  port 443 "
    $PortNo = "443"
    $resulttnc = tnc $Test_URLs -Port $PortNo
    $resultComputername = $resulttnc.computername
    $resultRemoteaddress = $resulttnc.remoteaddress.IPAddressToString
    $resultTcpTestSucceeded = $resulttnc.TcpTestSucceeded
    $resultSourceIP = $resulttnc.SourceAddress.IPAddress
    Write-Output "Result of tnc - $portNo / from $resultSourceIP /To URL  $resultComputername IPaddress $resultRemoteaddress / TcpTestSucceeded: $resultTcpTestSucceeded "
    Start-Sleep -Seconds 1
}
  
function InvokeWebRequest($Test_URIs) {
    Write-Output "--------------------------------------------"
    $Test_URLs = "https://" + $Test_URIs
    Write-Output "#TRY!! Invoke-webRequest $Test_URLs  "
    $Invoke = Invoke-webRequest $Test_URLs
    $InvokeStatusCode = $Invoke.StatusCode
    $InvokeStatusDescription = $Invoke.StatusDescription
    Write-Output "Result of Invoke-webRequest  / StatusCode: $InvokeStatusCode/ StatusDescription: $InvokeStatusDescription"
      
}

#winhttp_proxyCheck
function http_proxy() {
    Write-Output ""
    Write-Output "--------------------------------------------"
    Write-Output "##Check WinHttpProxy"
    netsh winhttp show proxy
    Write-Output "--------------------------------------------"
}

# Proxy Check
function proxy_check() {
    function TraceConnectionSettings($connectionSettings) {
        if ($connectionSettings) {
            if ($connectionSettings.GetValue('DefaultConnectionSettings')) {
                Write-Host "DefaultConnectionSettings:" $([System.Text.Encoding]::ASCII.GetString($connectionSettings.GetValue('DefaultConnectionSettings')))
            }
            else {
                Write-Host "DefaultConnectionSettings: not found"
            }

            if ($connectionSettings.GetValue('SavedLegacySettings')) {
                Write-Host "SavedLegacySettings:" $([System.Text.Encoding]::ASCII.GetString($connectionSettings.GetValue('SavedLegacySettings')))
            }
            else {
                Write-Host "SavedLegacySettings: not found"
            }
        }
    }

    Write-Host "Listing all proxy settings" -ForegroundColor Green

    # This setting controls whether the proxy server is defined per user or is same for all users.
    Write-Host "`nProxySettingsPerUser Setting" -ForegroundColor Yellow
    $proxyPerUser = Get-Item -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings'
    Write-Host "ProxySettingsPerUser:" $proxyPerUser.GetValue('ProxySettingsPerUser')

    # Proxy settings for **current user**
    Write-Host "`nWinInet settings for current user" -ForegroundColor Yellow
    $currentUserIESettings = Get-Item -Path 'Registry::HKEY_Current_User\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    Write-Host "ProxyEnable:" $($currentUserIESettings.GetValue('ProxyEnable'))
    Write-Host "ProxyServer:" $($currentUserIESettings.GetValue('ProxyServer'))
    Write-Host "ProxyOverride:" $($currentUserIESettings.GetValue('ProxyOverride'))

    $currentUserConnections = Get-Item -Path 'Registry::HKEY_Current_User\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
    TraceConnectionSettings $currentUserConnections

    # Proxy settings for **NT Authority\System**.
    Write-Host "`nWinInet settings for NT Authority\System" -ForegroundColor Yellow
    $localSystemUserIESettings = Get-Item -Path 'Registry::HKEY_USERS\S-1-5-18\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    Write-Host "ProxyEnable:" $($localSystemUserIESettings.GetValue('ProxyEnable'))
    Write-Host "ProxyServer:" $($localSystemUserIESettings.GetValue('ProxyServer'))
    Write-Host "ProxyOverride:" $($localSystemUserIESettings.GetValue('ProxyOverride'))

}

#########################################################################################################
# TODO getInfos;
# Write-Output "======================================================================"
# Write-Output "Proxy check"
# Write-Output "======================================================================"

# proxy_check;
# http_proxy;

# Write-Output "======================================================================"
# Write-Output "Connection check ASR A2A URLs"
# Write-Output "======================================================================="
# Write-Output "### Check for *.hypervrecoverymanager.windowsazure.com ###"

Check_ASR;

Write-Output "==================================================================================="
Write-Output "### Check for Cache Storage Account (blob.core.windows.net) ###"
Check_cacheSA($ChacheSA)

Write-Output "==================================================================================="
Write-Output "### Check for login.microsoftonline.com ###"
Check_tnc($MicrosoftEntraID)
InvokeWebRequest($MicrosoftEntraID)

######## TLS　Check
# TODO Write-Output "==================================================================================="
#Write-Output "========== TLS CHECK =========="
#Write-Output "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
#Write-Output "==================================================================================="

#$registry = Get-ChildItem "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" -Recurse

#foreach ($a in $registry) {
#    Write-Output `n $a -ForegroundColor Yellow
#
#    $a.Property | ForEach-Object {
#        Write-Output `t $_ $a.GetValue($_)
#    }
#}
######## TLS　Check(end)

Write-Output "-----Script Completed----- $(Get-Date)"
##Complete Transcript
Stop-Transcript