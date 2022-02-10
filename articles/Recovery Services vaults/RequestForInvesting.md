---
title:  Azure Backup の障害調査に必要な情報
date: 2022-02-12 12:00:00
tags:
  -  Recovery Services vaults
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure  Backup バックアップ失敗、リストア失敗の時の調査をするにあたりまず、ご提供いただきたい情報をお伝えいたします。


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

### 1-1 . Azure VM Backup の　VSS 障害調査に追加で必要なログ
Azure VM Backupの下記のようなエラーが出ることがございます。
その場合には VSS 観点での調査が必要であるため、そのための上記に加えてログの採取をお願いします。

>Error Code ：Snapshot operation failed due to VSS Writers in bad state.
Error Message ：ExtensionFailedVssWriterInBadState

VSS 観点での調査のためには下記 URL 先のログの採取をお願いします。
 **可能な限り "[A]"が望ましいですが、”[B]” でもある程度調査が可能な場合がございます。**
・VSS エラーが発生している事象の調査 
https://jpwinsup.github.io/mslog/storage/vss/vss-error.html



## 2.   Azure VM バックアップ の ファイルレベル リストア (ILRリストア) 失敗調時にご提供いただきたいログ
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




## 3. Azure Backup for SAP HANA in Azure VM の調査に必要なログ
 [1. Azure VM バックアップの障害調査に必要なログ](#1) に加えて下記もご対応お願いします。
*お手数ですが、全てのDBのbackup.log及びbackint.logのアップロードお願いします。

<SAP HANAのbackup.log及びbackint.log> 
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


-----------------------------------------------------------

まず、Azure VM Backup における整合性は下記の３種類ございます。
・アプリケーション整合性 (Application-consistent)
![2022-02-11_00h49_03](https://user-images.githubusercontent.com/71251920/153444342-2ef78226-36af-42ec-b791-def280af289e.png)


・ファイルシステム整合性 (File-system consistent)
![2022-02-11_00h49_22](https://user-images.githubusercontent.com/71251920/153444335-2c65943d-8f13-4c6d-b2d0-7bf4283b6fc4.png)


・クラッシュ整合性 (Crash-consistent)
![2022-02-11_00h49_36](https://user-images.githubusercontent.com/71251920/153444341-0b61bf0e-5b58-4040-a0ef-c0d213a2187b.png)

なお、公開情報は下記にございますのでまず一度ご一読ください。
その前提で説明させていただきます。

- 参考
・Azure VM バックアップの概要 スナップショットの整合性
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-consistency

