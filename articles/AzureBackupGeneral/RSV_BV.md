---
title:  Recovery Services コンテナーとバックアップ コンテナーについて
date: 2023-03-23 12:00:00
tags:
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートの山本です。
今回は、 Azure バックアップソリューションので利用する Recovery Services コンテナーとバックアップ コンテナーのバックアップ対象の違いについてご説明させていただきます。
 Recovery Services コンテナーとバックアップ コンテナーはバックアップ対象(バックアップソリューション)の違いにより使い分ける必要がございます。
 また、**バックアップセンターは サブスクリプション内の Recovery Services コンテナーやバックアップ コンテナー (およびそれぞれのコンテナーでバックアップしているバックアップアイテム) を統合管理するための管理画面です。**

![ Azure Backup 関連のリソース](https://user-images.githubusercontent.com/71251920/216895782-33a2539d-b199-466a-ba15-1184b2ad0552.png)




## 目次
-----------------------------------------------------------
[1. バックアップソリューションとコンテナー、およびデータ保存先の比較表](#1)
[2. コンテナーにバックアップデータが保存されないもの](#2)
[2-1. Azure ファイル共有バックアップ](#2-1)
[2-2. Azure Blob バックアップ](#2-2)
[2-3. Azure ディスク バックアップ](#2-3)
-----------------------------------------------------------

### <a id="1"></a>1. バックアップソリューションとコンテナー、およびデータ保存先の比較表
 各 Azure バックアップのソリューションがどのコンテナーを利用するか、またデータの保存先についても下記の通りおまとめいたしました。
 また、各ソリューションには各ソリューションの Docs へのリンクも付けております。

| # | バックアップソリューション | 利用するコンテナー | コンテナーにバックアップデータを保存するか|
| :--- | :--- | :--- |:---|
| 1 | [Azure VM バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction) |  Recovery Services コンテナー |する|
| 2 | [MARS バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-about-mars) |  Recovery Services コンテナー |する|
| 3 | [MABS バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-microsoft-azure-backup) |   Recovery Services コンテナー|する|
| 4 | [SQL in Azure VM バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sql-database) |   Recovery Services コンテナー|する|
| 5 | [SAP HANA DB in Azure VM バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-about) |   Recovery Services コンテナー|する|
| 6 | [Azure ファイル共有バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-backup-overview) |   Recovery Services コンテナー|**しない(注1)**|
| 7 | [Azure Blob バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-overview)  |   バックアップ コンテナー|**しない(注2)**|
| 8 | [Azure ディスク バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-overview)  |   バックアップ コンテナー|**しない**|
| 9 | [Azure PosgreSQL バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql-overview)  |   バックアップ コンテナー|する|

+ **(注1) 2023年3月現在  Azure Files Backup のコンテナー層へのBackup機能が Private Preview となりました。**
・Private Preview: Azure Backup enables vaulted backups for Azure Files for comprehensive data protection.
https://azure.microsoft.com/ja-JP/updates/azurefilesvaultedbackups-2/

+ **(注2) 2023年3月現在  Azure Blob バックアップのコンテナー層へのBackup機能が Public Preview となりました。**
・Public Preview: Azure Backup enables vaulted backups for Azure Blob for comprehensive data protection.
https://azure.microsoft.com/ja-JP/updates/azureblobvaultedbackups/

### <a id="2"></a>2.コンテナーにバックアップデータが保存されないもの
上述のとおり、Azure ファイル共有バックアップ、Azure Blob バックアップ、Azure ディスク バックアップは各コンテナーにはバックアップデータは転送されません。
それぞれについて簡単にご説明させていただきます。
共通している点はそれぞれのソリューションはコアとなる別のソリューションをバックアップサービス側からトリガーし実現している点でございます。


#### <a id="2-1"></a>2-1. Azure ファイル共有バックアップ
Azure ファイル共有 バックアップは Azure Files の共有スナップショットの機能をバックアップサービスと連携することによりスナップショット取得の自動化、スナップショットの削除の自動化を実現したバックアップソリューションです。

そのため、バックアップデータ (スナップショットデータ) の保存先はAzure Files の共有スナップショットと同じく、そのストレージ アカウント自身 (のスナップショット領域)となります。
そのため、 Recovery Services コンテナーには転送されません。
下記のように**Azure ファイル共有のスナップショット リソースとしてよって、Azure ファイル共有バックアップにて取得されたスナップショットも確認可能です**。("発信側" が "AzureBackup" となっているものです)
![](https://user-images.githubusercontent.com/71251920/198350606-969ef3b9-0c2a-4744-9940-87c41936cb09.png)


・バックアップ プロセスのしくみ - Azure ファイル共有のバックアップについて
https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-backup-overview
>抜粋：ファイル共有データは Backup サービスには転送されません。これは、Backup サービスでは、ストレージ アカウントの一部であるスナップショットの作成および管理が行われ、バックアップはコンテナーに転送されないからです。

・Azure Files の共有スナップショット
https://learn.microsoft.com/ja-jp/azure/storage/files/storage-snapshots-files



#### <a id="2-2"></a>2-2. Azure Blob バックアップ
Azure Blob バックアップ は Azure Blob のポイントインタイムリストアの機能をバックアップサービスと連携することにより実現したバックアップソリューションです。

そのため、バックアップデータ (リストアに必要なデータ) の保存先は Azure Blob のポイントインタイムリストアと同じく、そのストレージ アカウント自身となります。
そのため、バックアップ コンテナーには転送されません。

・運用バックアップのしくみ - Azure Blob の運用バックアップの概要
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-overview
>抜粋：BLOB の運用バックアップは、ローカル バックアップ ソリューションです。 そのため、バック アップデータはバックアップ コンテナーには転送されず、ソース ストレージ アカウント自体に格納されます。 ただし、バックアップ コンテナーは引き続きバックアップ管理の単位として機能します。 また、これは継続的バックアップ ソリューションです。つまり、バックアップをスケジュール設定する必要がなく、すべての変更内容が保持され、選択した時点の状態から復元できます。

・ブロック BLOB のポイントインタイム リストア
https://learn.microsoft.com/ja-jp/azure/storage/blobs/point-in-time-restore-overview


#### <a id="2-3"></a>2-3. Azure ディスク バックアップ

Azure ディスク バックアップ は マネージドディスクの増分スナップショットの機能とバックアップサービスと連携することによりスナップショット取得の自動化、スナップショットの削除の自動化を実現したバックアップソリューションです。

そのため、バックアップデータ (スナップショット データ) の保存先は マネージドディスクのスナップショットと同じく、マネージドディスクのスナップショットの専用領域 (運用層) となります。そのため、 Recovery Services コンテナーには転送されません。
また、下記のように**スナップショットリソースとして Azure ディスクのバックアップによって取得されたスナップショットも確認可能です**。(タグが "CreatedBy：AzureBackup" となっているものです)
![](https://user-images.githubusercontent.com/71251920/198349785-951e0497-fe17-46e5-9714-53f2daf30344.png)


・バックアップと復元のプロセスのしくみ - Azure ディスク バックアップの概要
https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-overview#how-the-backup-and-restore-process-works
>抜粋： Azure ディスク バックアップでは、運用層のバックアップのみがサポートされています。 コンテナー ストレージ層へのバックアップのコピーはサポートされていません。

・マネージド ディスクの増分スナップショットの作成
https://learn.microsoft.com/ja-jp/azure/virtual-machines/disks-incremental-snapshots?tabs=azure-cli