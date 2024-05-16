####To Test ONLY#####
#This script is for testing , You must not copy , and must not use commercially.
#For Azure Backup Connections for Azure HANA DB BACKUP , ILR Restore , not via proxy server.
#version:1.4
#Copyright:tatsumiyamamoto


#!/bin/sh
LOGFILE="CheckNWResult_$(hostname -s)_$(date +'%Y%m%d%H%M').log"
echo "Starting..."
echo "ログファイルは ${LOGFILE} です。"

{
SECONDS=0
exec > "${LOGFILE}"
exec 2>&1

#####関数設定######
#NW確認 443 
function testNW443 () {
echo "##TRY!! nc -vz ${1} 443 ##"
nc -vz $1 443
echo ""
}

#NW確認3260 
function testNW3260 () {
echo "##TRY!! nc -vz ${1} 3260 ##"
nc -vz $1 3260
echo ""
}

#Curl
function testcurl(){
echo "##TRY!! curl -I https://${1} ##"
curl -I https://$1
echo ""
}

#nslookup
function testdns(){
echo "##TRY!! nslookup  ${1} ##"
nslookup $1
echo ""
}


###宛先変数設定
##ILR宛先
#AzureFrontDoor.FirstParty
URL_ILR1=download.microsoft.com
#AzureBackup
URL_ILR2=pod01-rec2.jpw.backup.windowsazure.com
URL_ILR3=pod01-rec2.jpe.backup.windowsazure.com

##AAD/Backup/Storage代表宛先
##AAD
URL_AAD56_1=login.microsoft.com
URL_AAD56_2=login.windows.net
URL_AAD56_3=loginex.microsoftonline.com

##Backup
URL_backup1=pod01-manag1.jpe.backup.windowsazure.com
URL_backup2=pod01-prot1.jpe.backup.windowsazure.com

##Storage
URL_Storage1=ceuswatcab01.blob.core.windows.net
URL_Storage2=weus2watcab01.blob.core.windows.net
URL_Storage3=md-dlbrhcw4gn5r.z33.blob.storage.azure.net



#####環境情報確認
echo "#### 環境情報確認 ####" 
echo "## 実行しているマシンのホスト名は$(hostname -s)です。" 
echo "## 実行日次は$(date)です。"
echo ""
echo "## ip a コマンドの結果は以下です"
ip a
echo ""
echo "## hostnamectl コマンドの結果は以下です"
hostnamectl
echo ""
echo "##プロキシ設定状態(空白場合は場合は結果無し)"
echo "http_proxy コマンドの結果"
echo $http_proxy
echo "https_proxy コマンドの結果"
echo $https_proxy
echo "#### 環境情報確認終了 ####" 
echo ""
echo ""

#####実行部分
echo "## ## ## # ## ## ## ### # ## #### ## 疎通確認 ### ## ### ## ## # ## ## ## ### ## ####"
echo "### nc -vz が使えない場合、下記コマンドなどで install する必要がある。"
echo "### 例:) sudo yum install nmap"
echo "### 例:) sudo dnf install nmap"
echo "### 例:) sudo apt install nmap"
echo "### 例:) sudo zypper install nmap"
echo "# ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## # "
echo ""
echo ""

echo "#### ILR の宛先疎通確認 ####"
echo "### Servicetag : AzureFrontDoor.FirstParty の疎通確認 ###"
testdns $URL_ILR1
testNW443 $URL_ILR1
echo ""
echo "### Servicetag : AzureBackup の疎通確認 ###"
testdns $URL_ILR2
testNW3260 $URL_ILR2
testdns $URL_ILR3
testNW3260 $URL_ILR3
echo ""
echo ""

echo "#### Backup / Storage / AAD の代表宛先への疎通確認 ####"
echo "### Servicetag : AzureBackup の疎通確認 ###"
testdns $URL_backup1
testdns $URL_backup2
testNW443 $URL_backup1
testNW443 $URL_backup2
testcurl $URL_backup1
testcurl $URL_backup2
echo ""

echo "### Servicetag : Storage の疎通確認 ###"
testdns $URL_Storage1
testdns $URL_Storage2
testdns $URL_Storage3
testNW443 $URL_Storage1
testNW443 $URL_Storage2
testNW443 $URL_Storage3
testcurl $URL_Storage1
testcurl $URL_Storage2
testcurl $URL_Storage3
echo ""

echo "### Servicetag : AzureActiveDirectory の疎通確認 ###"
testdns $URL_AAD56_1
testdns $URL_AAD56_2
testdns $URL_AAD56_3
testNW443 $URL_AAD56_1
testNW443 $URL_AAD56_2
testNW443 $URL_AAD56_3
testcurl $URL_AAD56_1
testcurl $URL_AAD56_2
testcurl $URL_AAD56_3
echo ""


echo "Complete..."

echo "[INFO] Script time is ${SECONDS}sec."

}
