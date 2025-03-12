---
title: ログ バックアップのジョブを確認する方法
date: 2025-03-21 12:00:00
tags:
  - Information
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートです。 
 今回はお問合せをいただくことが多い、Azure Backup による SQL Server DB や SAP HANA DB のログ バックアップのジョブを確認する方法をご案内いたします。  

## 目次
-----------------------------------------------------------
[1. ログ バックアップのジョブの確認方法](#1)  
[2. 設定方法](#2)  
[3. 実行結果](#3)  
-----------------------------------------------------------

## <a id="1"></a> 1. ログ バックアップのジョブの確認方法  

Azure Backup による SQL Server DB や SAP HANA DB のログ バックアップのジョブは、実行回数が比較的多くなる傾向にあるため、**Azure Portal の Recovery Services コンテナーやビジネス継続センターのバックアップ ジョブ一覧には表示されません**。  

ログ バックアップのジョブをご確認いただくには、Recovery Services コンテナーの診断設定を構成し、Recovery Services コンテナーの診断イベントをストレージ アカウント / イベント ハブ / Log Analytics ワークスペースへ送信していただく必要がございます。  


## <a id="2"></a> 2. 設定方法  
ご利用の Recovery Services コンテナーの診断設定を構成する方法をご案内いたします。  

- 1. Azure Portal にてご利用の Recovery Services コンテナーを表示します  
- 2. Recovery Services コンテナーの ``[監視] > [診断設定] > [診断設定を追加する] `` を選択します  
  ![](./How_To_Check_Log_Backup_Jobs/Setting_Rsv_diagnostics_01.png)
- 3. 診断設定画面にて、まず [診断設定の名前] に任意の値を入力します  
- 4. 次に、[ログ] にて取得したいログのカテゴリを選択します  
  - ログ バックアップ ジョブのデータが含まれるカテゴリ ``Addon Azure Backup Job Data`` は必ずチェックを入れてください  
- 5. 最後に [宛先の詳細] に診断イベントの送信先を設定します  
  ![](./How_To_Check_Log_Backup_Jobs/Setting_Rsv_diagnostics_02.png)


診断設定の詳細につきましては、下記公式ドキュメントにも説明がございますので適宜ご確認ください。  
・ Azure Backup ユーザー向けの診断イベント - Azure Backup | Microsoft Learn
　 https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-diagnostic-events?tabs=recovery-services-vaults
・ リソース固有の診断イベントのデータ モデル - Azure Backup | Microsoft Learn
　 https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-reports-data-model?tabs=recovery-services-vaults#addonazurebackupjobs


## <a id="3"></a> 3. 実行結果  
## <a id="3.1"></a> 3.1 Log Analytics ワークスペースの例  
Recovery Services コンテナーの診断イベントを Log Analytics ワークスペースへ送信した場合には、テーブル ``AddonAzureBackupJobs`` からログ バックアップ ジョブをご確認いただくことが可能でございます。  
以下に、ログ バックアップ ジョブを確認するサンプル クエリ、および実行結果をご紹介いたします。  

- サンプル クエリ
```KQL
AddonAzureBackupJobs
| where BackupManagementType == "AzureWorkload"
| where JobOperationSubType == "Log"
| project JobStartDateTime, BackupItemUniqueId, OperationName, JobOperation, JobOperationSubType, JobStatus, JobFailureCode
| sort by JobStartDateTime asc
```
- 実行結果例
![](./How_To_Check_Log_Backup_Jobs/Result_LA.png)


> [!WARNING]
> 本記事でご案内しているクエリについては、お客様の責任のもと、ご利用いただきますようお願い申し上げます。  
> クエリ実行時のエラーや、想定外の問題について、当社は責任を負いかねますのでご了承ください。  


## <a id="3.2"></a> 3.2 ストレージ アカウントの例  
Recovery Services コンテナーの診断イベントをストレージ アカウントへ送信した場合には、xxx からログ バックアップ ジョブをご確認いただくことが可能でございます。  
以下に、ログ バックアップ ジョブを確認するサンプル クエリ、および実行結果をご紹介いたします。  

- サンプル クエリ
```KQL
AddonAzureBackupJobs
| where BackupManagementType == "AzureWorkload"
| where JobOperationSubType == "Log"
| project JobStartDateTime, BackupItemUniqueId, OperationName, JobOperation, JobOperationSubType, JobStatus, JobFailureCode
| sort by JobStartDateTime asc
```
- 実行結果例
![](./How_To_Check_Log_Backup_Jobs/Result_LA.png)

## <a id="3.3"></a> 3.3 イベント ハブの例  
Recovery Services コンテナーの診断イベントをイベント ハブへ送信した場合には、xxx からログ バックアップ ジョブをご確認いただくことが可能でございます。  
以下に、ログ バックアップ ジョブを確認するサンプル クエリ、および実行結果をご紹介いたします。  

- サンプル クエリ
```KQL
AddonAzureBackupJobs
| where BackupManagementType == "AzureWorkload"
| where JobOperationSubType == "Log"
| project JobStartDateTime, BackupItemUniqueId, OperationName, JobOperation, JobOperationSubType, JobStatus, JobFailureCode
| sort by JobStartDateTime asc
```
- 実行結果例
![](./How_To_Check_Log_Backup_Jobs/Result_LA.png)