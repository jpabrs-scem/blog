---
title: Azure Disk Backup を意図的に失敗させる方法
date: 2023-01-11 12:00:00
tags:
  - Azure Disk Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
アラートのテスト等のため “Azure Disk Backup を失敗させたい” というお問い合わせをよくいただきます。
今回は、Azure Disk Backup を意図的に失敗させる方法として、Azure Disk Backup 構成したディスクを削除して、バックアップ ジョブを失敗させる方法をご紹介いたします。

・Azure ディスク バックアップの概要
　https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-overview

## 目次
-----------------------------------------------------------
[1. Azure Disk Backup を意図的に失敗させる方法](#1)
[2. その他ブログで公開している Azure Backup の失敗方法](#2)
-----------------------------------------------------------

### <a id="1"></a> 1. Azure Disk Backup を意図的に失敗させる方法
(1) とある Azure Managed Disk に対して、Azure Disk Backup を構成し、バックアップ取得しておきます。

・Azure Managed Disks のバックアップ
　https://learn.microsoft.com/ja-jp/azure/backup/backup-managed-disks

下図は例として、Azure Managed Disk「tmpDiskforAzureDiskBackup01」を Azure Disk Backup にてバックアップ構成している状態です。
![バックアップ構成済](https://user-images.githubusercontent.com/96324317/211466707-79d9b00e-4aef-44ee-96be-a1b8a9c4fd4f.png)

アラートが生成されることを確認するため、今回は「Azure Monitor を使用した組み込みのアラート」を、「スコープ：Azure Disk Backup を構成しているバックアップ コンテナー」にて構成しています。

・Azure Backup の Azure Monitor アラート
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor?tabs=recovery-services-vaults#azure-monitor-alerts-for-azure-backup

・「Azure Monitor を使用した組み込みのアラート」を利用したバックアップ ジョブ失敗のアラート通知作成例
　https://jpabrs-scem.github.io/blog/AzureBackupGeneral/How_to_set_Backup_Alert/

![アラート 処理ルール](https://user-images.githubusercontent.com/96324317/211467521-063fe1a2-4480-4191-b7cc-8caad114dbb8.png)

(2) バックアップ構成した Azure Managed Disk リソースを削除します。
![ディスク削除01](https://user-images.githubusercontent.com/96324317/211467577-a01b51c5-a837-4816-b6d8-8a7625667485.png)

![ディスク削除02](https://user-images.githubusercontent.com/96324317/211467614-9a5f9cc7-743b-4e08-8497-923fe41a6f09.png)

(3) Azure Disk Backup の「今すぐバックアップ」を実行します。
 
![今すぐバックアップ](https://user-images.githubusercontent.com/96324317/211467662-9e0fa822-6330-4f9f-b078-c5acaf0ccefb.png)

(4) 約 1 - 2 分後に、バックアップ ジョブが「UserErrorManagedDiskNotFound」エラーにて失敗します。
![バックアップ ジョブ01](https://user-images.githubusercontent.com/96324317/211467719-ddb8638a-3527-4c8f-bda2-20c97c37ade1.png)

![バックアップ ジョブ02](https://user-images.githubusercontent.com/96324317/211467751-01b098ab-7af6-43bb-a1ed-c9c24838d0c2.png)

(5) 「Azure Monitor を使用した組み込みのアラート」などのアラートにて、アラートを構成/メール通知構成をしていれば、下図のようなメールにてアラートが通知されます。
![アラート メール](https://user-images.githubusercontent.com/96324317/211467800-547d8351-3bd6-47f5-b0ca-7b475d0b7542.png)

### <a id="2"></a> 2. その他ブログで公開している Azure Backup の失敗方法
・Azure VM Backup を意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/AzureVMBackup/How_to_fail_VM_backup/

・Azure VM Backup のデータ転送フェーズを意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/AzureVMBackup/How_to_fail_ttv/

・MARS バックアップ を意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/MARSBackup/How_to_fail_MARS_backup/

・Azure Files Backup を意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/AzureFilesBackup/How_to_fail_AFS_backup/