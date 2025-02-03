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
EOM

  exit 2
}

## Options
while getopts ":s:h" optKey; do
  case "${optKey}" in
    s)
      StorageName="${OPTARG}"
      ;;
    '-h'|'--help'|* )
      usage >& 2
      ;;
  esac
done

## Init Process
LOGFILE="CheckNWResult_$(hostname -s)_$(date +'%Y%m%d%H%M').log"
echo "Starting..."
echo "ログファイルは ${LOGFILE} です。"

## A2A URLs
URL_A2A[0]=login.microsoftonline.com
URL_A2A[1]=pod01-rcm1.jpw.hypervrecoverymanager.windowsazure.com
URL_A2A[2]=pod01-rcm1.jpe.hypervrecoverymanager.windowsazure.com

if [ -n "${StorageName}" ]; then
  echo "StorageAccount名は ${StorageName} です。"
  URL_A2A[3]=${StorageName}.blob.core.windows.net
fi 

## Exec
SECONDS=0
exec > "${LOGFILE}"
exec 2>&1

## functions
# TCP_port443_check 443 
function testNW443() {
echo "##TRY!! nc -vz ${1} 443 ##"
echo "================================================"
nc -vz $1 443
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

for i in "${URL_A2A[@]}"
do
    echo "### https://${i} の疎通確認 ###"
    testdns "${i}"
    testNW443 "${i}"
    testcurl "${i}"
    echo ""
done