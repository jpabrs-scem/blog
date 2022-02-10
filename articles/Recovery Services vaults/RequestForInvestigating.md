---
title:  Azure Backup の障害調査に必要な情報
date: 2022-02-11 12:00:00
tags:
  -  Recovery Services vaults
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure Backup のバックアップ失敗、リストア失敗の時の調査をするにあたり、提供いただきたい情報をお伝えいたします。

## 目次
-----------------------------------------------------------
[1. Azure VM バックアップの障害調査に必要なログ](#1)
[  1-1 . Azure VM Backup の VSS 障害調査に追加で必要なログ](#1-1)
[2.   Azure VM バックアップ の ファイルレベル リストア (ILRリストア) 失敗調査に必要なログ](#2)
[3. Azure Backup for SAP HANA in Azure VM の調査に必要なログ](#3)

-----------------------------------------------------------


## 1. Azure VM バックアップの障害調査に必要なログ<a id="1"></a>
　*Azure VM Backup ではないですが  Azure Backup for SQL Server in Azure VM や Azure Backup for SAP HANA in Azure VM など Azure VM 上のDBのバックアップに関するものでも同様に必要です。
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
 **可能な限り "[A]"が望ましいですが、”[B]” でもある程度調査が可能な場合がございます。**
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
・実行したスクリプトおよび実行後に作成されたフォルダ一式
・(Windowsの場合) "ディスクの管理" の画面の画面ショット


![参考画像](https://user-images.githubusercontent.com/71251920/153464381-6ba8f9bf-56fd-48fd-9784-b819d8a4f79c.png)




## 3. Azure Backup for SAP HANA in Azure VM の調査に必要なログ<a id="3"></a>
 [1. Azure VM バックアップの障害調査に必要なログ](#1) に加えて下記もご対応お願いします。
*お手数ですが、全てのDBのbackup.log及びbackint.logのアップロードお願いします。

#### SAP HANAのbackup.log 及び backint.log 
>* xxにはインスタンスナンバーが入ります。
	・/hana/shared/HXE/HDBxx/<hostname>/trace/backup.log
	・/hana/shared/HXE/HDBxx/<hostname>/trace/DB_<DB名>/backup.log
	・/hana/shared/HXE/HDBxx/<hostname>/trace/backint.log
	・/hana/shared/HXE/HDBxx/<hostname>/trace/DB_<DB名>/backint.log
 
*上記パスに該当のログが無い場合は以下を試し、出てきたディレクトリの場所の log をアップロードしてください。
>	#sudo -i (rootユーザーに切り替えます)
	#cd / (ディレクトリの最上層に移動します)
	#find ./ -name “backup.log” (findコマンドにより該当のログの場所を特定します)
	#find ./ -name “backint.log” (findコマンドにより該当のログの場所を特定します)

