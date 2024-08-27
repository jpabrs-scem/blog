---
title: AzureBackupProtectionLock について
date: 2024-08-28 00:00:00
tags:
  - Azure Files Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。  
Azure ファイル共有のバックアップを構成すると、バックアップ データやストレージ アカウントが誤って削除されないように、削除ロック 「AzureBackupProtectionLock」 がストレージ アカウントに設定されます。 
今回は、Azure ファイル共有のバックアップによって、ストレージ アカウントに設定される削除ロック 「AzureBackupProtectionLock」 についてご案内します。  

## 目次
-----------------------------------------------------------
[AzureBackupProtectionLock とは](#1)  
[AzureBackupProtectionLock が設定されるタイミング](#2)  
[AzureBackupProtectionLock を一時的に削除する方法](#3)  
[AzureBackupProtectionLock を設定させない方法](#4)  
-----------------------------------------------------------

## <a id="1"></a>AzureBackupProtectionLock とは
Azure ファイル共有のバックアップでは、Azure ファイル共有のスナップショット機能を利用し、バックアップを取得しておりますが、Azure ファイル共有のスナップショットは、ストレージ アカウントが削除されると、全てのスナップショットが併せて削除されます。  
そのため、Azure ファイル共有のバックアップでは、Azure Backup サービスによって取得されたバックアップ (スナップショット) が誤って削除されないように、バックアップ対象の Azure ファイル共有がデプロイされているストレージ アカウントに対して、削除ロック 「AzureBackupProtectionLock」 を設定いたします。  

- ストレージ アカウントのロックを有効にすることが推奨されるのはなぜですか?  
  Azure Files のバックアップに関する FAQ - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-files-faq#-------------------------------------  
  抜粋 :

> ストレージ アカウントが削除されると、すべてのスナップショットが失われます。 **誤って削除されないようにアカウントを保護するため、Azure Backup によってストレージ アカウントに削除ロックが設定されます。** つまり、許可されているユーザーはリソースを読んだり変更したりできますが、削除することはできません。 また、このロックにより、ストレージ アカウントの下にあるファイル共有の削除も制限されます。 そのため、ストレージ アカウントとファイル共有の両方が不注意による削除から保護されます。  

(例)  
- ロック名 : ``AzureBackupProtectionLock``  
- ロックの種類 : 削除  
- スコープ : ストレージ アカウント  
- メモ : ``Auto-created by Azure Backup for storage accounts registered with a Recovery Services Vault. This lock is intended to guard against deletion of backups due to accidental deletion of the storage account. (Recovery Services Vaultに登録されているストレージアカウントに対してAzure Backupによって自動的に作成されます。このロックは、ストレージアカウントの誤った削除によるバックアップの削除を防ぐことを目的としています。)``  
![](https://github.com/user-attachments/assets/6521b8f8-67f1-4b48-863f-41afb943fbd3)


## <a id="2"></a>AzureBackupProtectionLock が設定されるタイミング
削除ロック 「AzureBackupProtectionLock」 は、主に下記のタイミングで設定されます。  
- Azure ファイル共有のバックアップが構成されたとき  
  (より正確には、ストレージ アカウントが Recovery Services コンテナーのバックアップ インフラストラクチャとして登録されたとき)  
- Azure ファイル共有のバックアップが実行されたとき  

削除ロック 「AzureBackupProtectionLock」 を手動削除したとしても、Azure ファイル共有のバックアップが実行されると、削除ロック 「AzureBackupProtectionLock」 が自動設定されます。  


## <a id="3"></a>AzureBackupProtectionLock を一時的に削除する方法
ファイル共有にアップロードしている一部ファイルを削除したいなどのシナリオにおいては、削除ロック 「AzureBackupProtectionLock」 を手動で削除してください。  

前提条件 :  
削除ロックを削除するには、作業を行うユーザーが対象のストレージ アカウントに対して、``Microsoft.Authorization/*`` または ``Microsoft.Authorization/locks/*`` アクションにアクセス可能である必要がございます。 (組み込みロールでは、**所有者** もしくは **ユーザー アクセス管理者ロール** の割り当てが必要となります。)  
削除ロックの作業を行う前に、予め上記アクセス許可を行ってください。  

- 誰がロックを作成または削除できるか / ロックを使って Azure リソースを保護する - Azure Resource Manager | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/azure-resource-manager/management/lock-resources?tabs=json#who-can-create-or-delete-locks  
  抜粋 :

> 管理ロックを作成または削除するには、``Microsoft.Authorization/*`` または ``Microsoft.Authorization/locks/*`` アクションにアクセスする必要があります。**所有者**と**ユーザー アクセス管理者ロール**に割り当てられているユーザーには、必要なアクセス権があります。  


手順 :  
1. 削除ロック 「AzureBackupProtectionLock」 を削除する  
ストレージ アカウントの ``設定 > ロック`` へアクセスし、削除ロック 「AzureBackupProtectionLock」 を削除します  
![](https://github.com/user-attachments/assets/5b358e3c-edfc-4a9c-90c4-71a540581f69)

1. (不要なファイル削除などの作業完了後) 削除ロック 「AzureBackupProtectionLock」 を再設定する  
   - ストレージ アカウントの ``設定 > ロック`` へアクセスし、削除ロックを追加します  
     ![](https://github.com/user-attachments/assets/a736e344-22d9-4009-86be-c357f3392602)  
   - もしくは、Azure ファイル共有のオンデマンド バックアップを手動で実行します (自動的に、削除ロック 「AzureBackupProtectionLock」 が設定されます)  
     詳細な手順につきましては、下記ドキュメントをご確認ください。  
     - オンデマンド バックアップの実行手順 :  
       オンデマンド バックアップ ジョブを実行する / Azure portal で Azure ファイル共有をバックアップする - Azure Backup | Microsoft Learn  
       https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-files?tabs=backup-center#run-an-on-demand-backup-job  


## <a id="4"></a>AzureBackupProtectionLock を設定させない方法
Azure ファイル共有のバックアップ構成時に、ストレージ アカウントのロック無効化設定を行うことで、削除ロック 「AzureBackupProtectionLock」 を設定せずに、Azure ファイル共有のバックアップを構成 / 取得いただくことが可能となります。  

> [!IMPORTANT]  
> Azure Backup サービスといたしましては、**削除ロック 「AzureBackupProtectionLock」 を有効化していただくことを推奨**いたします。  
> もし削除ロック 「AzureBackupProtectionLock」 を設定せずにバックアップを構成し、意図せずスナップショットが消失したとしても、基本的には弊社側での復旧対応は致しかねますこと、予めご了承ください。  

手順 :  
- Recovery Services コンテナーからバックアップを構成する場合  
  Recovery Services コンテナーの ``はじめに > バックアップ > Azure ファイル共有のバックアップ構成`` にアクセスします。  
  ![](https://github.com/user-attachments/assets/d0ab1a1b-fa35-4c44-b371-1bde80209c07)  
  バックアップの構成画面のストレージ アカウントの選択時に、**「ストレージ アカウントのロックを有効にする」のチェックを外してください**。  
  ![](https://github.com/user-attachments/assets/65a4c4c8-c800-4d04-ab2a-ce8512be102a)

- Azure ファイル共有からバックアップを構成する場合  
  Azure ファイル共有の ``操作 > バックアップ`` へアクセスし、**「Storage account lock」のトグル ボタンを無効にしてください**。
  ![](https://github.com/user-attachments/assets/9535dd6e-f3b9-41c5-bfc6-a6fc4cfe0d45)

> [!WARNING]  
> Azure ファイル共有を新規作成する際に表示される Azure Backup 構成画面では、ストレージ アカウントのロックを無効化させる設定は行えません。  
> もしストレージ アカウントのロックを無効化させたい場合には、**バックアップを構成せずに** Azure ファイル共有を作成し、その後に Azure Backup を構成してください。  
> ![](https://github.com/user-attachments/assets/7df7d32c-6273-4e1f-9529-62e6afd16609)

> [!WARNING]  
> 同じストレージ アカウントにデプロイされている、他の Azure ファイル共有で既に Azure Backup を構成している場合には、ストレージ アカウントが Recovery Services コンテナーのバックアップ インフラストラクチャとして既に登録されているため、ストレージ アカウントのロック無効化設定が行えません。  
> ストレージ アカウントのロック無効化設定が行えるのは、Recovery Services コンテナーのバックアップ インフラストラクチャに登録されていないストレージ アカウントにデプロイされている Azure ファイル共有のバックアップを構成する時のみ (ストレージ アカウント配下の Azure ファイル共有全てにおいて、Azure Backup が構成されていないとき) であることにご注意ください。  