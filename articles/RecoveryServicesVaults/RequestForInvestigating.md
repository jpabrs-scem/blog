---
title:  Azure Backup の障害調査に必要な情報
date: 2022-02-11 12:00:00
tags:
  - Recovery Services vaults
  - 情報採取
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure Backup のバックアップ失敗、リストア失敗の時の調査をするにあたり、提供いただきたい情報をお伝えいたします。
なお、 Azure Backup の障害調査にあたり NW 観点で取得いただきたいログに関しては下記をご覧ください
・Azure Backup の障害調査に必要な情報 (疎通確認)
https://jpabrs-scem.github.io/blog/RecoveryServicesVaults/RequestForInvestigatingNW/

## 目次
-----------------------------------------------------------
[1. Azure VM バックアップの障害調査に必要なログ](#1)
  [  1-1. Azure VM Backup の VSS 障害調査に追加で必要なログ](#1-1)
[2.   Azure VM バックアップ の ファイルレベル リストア (ILRリストア) 失敗調査に必要なログ](#2)
[3. Azure Backup for SAP HANA in Azure VM の障害調査に必要なログ](#3)
[4. MARS Backup エージェントを利用したバックアップ の障害調査に必要なログ](#4)
  [4-1. Microsoft Azure Backup Agent のログ](#4-1)
  [4-2. システム情報](#4-2)
  [4-3. イベント ログ](#4-3)
-----------------------------------------------------------


## 1. Azure VM バックアップの障害調査に必要なログ<a id="1"></a>
　*Azure VM Backup ではないですが  Azure Backup for SQL Server in Azure VM や Azure Backup for SAP HANA in Azure VM など Azure VM 上の DB のバックアップに関するものでも同様に必要です。
下記の **環境情報**と**ログ情報**の収集をお願いいたします。

### 環境情報
・Subscription ID
・Recovery Services コンテナー名、およびそのリソースグループ名
・バックアップ対象 VM 名、およびそのリソースグループ名

#### ログ情報
下記を参考に zip などにまとめてご提供いただけますと幸いです。
#### ・Windows の場合
>C:\Windows\System32\winevt\Logs\
>C:\WindowsAzure\

#### ・Linuxの場合
>/var/log/

全量いただけることが望ましいですが、全量が困難な場合は下記をご提供ください。
>/var/log/azure/*
>/var/log/syslog*
>/var/log/waagent.*

### 1-1 . Azure VM Backup の VSS 障害調査に追加で必要なログ<a id="1-1"></a>
Azure VM Backupの下記のようなエラーが出ることがございます。
その場合には VSS 観点での調査が必要であるため、そのため上記 [1. Azure VM バックアップの障害調査に必要なログ](#1) に加えて下記のログの採取もお願いします。

>Error Code ：Snapshot operation failed due to VSS Writers in bad state.
Error Message ：ExtensionFailedVssWriterInBadState

VSS 観点での調査のためには下記 URL 先のログの採取をお願いします。
 **可能な限り "[A]"が望ましいですが、”[B]” の方法で採取いただいても、ある程度は調査が可能な場合がございます。**
・VSS エラーが発生している事象の調査 
https://jpwinsup.github.io/mslog/storage/vss/vss-error.html


また合わせて下記も関連するブログでございます。
・Azure VM Backupにおける整合性について
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#1-1-VSS-%E8%A6%B3%E7%82%B9%E3%81%A7%E3%81%AE%E8%AA%BF%E6%9F%BB%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6

## 2.   Azure VM バックアップ の ファイルレベル リストア (ILRリストア) 失敗調査に必要なログ<a id="2"></a>
下記の **環境情報**と**ログ情報**の収集をお願いいたします。
### 環境情報
・Subscription ID
・Recovery Services コンテナー名、およびそのリソースグループ名
・バックアップ対象 VM 名、およびそのリソースグループ名、OS 名
・リストア先の VM 名、およびそのリソースグループ名、OS 名

### ログ情報
zip などにまとめてご提供いただけますと幸いです。
#### ・(Windows の場合) "ディスクの管理" の画面の画面ショット
![参考画像](https://user-images.githubusercontent.com/71251920/153464381-6ba8f9bf-56fd-48fd-9784-b819d8a4f79c.png)

#### ・実行したスクリプト、および実行後に作成されたフォルダ一式
 - **Windowsの場合**
・スクリプトファイル：IaaSVMILRExeForWindows.exe
・スクリプト実行後に作成されるフォルダー："仮想マシン名(小文字)"+"スクリプトファイル実行日時"

　下記例では "okt-temp-win-20220212145642" が作成されています。
![](https://user-images.githubusercontent.com/71251920/153714819-e9f24f63-75f0-4268-b0fc-ac6e43155cc1.png)

"okt-temp-win-20220212145642"の中身
!["okt-temp-win-20220212145642"の中身](https://user-images.githubusercontent.com/71251920/153714818-906282be-7acc-4e9f-9d4e-62d5b2b369a0.png)

- **Linux の場合**
・ILRのスクリプトファイル：例)　**vm02kensho(小文字VM名)_1_jpe_6591639015130036692_802427195716_899298aac7c04bf094ad68bfc5b9584ed206b94b62d965.py**
・作成されたディレクトリの **Scripts ディレクトリ一式**：例） **vm02kensho-20220212151619/Script**
スクリプトを実行後、「**vm02kensho-20220212151619**」ディレクトリが自動生成されていることがわかる。
![](https://user-images.githubusercontent.com/71251920/153714817-892202e9-3df5-4377-9276-42b16eb82fd4.png)

 >ls -all

![「vm02kensho-20220212151619」ディレクトリが自動生成されている](https://user-images.githubusercontent.com/71251920/153714816-49b0446b-8728-498e-b51f-bff02f37f0a5.png)

「vm02kensho-20220212151619」ディレクトリの中身、および作成されたディレクトリの **Scripts ディレクトリ**の中身は下記の通り
 >ls -allR

![「vm02kensho-20220212151619」ディレクトリの中身,および作成されたディレクトリの Scripts ディレクトリの中身](https://user-images.githubusercontent.com/71251920/153714814-a652e630-b1c8-4e43-a96f-4d974c9d7cf4.png)

## 3. Azure Backup for SAP HANA in Azure VM の障害調査に必要なログ<a id="3"></a>
 [1. Azure VM バックアップの障害調査に必要なログ](#1) の **環境情報** ならびに **ログ情報 - Linuxの場合** に加えて下記もご対応お願いします。
*お手数ですが、全ての DB の backup.log 及び backint.log の採取をお願いします。

### SAP HANAのbackup.log 及び backint.log 
>* xxにはインスタンスナンバーが入ります。
	・/hana/shared/HXE/HDBxx/<hostname>/trace/backup.log
	・/hana/shared/HXE/HDBxx/<hostname>/trace/DB_<DB名>/backup.log
	・/hana/shared/HXE/HDBxx/<hostname>/trace/backint.log
	・/hana/shared/HXE/HDBxx/<hostname>/trace/DB_<DB名>/backint.log
 
*上記パスに該当のログが無い場合は以下を試し、コマンド実行結果に表示されディレクトリの場所の log をアップロードしてください。
>	#sudo -i (rootユーザーに切り替えます)
	#cd / (ディレクトリの最上層に移動します)
	#find ./ -name “backup.log” (findコマンドにより該当のログの場所を特定します)
	#find ./ -name “backint.log” (findコマンドにより該当のログの場所を特定します)

## 4. MARS Backup エージェントを利用したバックアップ の障害調査に必要なログ<a id="4"></a>

MARS バックアップ のバックアップ対象の環境が Azure VM の場合、[1. Azure VM バックアップの障害調査に必要なログ](#1) の **環境情報** ならびに **ログ情報 - Windows の場合** に加えて下記もご対応お願いします。*オンプレミス環境や Azure VM 以外の環境であれば不要です。

### 4.1 Microsoft Azure Backup Agent のログ　<a id="4-1"></a>
 まず、下記 リンク先から調査用スクリプトのダウンロードをお願いします。
[WABDiag.zip](https://github.com/jpabrs-scem/blog/files/8045897/WABDiag.zip)

ダウンロードいただきました WABDiag.tx を .ps1 に変更して使用し、問題が発生しているマシンより Azure Backup ログの収集をお願いいたします。
※ ファイルの解凍パスワードは "AzureBackup" となります。
 
1. WABDiag.ps1 を管理者権限の PowerShell で実行します。
 
  > 実行コマンド: <スクリプトのパス>\WABDiag.ps1 <パス\保存するフォルダ名>
   実行例: C:\WABDiag\WABDiag.ps1 C:\Logs
 
   実行結果にファイル パスが無い旨のメッセージが表示される可能性がございますが、対象のファイル自体が無い事を示すメッセージとなりますので、無視していただいて問題ございません。
 
 
#### PowerShell の実行ポリシーの制限によりスクリプトが実行できない場合
PowerShellを管理者権限で起動し、下記コマンドを実行し実行ポリシーを変更後、再度実行していただけますでしょうか。
>コマンド：Set-ExecutionPolicy Unrestricted

また現在の実行ポリシーを後ほど元に戻す場合は、変更前に下記コマンドを実行し、設定されているポリシーを確認、メモし、スクリプト実行後に同様の手順で変更していただきますようお願いいたします。
>コマンド：Get-ExecutionPolicy 
 
 - 参考
 ・実行ポリシーについて - PowerShell 
 https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2

###  4.2 システム情報 <a id="4-2"></a>
1. 対象のマシンに管理者権限を保持するユーザーでログオンします。
2. 管理者権限でコマンド プロンプトを起動し、以下のコマンドで取得します。
  > msinfo32 /nfo <出力ファイル名> 
  実行例)  > msinfo32 /nfo SVR_msinfo32.nfo
3. 生成されたファイルをご提供ください。
 

### 4.3 イベント ログ<a id="4-3"></a>
1. 対象のマシンに管理者権限を保持するユーザーでログオンします。
2. [スタート] - [管理ツール] - [イベント ビューアー] を開きます。
3. 左側ペインの以下のイベントに対して、右クリックをし、[すべてのイベントを名前をつけて保存] を選択し、ファイルの種類が "イベント ファイル (*.evtx)" であることを確認し、任意の名前を付けて、[保存] をクリックします。
   (ファイルの種類が "イベント ファイル (*.csv)" も併せて取得をお願いいたします) 
a) [イベント ビューアー (ローカル)] - [Windows ログ] - [システム]
b) [イベント ビューアー (ローカル)] - [Windows ログ] - [Application]
4. 保存したイベント ログ ファイルをご提供ください。