---
title: Azure Backup の障害調査に必要な情報 (疎通確認)
date: 2022-06-24 12:00:00
tags:
  - Recovery Services vaults
  - 情報採取
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure Backup のバックアップ失敗、リストア失敗の時の調査をするにあたり、NW 観点で提供いただきたい情報をお伝えいたします。
NW 観点以外の情報採集提供依頼については下記をご覧ください
・Azure Backup の障害調査に必要な情報
https://jpabrs-scem.github.io/blog/RecoveryServicesVaults/RequestForInvestigating/

## 目次
-----------------------------------------------------------
[1. Windows VM における Azure Backup 疎通確認](#1)
[2. Linux VM における Azure Backup 疎通確認](#2)
[3. プライベート エンドポイント環境における Azure Backup 疎通確認](#3)
-----------------------------------------------------------


## 1. Windows VM における Azure Backup 疎通確認<a id="1"></a>
まず、下記 リンク先から疎通確認スクリプトのダウンロードをお願いします。
[Check_Backup_NW_ver1.6.zip](https://github.com/jpabrs-scem/blog/files/9391344/Check_Backup_NW_ver1.6.zip)
 

(スクリプト実行手順)
1. 疎通確認スクリプトをダウンロードし、展開してください。
※ ファイルの解凍パスワードは **“AzureBackup”** となります。
 
2. PowerShell を右クリックし、管理者として実行をクリックしてください。

 ![](https://user-images.githubusercontent.com/71251920/175529513-5196c393-be7b-439e-aba3-063969d1ce26.png)

3. PowerShell にて手順 1 で展開したスクリプトの場所に移動してください。
例 ) "Takato" というユーザーのデスクトップ上の PowerShell というフォルダ内にスクリプトをダウンロードしたときの移動コマンド
>cd C:\Users\Takato\Desktop\powershell
 
4. 以下コマンドを実行し、スクリプトを実行してください。
(現在画像とバージョンが異なりますが、同様の手順でございます。)
>.\Check_Backup_NW_ver1.4.ps1
![](https://user-images.githubusercontent.com/71251920/175529518-afd3ab91-e450-42b9-b7b6-310c6633cca1.png)
* 上記スクリプト実施時に実行ポリシーの制限によりスクリプトが実行できない場合はPowerShell を管理者権限で起動し、下記コマンドを実行し実行ポリシーを変更後、再度実行していただければ幸いでございます。
>Set-ExecutionPolicy Unrestricted
 
5. 以下のような “ScriptStart Completed” 出力がされるまで、お待ちください。
*コマンドの実行には、環境によって 20 分ほど要する場合がございます。20 分経っても完了しない場合は、control + c を押下して強制終了してください。

![](https://user-images.githubusercontent.com/71251920/175529520-b67e7eab-baef-4036-8c89-64ec9a86e40b.gif)
 
6. コマンド実行が完了すると、スクリプトと同じフォルダ内に以下のようなログファイルが出力されますので、弊社までご提供お願いいたします。
ログファイル名: AzureBackup_Check_NW_yyyymmdd_hhmmss.log

![](https://user-images.githubusercontent.com/71251920/175529523-b5004d01-f4cd-4879-9c48-b9de17a8c477.jpg)
* control + c にて強制終了した場合においても該当のログファイルが出力されますので、弊社までご提供お願いいたします。


## 2. Linux VM における Azure Backup 疎通確認<a id="2"></a>

まず、下記 リンク先から疎通確認スクリプトのダウンロードをお願いします。
[Check_Backup_NW_Linux_ver1.3.zip](https://github.com/jpabrs-scem/blog/files/9387864/Check_Backup_NW_Linux_ver1.3.zip)

(スクリプト実行手順)
1. 疎通確認スクリプトをダウンロードし、展開してください。
※ ファイルの解凍パスワードは **“AzureBackup”** となります。

2. 対象の Linux マシンにスクリプトを移動し実行します。
必要に応じて chmod コマンドなどを用いてパーミッションを変更してください。
>chmod 777 Check_Backup_NW_Linux_ver1.3.sh 

下記のように実行します。
>./Check_Backup_NW_Linux_ver1.3.sh

3. 実行完了
実行が完了すれば下記のファイルが作成されます。
弊社までご提供お願いいたします。
>ログファイルは CheckNWResult_(ホスト名)_(YYYYMMDDHHMM).log です。

### 2.1 参考画像
![-参考画像-](https://user-images.githubusercontent.com/71251920/185762249-d5dbed3c-9bce-409e-8a88-a5b43a52fe95.png)


## 3. プライベート エンドポイント環境における Azure Backup 疎通確認<a id="3"></a>
 Azure VM 上の DB のバックアップ (Azure  SQL VM Backup や　Azure SAP HANA バックアップ) や MARS エージェントを利用したバックアップで**プライベート エンドポイントをご利用の場合**は下記もご対応お願いします。

・必須の DNS エントリを取得する
https://learn.microsoft.com/ja-jp/azure/backup/private-endpoints#step-1-get-required-dns-entries

上記 URL に従って下記  PowerShell スクリプトをご実施いただき、名前解決ができるかおよび疎通確認をお願いします。

[PrivateIP.ps1](https://download.microsoft.com/download/1/2/6/126a410b-0e06-45ed-b2df-84f353034fa1/PrivateIP.ps1)

\*Azure PowerShell が実行できる (Az moduleがインストールされた) 環境でご実施ください。

・[ご参考] Install the Azure Az PowerShell module
https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-8.3.0



### 結果に "backup" が含まれる場合から1つの宛先に対する疎通確認
"privatlink" 付の FQDN に対して疎通確認を行ってください。
実施いただいたスクリプトの実行結果と後述の疎通確認コマンドの結果をテキスト(可能であれば画面ショットも添えて) zip などにおまとめの上ご提供お願いします。


>スクリプト実行結果例)
` ` \<vaultId>-ab-pod01-fc1      **privatelink**.eus.**backup**.windowsazure.com     10.12.0.15

スクリプトの実行結果が上記の場合は下記のようにお願いします。
また hosts ファイルをご利用の場合は nslookup コマンドの代わりに ping コマンドをご利用ください。

**windows(PowerShell)**
> nslookup(ping) \<vaultId>-ab-pod01-fc1.**privatelink**.eus.backup.windowsazure.com
> tnc -port 443 \<vaultId>-ab-pod01-fc1.**privatelink**.eus.backup.windowsazure.com
> tnc -port 443 10.12.0.15
>Invoke-WebRequest https://\<vaultId>-ab-pod01-fc1.**privatelink**.eus.backup.windowsazure.com
>Invoke-WebRequest https://10.12.0.15

**Linux**
> nslookup(ping) \<vaultId>-ab-pod01-fc1.**privatelink**.eus.backup.windowsazure.com
> nc -vz \<vaultId>-ab-pod01-fc1.**privatelink**.eus.backup.windowsazure.com
> nc -vz  10.12.0.15　443
> curl -I https://\<vaultId>-ab-pod01-fc1.**privatelink**.eus.backup.windowsazure.com
> curl -I https://10.12.0.15 

### 結果に "backup" が含まれない ("blob" や"queue"等が含まれる) 場合
こちらは初期調査では一旦不要です。