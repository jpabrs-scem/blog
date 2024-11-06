---
title: Azure VM Backup を意図的に失敗させる方法
date: 2024-11-5 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
アラートのテスト等のため "Azure VM Backup を失敗させたい" というお問い合わせをよくいただきます。
今回は、**Azure VM Backup を意図的に失敗させる方法**について、ご案内いたします。

(その他ブログで公開している Azure Backup の失敗方法)
・Azure VM Backup のデータ転送フェーズを意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/AzureVMBackup/How_to_fail_ttv/

・MARS バックアップ を意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/MARSBackup/How_to_fail_MARS_backup/

・Azure Files Backup を意図的に失敗させる方法
　https://jpabrs-scem.github.io/blog/AzureFilesBackup/How_to_fail_AFS_backup/

## 1. バックアップを故意に失敗させる方法 (共有ディスクをアタッチする)<a id="1"></a>
「共有ディスクを一時的にアタッチしてバックアップ ジョブを失敗させる」 方法をご紹介します。  
Azure VM Backup において、共有ディスクのバックアップはサポートされていません。  
この仕様を利用して、共有ディスクを対象の VM にアタッチすることでバックアップの失敗を意図的に発生させることが可能です。  
この方法では、バックアップ ジョブ開始直後 ～ 30 分程度で 「UserErrorSharedDiskBackupNotSupported」 エラーで失敗する見込みです。

・VM ストレージのサポート | Azure VM バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
　https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#vm-storage-support

### 1.1.詳細手順
バックアップ 対象の VM に、Azure ポータル画面上で一時的に共有ディスクを追加アタッチします。
・Azure マネージド ディスクに対して共有ディスクを有効にする - Azure Virtual Machines | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/virtual-machines/disks-shared-enable?tabs=azure-portal

![image01](./How_to_fail_VM_backup/How_to_fail_VM_backup_01.png)

(「SharedDisk02」は、共有ディスクリソースになっています)
![image02](./How_to_fail_VM_backup/How_to_fail_VM_backup_02.png)

「今すぐバックアップ」をトリガーします。
![image03](./How_to_fail_VM_backup/How_to_fail_VM_backup_03.png)

バックアップ ジョブ開始直後 ～ 30 分程度でバックアップ ジョブが「UserErrorSharedDiskBackupNotSupported」エラーにて失敗する見込みです。
![image04](./How_to_fail_VM_backup/How_to_fail_VM_backup_04.png)

![image05](./How_to_fail_VM_backup/How_to_fail_VM_backup_05.png)

バックアップ ジョブ エラーを確認した後は、一時的にアタッチしていた共有ディスクをデタッチします。

Azure VM Backup を意図的に失敗させる方法について、ご案内は以上となります。