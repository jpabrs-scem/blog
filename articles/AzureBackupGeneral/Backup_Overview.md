---
title: Azure Backup の 概要
date: 2024-05-7 12:00:00
tags:
  - Information
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートです。  
今回はお問合せをいただくことが多い、Azure Backup サービスでどんなバックアップソリューションを提供しているのか、それぞれのソリューションをどんなユースケースで利用できるのかをご紹介いたします。


## 目次
-----------------------------------------------------------
[1. Azure Backup の概要](#1)  
   [  1.1 Azure Backup のバックアップ ソリューション一覧表](#1-1)  
   [  1.2 Recovery Services コンテナー と バックアップ コンテナーについて](#1-2)  
   [  1.3 バックアップ ポリシー](#1-3)  
[2. Azure Backup のバックアップ ソリューションの詳細](#2)  
   [  2.1 Azure VM Backup](#2-1)  
   [  2.2 Azure ディスク バックアップ](#2-2)  
   [  2.3 Azure ファイル共有バックアップ](#2-3)  
   [  2.4 Azure VM 内の SQL Server をバックアップ](#2-4)  
   [  2.5 Azure VM 内の SAP HANA データベースをバックアップ](#2-5)  
   [  2.6 Azure Database for PostgreSQL をバックアップ](#2-6)  
   [  2.7 Azure BLOB バックアップ](#2-7)  
   [  2.8 MARS バックアップ](#2-8)  
   [  2.9 DPM / MABS バックアップ](#2-9)  
   [  2.10 ディスクのスナップショット](#2-10)  
[3. よくいただくお問合せ](#3)
-----------------------------------------------------------

## <a id="1"></a> 1. Azure Backup の概要
Azure Backup サービスでは、Micosoft Azure クラウド プラットフォームにデータをバックアップすることができます。  
オンプレミスや Azure の様々なリソースを簡単にバックアップおよび復元を行うことができ、また一元化された監視と管理を行うためのソリューションを提供します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/9c7ab400-ac12-41e3-9f06-445561de7e12" width="800px">

Azure Backup についてより詳しく確認したい場合は以下のドキュメントを参照ください。  
* Azure Backup とは - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-overview
* アーキテクチャの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-architecture

## <a id="1-1"></a> 1.1 Azure Backup のバックアップ ソリューション一覧表
下記の表では Azure Backup で提供されている各バックアップソリューションとそれぞれでバックアップおよび復元できる対象をご紹介します。
|  バックアップの種類  |  バックアップ対象  |  復元方法  |
| :---- | :---- |  :---- | 
|  Azure VM バックアップ | Azure VM | <ul> <li>復元して新しい VM を作成</li> <li>VM のディスクを復元</li> <li>ディスクを復元して既存 (バックアップ元) の VM を置き換えて復元 </li> <li>VM 内の特定のファイルを復元</li> <li>セカンダリ リージョンに復元</li> <li>異なるサブスクリプションに復元</li> <li>異なるゾーンに復元</li> </ul> |
|  Azure ディスク バックアップ | Azure Managed Disks  | <ul> <li>復元して新しいディスクを作成</li> <li>現在、既存 (バックアップ元) のディスクを置き換えて復元する方法はサポートされていません。</li> </ul> | 
|  Azure ファイル共有バックアップ | ストレージ アカウントのファイル共有 | <ul> <li>Azure ファイル共有すべてを復元</li> <li>個々のファイルまたはフォルダーを復元</li> </ul> | 
|  Azure VM 内の SQL Server をバックアップ | Azure VM 内の  SQL Server の データベース <br> ※ 完全バックアップ、差分バックアップ、ログ バックアップに対応 | <ul> <li>別のデータベースに復元</li> <li>元のデータベースを上書きして復元</li> <li>ファイルとして復元</li> </ul> |
|  Azure VM 内の SAP HANA データベースをバックアップ | Azure VM 内の SAP HANA のデータベース <br> ※ 完全バックアップ、差分バックアップ、増分バックアップ、ログ バックアップ、スナップショットに対応 | <ul> <li>別のデータベースに復元</li> <li>元のデータベースを上書きして復元</li> <li>ファイルとして復元</li> </ul> |
|  Azure Database for PostgreSQL をバックアップ | Azure Database for PostgreSQL サーバーのデータベース | <ul> <li>データベースとして復元 ※ただし、元のデータベースの上書きはサポートされていません</li> <li>ファイルとして復元</li> </ul> |
|  Azure BLOB バックアップ| ストレージ アカウントの BLOB Storage | <ul> <li>ストレージ アカウント内のすべての BLOB を復元</li> <li>選択したコンテナーを参照して復元</li> <li>プレフィックスの一致を使用して特定の BLOB を復元</li> </ul> |
|  MARS バックアップ | オンプレミス / Azure VM の Windows または Windows Server 上 のファイル、フォルダーとシステム状態 | <ul> <li>ファイルとフォルダーの復元</li> <li>ボリューム レベルでの復元</li> <li>システム状態の復元</li> </ul> |
|  DPM / MABS バックアップ  | オンプレミスの VM (Hyper-V と VMware) やオンプレミスのワークロード(SQL server や Exchange など) | // ここら辺はまだちゃんと理解できていない※あとで廣瀬さん、DAN さんに書いてもらう |
|  ディスクのスナップショット (注1) | Azure Managed Disks | <ul> <li>新しいマネージド ディスクとして復元</li> </ul> |

(注1) ディスクのスナップショットは Azure マネージドディスクのネイティブ バックアップ ソリューションであり、Azure Backup の機能ではありません。

// TODO : DPM / MABS バックアップについて追記する

### <a id="1-2"></a> 1.2 Recovery Services コンテナー と バックアップ コンテナーについて
Azure Backup を利用するには`Recovery Services コンテナー`と`バックアップ コンテナー`をまず作成する必要があります。  
この 2 種類のコンテナーはバックアップ データを格納する Azure のストレージ エンティティです。  
バックアップ データの格納以外にも、バックアップ ポリシー、バックアップの構成、復旧ポイントなどを一元的に管理することができます。  

Recovery Services コンテナーとバックアップ コンテナーについて詳細を確認したい場合は下記ドキュメントを参照ください。  
* Recovery Services コンテナーの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-recovery-services-vault-overview
* バックアップ コンテナーの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-vault-overview
* Recovery Services コンテナーとバックアップ コンテナーについて | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RSV_BV/  

### <a id="1-3"></a> 1.3 バックアップ ポリシーについて
Azure Backup でバックアップをスケジュールするには、`バックアップ ポリシー`を利用します。  
バックアップ ポリシーはコンテナーごとに管理され、各バックアップ ソリューション用に作成することができます。  
バックアップ ポリシーではバックアップ ソリューションごとに設定できる内容は異なりますが、基本的に以下を設定します。  
* スケジュール : いつバックアップをするか
* 保有期間 : 各バックアップをどれだけの期間保有する必要があるか

バックアップ ポリシーについて詳細を確認したい場合は下記ドキュメントを参照ください。
* バックアップ ポリシーの基礎 | アーキテクチャの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-architecture#backup-policy-essentials
* Azure Backup の 保持期間について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureBackupGeneral/Backup_RetentionPeriod/

#### 利用方法
バックアップ ポリシーは Recovery Services コンテナーとバックアップ コンテナーそれぞれで管理できます。
* Recovery Services コンテナーの場合  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/ccff1128-f976-49b6-bbf6-f8b8be8b7a7f" width="600px">
* バックアップ コンテナーの場合  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/4725ec33-fc95-47d4-9c90-2c6cbe84167a" width="600px">

## <a id="2"></a> 2. Azure Backup のバックアップ ソリューションの詳細
### <a id="2-1"></a> 2.1 Azure VM Backup 
このバックアップ ソリューションでは、Azure VM 全体のバックアップを行うことができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  
バックアップ対象として Windows OS の VM と Linux OS の VM 両方とも対象となります。
Azure VM Backup を利用する際のサポート設定と制限事項については下記のサポート マトリックスをご参照ください。
* Azure VM バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas

また、バックアップできるバックアップ データの整合性はアプリケーション整合性、ファイルシステム整合性とクラッシュ整合性の 3 種類がございます。  
整合性についてより詳細な仕様を確認したい場合は下記ドキュメントをご参照ください。  
* Azure VM Backupにおける整合性について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/
* スナップショットの整合性 | Azure VM バックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-consistency

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2347bf37-dabc-4a61-b38b-f9ae66bf3ca0" width="400px">  

ワークロードで`Azure`、バックアップ対象で`仮想マシン`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2463356a-ac96-4c37-82ca-08efccaa5837" width="400px">

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。
* Recovery Services コンテナーに Azure VM をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-vms-prepare
* Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms


### <a id="2-2"></a> 2.2 Azure ディスク バックアップ
このバックアップ ソリューションでは、Azure の マネージド ディスクをバックアップすることができます。  
また、ディスクが Azure VM に接続されている場合でも VM の電源状態にかかわらずクラッシュ整合性のみを提供するソリューションとなっております。  
バックアップの構成や復旧ポイントの管理はバックアップ コンテナーにて行うことができます。  

Azure ディスク バックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。  
* Azure ディスク バックアップの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-JP/azure/backup/disk-backup-overview
* Azure ディスク バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-support-matrix

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/535da04c-492f-44ef-853c-536a0f9fd8f8" width="400px">  

データソースの種類で`Azure ディスク`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/5cc5719e-0bac-414e-9a9d-a5709af12f9b" width="400px">

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。
* Azure Managed Disks のバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-managed-disks
* Azure マネージド ディスクを復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-managed-disks

### <a id="2-3"></a> 2.3 Azure ファイル共有バックアップ
このバックアップ ソリューションでは、Azure ストレージアカウントのファイル共有をバックアップすることができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  

Azure ファイル共有バックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。
* Azure ファイル共有のバックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-backup-overview?tabs=snapshot
* Azure Backup を使用した Azure ファイル共有のバックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-support-matrix?tabs=snapshot-tier

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2347bf37-dabc-4a61-b38b-f9ae66bf3ca0" width="400px">  

ワークロードで`Azure`、バックアップ対象で`Azure ファイル共有`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/8b6b5bc8-95b3-4097-8f1b-08f5016d43b7" width="400px">  

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。  
* Azure portal で Azure ファイル共有をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-files?tabs=backup-center
* Azure ファイル共有を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-afs?tabs=full-share-recovery

### <a id="2-4"></a> 2.4 Azure VM 内の SQL Server をバックアップ
このバックアップ ソリューションでは、Azure VM 内にある SQL Server をバックアップすることができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  
このソリューションでは、SQL ネイティブ API を活用して、SQL データベースのバックアップを作成しています。
そのため、Azure VM Backup にはない以下の特徴があります。
* 完全、差分、ログという全種類のバックアップに対応するワークロード対応バックアップ
* 15 分間の RPO (回復ポイントの目標) と頻繁に行われるログのバックアップ
* 特定の時点に復旧
* 個々のデータベース レベルのバックアップと復元

Azure VM 内の SQL Server をバックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。
* Azure への SQL Server データベースのバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sql-database  
* Azure VM 内の SQL Server のバックアップに関する Azure Backup のサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sql-support-matrix  

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2347bf37-dabc-4a61-b38b-f9ae66bf3ca0" width="400px">  

ワークロードで`Azure`、バックアップ対象で`Azure VM 内の SQL Server`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/cf06b38b-7a42-49cc-9d4f-8a6757936c93" width="400px">  

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。  
* コンテナーから複数の SQL Server VM をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms
* Azure VM 上の SQL Server データベースを復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-sql-database-azure-vm

### <a id="2-5"></a> 2.5 Azure VM 内の SAP HANA データベースをバックアップ
このバックアップ ソリューションでは、Azure VM 内にある SAP HANA データベースをバックアップすることができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  
Azure Backup は、SAP による Backint 認定がされており、SAP HANA のネイティブ API を活用して、バックアップを作成しています。
そのため、Azure VM Backup にはない以下の特徴があります。
* 完全、差分、ログという全種類のバックアップに対応するワークロード対応バックアップ
* 15 分間の RPO (回復ポイントの目標) と頻繁に行われるログのバックアップ
* 特定の時点に復旧
* 個々のデータベース レベルのバックアップと復元

Azure VM 内の SAP HANA をバックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。
* Azure VM 上の SAP HANA データベース バックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-about
* SAP HANA バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-backup-support-matrix

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2347bf37-dabc-4a61-b38b-f9ae66bf3ca0" width="400px">  

ワークロードで`Azure`、バックアップ対象で`Azure VM 内の SAP HANA`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/037e9907-9b8f-4259-b573-b8e5e0c02e08" width="400px"> 

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。  
* Azure Backup を使用して Azure に SAP HANA データベースをバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sap-hana-database
* Azure VM 上の SAP HANA データベースの復元 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-restore

### <a id="2-6"></a> 2.6 Azure Database for PostgreSQL をバックアップ
このバックアップ ソリューションでは、Azure Database for PostgreSQL をバックアップすることができます。  
Azure Database for PostgreSQL ネイティブのバックアップソリューションではデータ保有期間が最大 35 日間ですが、Azure Backup を利用することでデータを長期的(最大 10 年間)に保有することが可能になります。
長期的な保有期間以外にも、バックアップの構成や復旧ポイントを一元的にバックアップ コンテナーにて管理できるメリットなどがあります。

Azure Database for PostgreSQL をバックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。
* Azure Database for PostgreSQL のバックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql-overview
* Azure Database for PostgreSQL サーバーのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql-support-matrix

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/535da04c-492f-44ef-853c-536a0f9fd8f8" width="400px">  

データソースの種類で`Azure Database for PostgreSQL サーバー`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/32a2e9ee-0a07-451c-8822-f6ed16edc4d7" width="400px">  

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。
* Azure Database for PostgreSQL のバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql
* Azure Database for PostgreSQL を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-azure-database-postgresql

### <a id="2-7"></a> 2.7 Azure BLOB バックアップ
このバックアップ ソリューションでは、Azure ストレージアカウントの BLOB コンテナーをバックアップすることができます。  
バックアップの構成や復旧ポイントの管理はバックアップ コンテナーにて行うことができます。  

Azure BLOB バックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。
* Azure BLOB バックアップの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-overview?tabs=operational-backup
* Azure BLOB バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-support-matrix?tabs=operational-backup

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/535da04c-492f-44ef-853c-536a0f9fd8f8" width="400px">  

データソースの種類で`Azure BLOB (Azure Storage)`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/a4e8ba67-a51a-4431-a60c-58e88854c2d6" width="400px">  

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。
* Azure Backup を使用して Azure BLOB のバックアップを構成および管理する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-configure-manage?tabs=operational-backup
* Azure の BLOB を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-restore?tabs=operational-backup

### <a id="2-8"></a> 2.8 MARS バックアップ
Microsoft Azure Recovery Services (MARS) エージェントを使用して、ファイル、フォルダー、およびボリュームまたはシステム状態をオンプレミスまたは Azure VM のコンピューターから Azure にバックアップおよび回復します。
サポートしている OS は Windows Server または Windows のみで、Linux OS では利用いただけません。

MARS バックアップについてさらに詳しく確認したい場合は下記ドキュメントをご参照ください。
* MARS エージェントについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-about-mars
* MARS エージェントを使用したサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mars-agent

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2347bf37-dabc-4a61-b38b-f9ae66bf3ca0" width="400px">  

ワークロードで`オンプレミス`、バックアップ対象で`ファイルとフォルダー`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/88985531-4431-4720-8c3c-b22e75a9abd6" width="300px">  

バックアップおよび復元のより詳細な手順は下記ドキュメントをご参照ください。
* MARS エージェントを使用して Windows マシンをバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-windows-with-mars-agent
* MARS エージェントを使用して Windows Server にファイルを復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-restore-windows-server

### <a id="2-9"></a> 2.9 DPM / MABS バックアップ

// TODO : 後で廣瀬さん、ダンさんに概要の記載だけお願いする。
// 簡単な利用方法の記載も可能であれば、お願いする。

### <a id="2-10"></a> 2.10 ディスクのスナップショット

まず前提としまして、ディスクのスナップショットは Azure マネージドディスクのネイティブ バックアップ ソリューションであり、Azure Backup の機能ではありません。
Azure VM Backup、ディスク バックアップはバックアップ ポリシーを利用しスケジュールされたバックアップを取得する運用を想定した製品仕様となっております。
しかし、任意のタイミングのみバックアップを取得したいといった問い合わせをいただくこともあります。
前述した通り、Azure Backup スケジュールされたバックアップを取得する製品仕様となっているため、任意のタイミングでのみバックアップを取得することは推奨しておりません。
そのためもし、スケジュール バックアップが不要で、バックアップ頻度が低い場合は、Azure Backup ではなく、ディスクのスナップショットを用いる代替案がございます。

ディスクのスナップショットを行いたい場合は下記ドキュメントを参照ください。
* Azure VM バックアップを任意のタイミングのみで取得したい | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpaztech.github.io/blog/vm/vm-replica-3/#2-VM-を停止-割り当て解除-し、OS-ディスクの-スナップショット-を取得
* 仮想ハード ディスクの Azure スナップショットを作成する - Azure Virtual Machines | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/virtual-machines/snapshot-copy-managed-disk?tabs=portal

また、Azure Backup を利用して任意のタイミングでバックアップする方法と懸念点については下記弊社ブログにて紹介しております。
* Azure VM バックアップを任意のタイミングのみで取得したい | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/invalid_schedule/

## <a id="3"></a> 3. よくいただくお問合せ
Azure Backup の各バックアップソリューションについてよくいただくお問い合わせと回答を記載させていただきます。

### Azure VM 内の SQL Server (または Azure VM 内の SAP HANA) と Azure VM バックアップの違いはなに？
Azure VM にある SQL Server は `Azure VM Backup` ソリューションと `Azure VM 内の SQL Server をバックアップ` ソリューションの両方でバックアップが可能です。  
`Azure VM 内の SQL Server をバックアップ` では データベースのみのバックアップであり、VM 自体がバックアップされません。  
それに対して `Azure VM Backup` では VM 自体がバックアップされ、その中に SQL Server が存在していれば、それも含まれてバックアップされる形になります。  
そのため、SQL Server だけでなく、VM 自体の復元が必要な場合は `Azure VM Backup` の利用を検討ください。  

また、`Azure VM 内の SQL Server をバックアップ` はデータベース ワークロードに特化したワークロードであり、 `Azure VM Backup` にはない、15 分間の RPO (目標復旧時点) を提供し、個々のデータベースのバックアップと復元が可能です。

また、同じVM上で `Azure VM Backup` と `Azure VM 内の SQL Server をバックアップ` を共存させることも可能です。  
詳細については下記ドキュメントをご参照ください。  
* FAQ - Azure VM 上の SQL Server データベースのバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/faq-backup-sql-server#iaas-vm---azure---------sql-server-----------------    

// TODO : 他あれあ追記！！

お客様のお役に立てれば幸いです。
本記事は以上です。