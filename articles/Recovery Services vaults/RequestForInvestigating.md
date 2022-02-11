---
title:  Azure Backup の障害調査に必要な情報
date: 2022-02-11 12:00:00
tags:
  -  Recovery Services vaults
  - 情報採取
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure Backup のバックアップ失敗、リストア失敗の時の調査をするにあたり、提供いただきたい情報をお伝えいたします。

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
#### 環境情報
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

### 1-1 . Azure VM Backup の VSS 障害調査に追加で必要なログ
Azure VM Backupの下記のようなエラーが出ることがございます。
その場合には VSS 観点での調査が必要であるため、そのため上記に加えて下記のログの採取もお願いします。

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
#### 環境情報
・Subscription ID
・Recovery Services コンテナー名、およびそのリソースグループ名
・バックアップ対象 VM 名、およびそのリソースグループ名、OS 名
・リストア先の VM 名、およびそのリソースグループ名、OS 名

#### ログ情報
zip などにまとめてご提供いただけますと幸いです。
・実行したスクリプト、および実行後に作成されたフォルダ一式
・(Windows の場合) "ディスクの管理" の画面の画面ショット


![参考画像](https://user-images.githubusercontent.com/71251920/153464381-6ba8f9bf-56fd-48fd-9784-b819d8a4f79c.png)




## 3. Azure Backup for SAP HANA in Azure VM の障害調査に必要なログ<a id="3"></a>
 [1. Azure VM バックアップの障害調査に必要なログ](#1) に加えて下記もご対応お願いします。
*お手数ですが、全ての DB の backup.log 及び backint.log の採取をお願いします。

#### SAP HANAのbackup.log 及び backint.log 
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

[1. Azure VM バックアップの障害調査に必要なログ](#1) に加えて下記もご対応お願いします。

### 4.1 Microsoft Azure Backup Agent のログ　<a id="4-1"></a>
 まず、下記 リンク先から調査用スクリプトのダウンロードをお願いします。
[WABDiag.zip](https://github.com/jpabrs-scem/blog/files/8045897/WABDiag.zip)

ダウンロードいただきました WABDiag.tx を .ps1 に変更して使用し、問題が発生しているマシンより Azure Backup ログの収集をお願いいたします。
※ ファイルの解凍パスワードは "AzureBackup" となります。
 
1. WABDiag.ps1 を管理者権限の PowerShell で実行します。
 
  > 実行コマンド: <スクリプトのパス>\WABDiag.ps1 <パス\保存するフォルダ名>
   実行例: C:\WABDiag\WABDiag.ps1 C:\Logs
 
   実行結果にファイル パスが無い旨のメッセージが表示される可能性がございますが、
   対象のファイル自体が無い事を示すメッセージとなりますので、無視していただいて
   問題ございません。
 
 
#### PowerShell の実行ポリシーの制限によりスクリプトが実行できない場合
PowerShellを管理者権限で起動し、下記コマンドを実行のし実行ポリシーを変更後、再度実行していただけますでしょうか。
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