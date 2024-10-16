#!/bin/bash

####To Test ONLY#####
#This script is for testing , You must not copy , and must not use commercially.
#version:1.0

## Usage
function usage {
  cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h          Display help
  -s StorageAccountName    Specify the Storage Account Name for URL checking.
  -i ApplianceIPaddress    Specify appliance's IP address for Network checking.
                           ex) -i 192.168.1.10
EOM
  exit 2
}

## Options
while getopts ":s:h" optKey; do
  case "${optKey}" in
    s)
      echo OPTARG is "${OPTARG}"
      URL_Storage="${OPTARG}".blob.core.windows.net
      ;;
    # i) # for Source To Appliance.
      # echo OPTARG is "${OPTARG}"
      # appliance_ip="${OPTARG}"
      # echo appliance_ip is "${appliance_ip}"
      # ;;
    '-h'|'--help'|* )
      usage >& 2
      ;;
  esac
done

## Init Process
LOGFILE="CheckNWResult_$(hostname -s)_$(date +'%Y%m%d%H%M').log"
echo "Starting..."
echo "ログファイルは ${LOGFILE} です。"

SECONDS=0
exec > "${LOGFILE}"
exec 2>&1


## V2A-modern test
{
## V2A-modern URLs
URL_V2A[0]=portal.azure.com
URL_V2A[1]=login.microsoftonline.com
URL_V2A[2]=graph.windows.net
URL_V2A[3]=aadcdn.msftauth.net
URL_V2A[4]=aadcdn.msauth.net 
URL_V2A[5]=download.microsoft.com 
URL_V2A[6]=login.live.com 
URL_V2A[7]=config.office.com 
URL_V2A[8]=login.microsoftonline.com
URL_V2A[9]=management.azure.com
URL_V2A[10]=dc.services.visualstudio.com
URL_V2A[11]=aka.ms
URL_V2A[12]=download.microsoft.com
URL_V2A[13]=prod.cus.discoverysrv.windowsazure.com 
URL_V2A[14]=pod01-srs1.jpw.hypervrecoverymanager.windowsazure.com
URL_V2A[15]=pod01-id1.jpw.backup.windowsazure.com

## functions
# TCP_port443_check 443 
function testNW443() {
echo "##TRY!! nc -vz ${1} 443 ##"
echo "================================================"
nc -vz $1 443
echo ""
}

function testNW9443() {
echo "##TRY!! nc -vz ${1} 9443 ##"
echo "================================================"
nc -vz $1 9443
echo ""
}

# Curl
function testcurl(){
echo "##TRY!! curl -I https://${1} ##"
echo "================================================"
curl -I https://$1
echo ""
}

# nslookup
function testdns(){
echo "================================================"
echo "##TRY!! nslookup  ${1} ##"
nslookup $1
echo ""
}

##### 環境情報確認
echo "#### 環境情報確認 ####" 
echo "## 実行しているマシンのホスト名は$(hostname -s)です。" 
echo "## 実行日次は$(date)です。"
echo ""
echo "## ip a コマンドの結果は以下です"
echo "================================================"
ip a
echo ""
echo "## hostnamectl コマンドの結果は以下です"
hostnamectl
echo ""
echo "##プロキシ設定状態(空白場合は場合は結果無し)"
echo "http_proxy コマンドの結果"
echo "${http_proxy}"
echo "https_proxy コマンドの結果"
echo "${https_proxy}"
echo "#### 環境情報確認終了 ####" 
echo ""
echo ""

#####実行部分
echo "## ## ## # ## ## ## ### # ## #### ## 疎通確認 ### ## ### ## ## # ## ## ## ### ## ####"
echo "### nc -vz が使えない場合、下記コマンドなどで install する必要があります。"
echo "### 例:) sudo yum install nmap"
echo "### 例:) sudo dnf install nmap"
echo "### 例:) sudo apt install nmap"
echo "### 例:) sudo zypper install nmap"
echo "# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## # "
echo ""

## Check conection to public
for i in "${URL_V2A[@]}"
do
    echo "### https://${i} の疎通確認 ###"
    testdns "${i}"
    testNW443 "${i}"
    testcurl "${i}"
    echo ""
done

# ## Check conection Source to appliance (local)
# testNW443 "${appliance_ip}"
# testNW9443 "${appliance_ip}"
}