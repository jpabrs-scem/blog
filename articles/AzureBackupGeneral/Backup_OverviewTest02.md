---
title: Azure Backup の 概要
date: 2024-06-17 12:00:00
tags:
  - Information
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートです。  
今回はお問合せをいただくことが多い、Azure Backup サービスでどんなバックアップソリューションを提供しているのか、そしてそれぞれのソリューションで何をバックアップおよび復元できるのかをご紹介いたします。

## 目次
-----------------------------------------------------------
[1. Azure Backup の概要](#1)  
   [  1.1 Azure Backup のバックアップ ソリューション一覧表](#1-1)  
   [  1.2 Recovery Services コンテナー と バックアップ コンテナーについて](#1-2)  
   [  1.3 バックアップ ポリシー](#1-3)
   [  1.4 Azure Backup における DR / RTO / RPO について](#1-4)
   [  1.5 Azure Backup の価格](#1-5)
[2. Azure Backup のバックアップ ソリューションの詳細](#2)  
   [  2.1 Azure VM Backup](#2-1)  
   [  2.2 Azure ディスク バックアップ](#2-2)  
   [  2.3 Azure ファイル共有バックアップ](#2-3)  
   [  2.4 Azure BLOB バックアップ](#2-4)  
   [  2.5 Azure VM 内の SQL Server バックアップ](#2-5)  
   [  2.6 Azure VM 内の SAP HANA データベースバックアップ](#2-6)  
   [  2.7 Azure Database for PostgreSQL バックアップ](#2-7)  
   [  2.8 Azure Database for MySQL バックアップ](#2-8)
   [  2.9 MARS バックアップ](#2-9)  
   [  2.10 DPM / MABS バックアップ](#2-10)  
   [  2.11 Azure Kubernetes Service (AKS) バックアップ](#2-11)  
[3. よくいただくお問合せ](#3)
-----------------------------------------------------------

## <a id="1"></a> 1. Azure Backup の概要
Azure Backup サービスでは、Micosoft Azure クラウド プラットフォームにデータをバックアップすることができます。  
オンプレミスや Azure の様々なリソースを簡単にバックアップおよび復元を行うことができ、また一元化された監視と管理を行うためのソリューションを提供します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/9c7ab400-ac12-41e3-9f06-445561de7e12">

> [!TIP]
> Azure Backup の詳細については以下のドキュメントを参照ください。  
> ---
> ・ Azure Backup とは - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-overview  
> ・アーキテクチャの概要 - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-architecture

## <a id="1-1"></a> 1.1 Azure Backup のバックアップ ソリューション一覧表
下記の表では Azure Backup で提供されている各バックアップソリューションとそれぞれでバックアップおよび復元できる対象をご紹介します。  
また、各ソリューションには各公開ドキュメントへのリンクを付けています。

|  バックアップの種類  |  バックアップ対象  |  復元方法  |
| :---- | :---- |  :---- | 
|  [Azure VM バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction) | Azure VM | <ul> <li>新しい VM として復元</li> <li>VM にアタッチされていたディスクの復元</li> <li>既存 (バックアップ元) VM のディスクを置き換えて復元 </li> <li>VM 内にある特定ファイルの復元</li> </ul> |
|  [Azure ディスク バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-overview) | Azure Managed Disks  | <ul> <li>新しいディスクとして復元</li>  </ul> | 
|  [Azure ファイル共有バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-backup-overview?tabs=snapshot) | ストレージ アカウントのファイル共有 | <ul> <li>Azure ファイル共有の復元</li> <li>個々のファイルまたはフォルダーの復元</li> </ul> | 
|  [Azure BLOB バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-overview?tabs=operational-backup)  | ストレージ アカウントの BLOB Storage | <ul> <li>ストレージ アカウント内のすべての BLOB の復元</li> <li>選択したコンテナーの復元</li> <li>プレフィックスの一致を使用して特定の BLOB の復元</li> </ul> |
|  [Azure VM 内の SQL Server バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sql-database)  | Azure VM 内の  SQL Server の データベース <br> ※ 完全バックアップ、差分バックアップ、ログ バックアップに対応 <br> ※ Always On 可用性グループのバックアップに対応 | <ul> <li>別のデータベースに復元</li> <li>元のデータベースを上書きして復元</li> <li>ファイルとして復元</li> </ul> |
|  [Azure VM 内の SAP HANA データベースバックアップ](https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-about)  | Azure VM 内の SAP HANA のデータベース <br> ※ 完全バックアップ、差分バックアップ、増分バックアップ、ログ バックアップ、インスタンス スナップショットのバックアップに対応 <br> ※ HANA システム レプリケーション (HSR) データベースのバックアップに対応| <ul> <li>別のデータベースとして復元</li> <li>元のデータベースを上書きしての復元</li> <li>ファイルとして復元</li> </ul> |
|  [Azure Database for PostgreSQL バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql-overview)  | Azure Database for PostgreSQL サーバーのデータベース | <ul> <li>別のデータベースとして復元</li> <li>ファイルとして復元</li> </ul> |
|  [Azure Database for MySQL バックアップ (注1)](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-mysql-flexible-server-about)  | Azure Database for MySQL サーバーのデータベース | <ul> <li>ファイルとして復元</li> </ul> |
|  [MARS バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-about-mars)  | オンプレミス マシン / Azure VM の Windows OS マシン上 のファイル、フォルダーとシステム状態 | <ul> <li>ファイルとフォルダーの復元</li> <li>ボリューム レベルでの復元</li> <li>システム状態ファイルの復元</li> </ul> |
|  [DPM / MABS バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mabs-dpm#about-dpmmabs)  | オンプレミス マシン / Azure VM 上で実行されているワークロード (SQL server や Exchange など)、仮想マシン (Hyper-V、 VMware) <br> 具体的なバックアップ対象は [MABS (Azure Backup Server) V4 の保護マトリックス](https://learn.microsoft.com/ja-jp/azure/backup/backup-mabs-protection-matrix) をご参照ください。 | 復元できる方法については保護する各ワークロードによって異なります。 <br> 具体的な復元方法は [2.10 DPM / MABS バックアップ > 復元方法](#2-10-restore) をご参照ください |
|  [Azure Kubernetes Service (AKS) バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/azure-kubernetes-service-backup-overview)  | AKS クラスター (クラスター リソースとクラスターにアタッチされている永続ボリューム) | <ul> <li> 既存の (バックアップ元) の AKS クラスターに復元</li> <li>別の AKS クラスターとして復元</li> </ul> |

> [!NOTE]
> (注1) 2024年5月現在 Azure Database for MySQL のバックアップ機能が Public Preview となっています。  
> ---
> ・ Public preview: Azure Backup supports long term retention for backup of Azure Database for MySQL– Flexible Server | Azure updates | Microsoft Azure  
> 　 https://azure.microsoft.com/en-US/updates/mysql-flexibleserverlongtermretenttion/

### <a id="1-2"></a> 1.2 Recovery Services コンテナー と バックアップ コンテナーについて
Azure Backup を利用するためには、最初に Azure 上にバックアップ データを保存するストレージを作成する必要があります。  
このストレージは、**Recovery Services コンテナー**、もしくは**バックアップ コンテナー**と呼ばれ、利用する Azure Backup ソリューションの種類によって、いずれかを必ず作成します。  
この 2 種類のコンテナーは、バックアップ データを格納する Azure のストレージです。  

#### 利用方法
Azure portal にて`バックアップ センター`ダッシュボードに移動し、`概要`ペインで`コンテナー`を選択します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/0ef72d75-5962-46a2-805a-0d0a33941ca4" width="700px">

コンテナーの作成画面に移動し、利用したいコンテナーの種類を選択して作成を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/85d52605-3642-47c2-b8bd-321ebbf4791c" width="700px">

> [!TIP]
> Recovery Services コンテナーとバックアップ コンテナーの詳細については下記ドキュメントを参照ください。
> ---  
> ・Recovery Services コンテナーの概要 - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-recovery-services-vault-overview  
> ・Recovery Services コンテナーを作成して構成する - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault  
> ・バックアップ コンテナーの概要 - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-vault-overview  
> ・バックアップ コンテナーの作成と管理 - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/create-manage-backup-vault  

> [!TIP]
> バックアップ データの保存先については下記ドキュメントを参照ください。  
> ---  
> ・Recovery Services コンテナーとバックアップ コンテナーについて | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
> 　 https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RSV_BV/  

### <a id="1-3"></a> 1.3 バックアップ ポリシーについて
Azure Backup でバックアップをスケジュールするには、**バックアップ ポリシー**を利用します。  
バックアップ ポリシーは Recovery Services コンテナーもしくはバックアップ コンテナーごとに管理され、各バックアップ ソリューション用に作成することができます。  
バックアップ ポリシーではバックアップ ソリューションごとに設定できる内容は異なりますが、基本的に以下項目を設定します。  
* スケジュール : いつバックアップをするか
* 保持期間 : 復旧ポイントをどれだけの期間保有する必要があるか

> [!TIP]
> バックアップ ポリシーの詳細については下記ドキュメントを参照ください。  
> ---  
> ・バックアップ ポリシーの基礎 | アーキテクチャの概要 - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-architecture#backup-policy-essentials  

> [!TIP]
> バックアップの頻度とバックアップデータの保持期間については下記ドキュメントを参照ください。  
> ---
> ・Azure Backup の 保持期間について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
> 　 https://jpabrs-scem.github.io/blog/AzureBackupGeneral/Backup_RetentionPeriod/

#### 利用方法
バックアップ ポリシーは Recovery Services コンテナーとバックアップ コンテナーそれぞれで管理できます。
* Recovery Services コンテナーの場合  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/f7394639-d63e-4f9b-8acb-b1c13fdfc3e5" width="700px">
* バックアップ コンテナーの場合  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/b1f8b099-d1d7-4d46-830e-233df27e72e7" width="700px">

### <a id="1-4"></a> 1.4 Azure Backup における DR / RTO / RPO について
#### Disaster recovery (DR) について
Disaster recovery (DR) は、災害時のシステムの復旧やデータロストを未然に防ぐ対策を指します。
Azure Backup では DR の一環として クロス リージョン リストア (CRR) の利用が可能です。  
適用できるバックアップ ソリューションは以下です。  
* [Azure VM バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#cross-region-restore)
* [Azure VM 内の SQL Server バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/restore-sql-database-azure-vm#cross-region-restore)
* [Azure VM 内の SAP HANA データベースバックアップ](https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-restore#cross-region-restore) 
* [MARS バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/about-restore-microsoft-azure-recovery-services#cross-region-restore) (注1)
* [Azure Database for PostgreSQL バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/restore-azure-database-postgresql#restore-databases-across-regions)
* [Azure Kubernetes Service (AKS) バックアップ](https://learn.microsoft.com/ja-jp/azure/backup/azure-kubernetes-service-cluster-restore#restore-in-secondary-region-preview) (注1)

> [!NOTE]
> (注1) 2024年5月現在 MARS バックアップ と Azure Kubernetes Service (AKS) バックアップでの CRR 機能は Public Preview となっています。  
> --- 
> ・ Preview: Cross Region Restore (CRR) for Recovery Services Agent (MARS) using Azure Backup | Azure の更新情報 | Microsoft Azure   
> 　 https://azure.microsoft.com/ja-jp/updates/preview-mars-crr/

ただし CRR を利用するためには Recovery Service コンテナーの冗長性オプションが「GRS」かつ「リージョンをまたがる復元」が有効である必要があります。
> [!TIP]
> CRR の詳細については下記ドキュメントをご参照ください。  
> ---
> ・ Azure VM Backup における クロス リージョン リストア (CRR) について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
> 　 https://jpabrs-scem.github.io/blog/AzureVMBackup/CRR/  
> ・ リージョンをまたがる復元 | Recovery Services コンテナーを作成して構成する - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#set-cross-region-restore  
> ・ Azure portal を使用してリージョン間復元を実行する | Backup コンテナーの作成と管理 - Azure Backup | Microsoft Learn   
> 　 https://learn.microsoft.com/ja-jp/azure/backup/create-manage-backup-vault#perform-cross-region-restore-using-azure-portal  

> [!TIP]
> Azure VM Backup と Azure Site Recovery それぞれの DR 要件について下記弊社ブログにて紹介しております。  
> ---
> ・Azure VM Backup と Azure Site Recovery による DR 要件について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
> 　 https://jpabrs-scem.github.io/blog/AzureBackupGeneral/DR_ASR_or_VMBackup/#2

#### Recovery Time Objective (RTO) について
Recovery Time Objective (RTO) は「目標復旧時間」のことで、システム停止時点から復旧までに所要する目標時間を指します。
Azure Backup では RTO については明確に定められておらず、またバックアップやリストアの所要時間を見積もることができません。
これは Azure サービスがマルチテナント サービスであり、 Azure Backup サービスにおける所要時間はバックアップ / リストア対象のバックアップ アイテムの転送データサイズのみではなく、他のリソース、他のユーザー様の稼働状況、帯域の状況などにも処理時間は左右されるためです。  
詳細については下記ドキュメントをご参照ください。  
* Azure Backup の バックアップ / リストア 所要時間について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureBackupGeneral/Backup_RecoveryTIme

> [!TIP]
> RTO と RPO について、より詳細な説明は下記の公開ドキュメントをご参照ください。  
> ---
> ・ Azure Backup 用語集 - Azure Backup | Microsoft Docs  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/azure-backup-glossary#recovery-point-objective-rpo

#### Recovery Point Objective (RPO) について
Recovery Point Objective (RPO) は「目標復旧時点」のことで、システムが停止した時に、過去のどの時点のデータまでを復旧できるかの目標時点を指します。
RPO は利用するバックアップ ソリューションによって異なります。  
各バックアップ ソリューションによって指定できるバックアップ頻度が異なるためです。  
例えば Azure ディスク バックアップの場合は最短 1 時間ごとのバックアップを指定することができますが、Azure VM バックアップでは最短でも 4 時間ごとのバックアップとなります。  
バックアップ頻度については [ 1.3 バックアップ ポリシー](#1-3) の`ヒント`をご参照ください。

> [!WARNING]
> セカンダリ リージョンへのデータのレプリケーションは、プライマリリージョンへのバックアップジョブが完了 (最大24時間) してから 12 時間以内にレプリケーションが完了するように動作します。
> そのため、プライマリリージョンのバックアップジョブ完了とセカンダリ リージョンへのレプリケーションにはラグが生じます。
> 詳細は下記の公開ドキュメントをご参照ください。
> ・ Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-in-secondary-region

### <a id="1-5"></a> 1.5 Azure Backup の価格
基本的には、保護対象のリソースのインスタンス数、保全データサイズなどに課金されます。  
バックアップソリューションにより課金体系が異なる場合がありますので、詳しくは以下のドキュメントを参照いただくようお願いいたします。  
* 料金 - クラウド バックアップ | Microsoft Azure  
https://azure.microsoft.com/ja-jp/pricing/details/backup/
* 料金計算ツール | Microsoft Azure  
https://azure.microsoft.com/ja-jp/pricing/calculator/
* Azure Backup の価格 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-backup-pricing
* 料金計算ツールを用いた Azure VM Backup の料金見積もりについて | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/VM_Backup_calculator/
* Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの料金の違い | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/VM_Backup_billing/

## <a id="2"></a> 2. Azure Backup のバックアップ ソリューションの詳細
### <a id="2-1"></a> 2.1 Azure VM Backup 
Azure VM 全体、Azure VM 単位でのバックアップを行うことができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  
バックアップ対象として Windows OS, Linux OS 共に対象となり、オンライン / オフラインどちらでもバックアップ可能です。  


バックアップできるバックアップ データの整合性はアプリケーション整合性、ファイルシステム整合性とクラッシュ整合性の 3 種類がございます。  
整合性の詳細については下記ドキュメントをご参照ください。  
* Azure VM Backupにおける整合性について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/
* スナップショットの整合性 | Azure VM バックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-consistency

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
次にワークロードで`Azure`、バックアップ対象で`仮想マシン`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2463356a-ac96-4c37-82ca-08efccaa5837" width="600px">

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure VM バックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction
* Azure VM バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas
* Recovery Services コンテナーに Azure VM をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-vms-prepare
* Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms  

### <a id="2-2"></a> 2.2 Azure ディスク バックアップ
Azure の マネージド ディスクをバックアップすることができます。  
また、ディスクが Azure VM に接続されている場合でもバックアップ可能です。  
ただし、VM が起動中であっても取得されるバックアップはクラッシュ整合性となります。  
バックアップの構成や復旧ポイントの管理はバックアップ コンテナーにて行うことができます。 

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
次にデータソースの種類で`Azure ディスク`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/5cc5719e-0bac-414e-9a9d-a5709af12f9b" width="600px">

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure ディスク バックアップの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-JP/azure/backup/disk-backup-overview
* Azure ディスク バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-support-matrix
* Azure Managed Disks のバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-managed-disks
* Azure Managed Disks を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-managed-disks


### <a id="2-3"></a> 2.3 Azure ファイル共有バックアップ
Azure ストレージアカウントのファイル共有をバックアップすることができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
次にワークロードで`Azure`、バックアップ対象で`Azure ファイル共有`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/8b6b5bc8-95b3-4097-8f1b-08f5016d43b7" width="600px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure ファイル共有のバックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-backup-overview?tabs=snapshot
* Azure Backup を使用した Azure ファイル共有のバックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-file-share-support-matrix?tabs=snapshot-tier
* Azure portal で Azure ファイル共有をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-files?tabs=backup-center
* Azure ファイル共有を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-afs?tabs=full-share-recovery


### <a id="2-4"></a> 2.4 Azure BLOB バックアップ
Azure ストレージアカウントの BLOB コンテナーをバックアップすることができます。  
バックアップの構成や復旧ポイントの管理はバックアップ コンテナーにて行うことができます。  

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
次にデータソースの種類で`Azure BLOB (Azure Storage)`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/a4e8ba67-a51a-4431-a60c-58e88854c2d6" width="600px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure BLOB バックアップの概要 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-overview?tabs=operational-backup
* Azure BLOB バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-support-matrix?tabs=operational-backup
* Azure Backup を使用して Azure BLOB のバックアップを構成および管理する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-backup-configure-manage?tabs=operational-backup
* Azure の BLOB を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/blob-restore?tabs=operational-backup


### <a id="2-5"></a> 2.5 Azure VM 内の SQL Server バックアップ
Azure VM 内にある SQL Server をバックアップすることができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  
このソリューションでは、SQL Server 側のバックアップ機能と連携して、SQL データベースのバックアップを作成しています。
そのため、Azure VM Backup にはない以下の特徴があります。
* 完全、差分、ログバックアップに対応
* 頻繁に行われるログバックアップによる 最短 15 分間の RPO (目標復旧時点)
* 特定時点への復元
* 個々のデータベース レベルのバックアップと復元

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
次にワークロードで`Azure`、バックアップ対象で`Azure VM 内の SQL Server`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/cf06b38b-7a42-49cc-9d4f-8a6757936c93" width="600px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure への SQL Server データベースのバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sql-database  
* Azure VM 内の SQL Server のバックアップに関する Azure Backup のサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sql-support-matrix  
* コンテナーから複数の SQL Server VM をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms
* Azure VM 上の SQL Server データベースを復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-sql-database-azure-vm


### <a id="2-6"></a> 2.6 Azure VM 内の SAP HANA データベースバックアップ
Azure VM 内にある SAP HANA データベースをバックアップすることができます。  
バックアップの構成や復旧ポイントの管理は Recovery Services コンテナーにて行うことができます。  
Azure Backup は、SAP による Backint 認定がされており、SAP HANA 側のバックアップ機能と連携してバックアップを作成しています。
そのため、Azure VM Backup にはない以下の特徴があります。
* 完全、差分、ログバックアップに対応
* 頻繁に行われるログバックアップによる 最短 15 分間の RPO (目標復旧時点)
* 特定時点への復元
* 個々のデータベース レベルのバックアップと復元

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
次にワークロードで`Azure`、バックアップ対象で`Azure VM 内の SAP HANA`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/037e9907-9b8f-4259-b573-b8e5e0c02e08" width="600px"> 

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure VM 上の SAP HANA データベース バックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-about
* SAP HANA バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-backup-support-matrix
* Azure Backup を使用して Azure に SAP HANA データベースをバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sap-hana-database
* Azure VM 上の SAP HANA データベースの復元 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/sap-hana-database-restore


### <a id="2-7"></a> 2.7 Azure Database for PostgreSQL バックアップ
Azure Database for PostgreSQL をバックアップすることができます。  
Azure Database for PostgreSQL そのもののバックアップソリューションではデータ保有期間が最大 35 日間ですが、Azure Backup を利用することでデータを長期的 (最大 10 年間) に保有することが可能になります。  
長期的な保有期間以外にも、バックアップの構成や復旧ポイントを一元的にバックアップ コンテナーにて管理できるメリットなどがあります。

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
次にデータソースの種類で`Azure Database for PostgreSQL サーバー`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/32a2e9ee-0a07-451c-8822-f6ed16edc4d7" width="600px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure Database for PostgreSQL のバックアップについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql-overview
* Azure Database for PostgreSQL サーバーのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql-support-matrix
* Azure Database for PostgreSQL のバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-database-postgresql
* Azure Database for PostgreSQL を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-azure-database-postgresql


### <a id="2-8"></a> 2.8 Azure Database for MySQL バックアップ
Azure Database for MySQL をバックアップすることができます。  
Azure Database for MySQL そのもののバックアップソリューションではデータ保有期間が最大 35 日間ですが、Azure Backup を利用することでデータを長期的 (最大 10 年間) に保有することが可能になります。  
長期的な保有期間以外にも、バックアップの構成や復旧ポイントを一元的にバックアップ コンテナーにて管理できるメリットなどがあります。

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
次にデータソースの種類で`Azure Database for MySQL (プレビュー)`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/aa2621a6-3992-4712-afa1-4b5e791b7b5e" width="600px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* 概要 - Azure Backup を使用した Azure Database for MySQL - フレキシブル サーバーの長期保有 - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-mysql-flexible-server-about
* Azure Backup を使用した Azure Database for MySQL - フレキシブル サーバーの長期保有のサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-mysql-flexible-server-support-matrix
* Azure Backup を使用して Azure Database for MySQL - フレキシブル サーバーをバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-mysql-flexible-server
* Azure Backup を使用して Azure Database for MySQL - フレキシブル サーバーを復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-mysql-flexible-server-restore


### <a id="2-9"></a> 2.9 MARS バックアップ
Microsoft Azure Recovery Services (MARS) エージェントを使用して、ファイル、フォルダー、およびボリュームまたはシステム状態をオンプレミスの仮想マシンまたは Azure VM から Azure にバックアップできます。  
サポートしている OS は Windows OS のみで、Linux OS では利用いただけません。

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
次にワークロードで`オンプレミス`、バックアップ対象で`ファイルとフォルダー`を選択します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/88985531-4431-4720-8c3c-b22e75a9abd6" width="300px">  

続いての画面で`Windows Server または Windows クライアント用エージェントのダウンロード`のリンクを選択することで、MARS エージェントをダウンロードできます。  
インストール完了後、MARS エージェント UI からバックアップの設定を開始します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/ef1fbc8e-1f71-432b-9dc8-cbdbaa23a5ed" width="700px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* MARS エージェントについて - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-about-mars
* MARS エージェントを使用したサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mars-agent
* MARS エージェントを使用して Windows マシンをバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-windows-with-mars-agent
* MARS エージェントを使用して Windows Server にファイルを復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-restore-windows-server

### <a id="2-10"></a> 2.10 DPM / MABS バックアップ
System Center DPM は、エンタープライズ コンピューターおよびデータのバックアップと復旧を構成、促進、および管理するエンタープライズ ソリューションです。  
MABS は、オンプレミスの物理サーバー、VM、およびそれらで実行されているアプリをバックアップするために使用できるサーバー製品です。  
MABS は System Center DPM に基づいており、同様の機能を提供しますが、いくつかの違いがあります。
詳細は、下記ドキュメントをご参照ください。
* MABS と System Center DPM のサポート マトリックス - Azure Backup | Microsoft Learn
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mabs-dpm#about-dpmmabs

#### 利用方法
Azure Portal にて Recovery Services コンテナーを開き、`バックアップ`を選択、  
次にワークロードで`オンプレミス`、バックアップ対象で MABS を使用して保護するワークロードを選択します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/2426fa06-df5b-4dc4-b400-657115f6def0" width="300px">  

続いての画面で`ダウンロード`のリンクを選択することで、Microsoft Azure Backup Server (MABS) をダウンロードできます。  
インストール完了後、Microsoft Azure Backup Server UI からバックアップの設定を開始します。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/db6de149-ec90-42ec-b048-f99f11076c6f" width="700px">  

> [!NOTE]
> ファイルとフォルダーだけをバックアップする場合は、MARS を使用すること、および下記記事のガイダンスに従って操作することをお勧めします。  
> ・ MARS エージェントを使用して Windows マシンをバックアップする - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-windows-with-mars-agent  

#### <a id="2-10-restore"></a> 復元方法

DPM / MABS を利用してバックアップしたデータの復元方法は保護したワークロードによって異なります。  
詳細については下記ドキュメントをご参照ください。 
* バックアップされた Hyper-V 仮想マシンを復旧する | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/back-up-hyper-v-virtual-machines-mabs#recover-backed-up-hyper-v-virtual-machines  
* バックアップされた仮想マシンを回復する | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines#recover-backed-up-virtual-machines  
* Azure Backup Server を使用して VMware VM を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/restore-azure-backup-server-vmware  
* Exchange データベースを回復する | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-exchange-mabs#recover-the-exchange-database  
* MABS を使用して Azure から SharePoint データベースを復元する | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-backup-sharepoint-mabs#restore-a-sharepoint-database-from-azure-using-mabs  
* Azure からの SQL Server データベースの回復 | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-sql-mabs#recover-a-sql-server-database-from-azure  
* システム状態または BMR の回復 | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-mabs-system-state-and-bmr#recover-system-state-or-bmr  
* バックアップされたファイル データの回復 | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/back-up-file-data#recover-backed-up-file-data  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Data Protection Manager | Microsoft Learn  
https://learn.microsoft.com/ja-jp/system-center/dpm/dpm-overview?view=sc-dpm-2022
* DPM/MABS について | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mabs-dpm#about-dpmmabs
* DPM をインストールする | Microsoft Learn  
https://learn.microsoft.com/ja-jp/system-center/dpm/install-dpm?view=sc-dpm-2022
* Azure Backup Server のインストールとアップグレード | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-microsoft-azure-backup
* MABS (Azure Backup Server) V4 の保護マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-mabs-protection-matrix
* MABS と System Center DPM のサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mabs-dpm#about-dpmmabs

### <a id="2-11"></a> 2.11 Azure Kubernetes Service (AKS) バックアップ
AKS クラスターにデプロイされている AKS ワークロードと永続ボリュームをバックアップすることができます。
バックアップの構成や復旧ポイントの管理はバックアップ コンテナーにて行うことができます。  

#### 利用方法
Azure Portal にてバックアップ コンテナーを開き、`バックアップ`を選択、  
次にデータソースの種類で`Kubernetes サービス`を選択することでバックアップの設定を開始することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/872e323b-f078-4840-9479-fe2772d8a477" width="600px">  

#### 参照リンク
このバックアップ ソリューションの詳細については下記ドキュメントをご参照ください。  
* Azure Kubernetes Service (AKS) バックアップとは - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-kubernetes-service-backup-overview
* Azure Kubernetes Service (AKS) バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix?source=recommendations
* Azure Backup を使用して Azure Kubernetes Service をバックアップする - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-kubernetes-service-cluster-backup?source=recommendations
* Azure Backup を使用して Azure Kubernetes Service (AKS) を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/azure-kubernetes-service-cluster-restore


## <a id="3"></a> 3. よくいただくお問合せ
Azure Backup の各バックアップソリューションについてよくいただくお問い合わせと回答を記載させていただきます。

### Q1. 「Azure VM Backup」 と 「Azure ディスク バックアップ」 と 「ディスクのスナップショット」 はどれを利用したらいいですか？
「アプリケーション整合性を担保したバックアップを取得したい」や「Azure 仮想マシンをまるごと（マシンにアタッチされているディスクのデータを含めて）バックアップしたい」という用途であれば一般的に **Azure VM Backup** をご利用いただくことが多くございます。  

「Azure 仮想マシンをまるごとバックアップする必要は無い」であったり「とある Azure Managed Disk をディスク単体で定期的にバックアップすればよい」という場合は、**Azure ディスク バックアップ** をご検討ください。  

「1 度きりのバックアップ用途で取得しておきたい」というご要望をいただくこともあります。
しかし Azure VM Backup ではバックアップ ポリシーを利用しスケジュールされたバックアップを取得する運用を想定した製品仕様となっております。  
そのため、任意のタイミングのみでバックアップを行う場合は懸念点がございますため、弊社としてはこの運用を推奨しておりません。
この場合、Azure Backup ではなく、ディスク側の機能である**ディスクのスナップショット**の利用をご検討ください。
詳細については下記ドキュメントにて紹介しております。
* Azure VM バックアップを任意のタイミングのみで取得したい | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/invalid_schedule/

> [!NOTE]
> 「Azure ディスク バックアップ」 と 「ディスクのスナップショット」は Azure VM Backup とは異なり整合性が常にクラッシュ整合性となります。
> 詳細については下記をご覧ください。
> ---
> ・Azure VM Backupにおける整合性について - 3.クラッシュ整合性
> 　 https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#3

### Q2. 「共有ディスクのバックアップ」はできますか？
【Azure VM Backup で共有ディスクを含めてバックアップしたい場合】  
**Azure VM Backup** では残念ながら共有ディスクをバックアップすることはサポートしておりません。

ただし、共有ディスクがアタッチされている Azure VM に対して「共有ディスクを除外し、その他のディスクをバックアップする」ことは可能です。  
この場合は、Azure VM Backup の「選択的ディスクバックアップ」を「Enhanced バックアップ ポリシー」を指定して利用することで実現可能です。
* Azure 仮想マシンの選択的なディスク バックアップと復元 - Azure Backup | Microsoft Learn
https://learn.microsoft.com/ja-jp/azure/backup/selective-disk-backup-restore

【共有ディスクを「手動で任意のタイミングのみ」バックアップしたい場合】  
**ディスクのスナップショット**を利用して、お客様にて手動で Azure Managed Disk に対してスナップショットを取得いただく方法がございます。
 
【共有ディスクを「定期的に」バックアップしたい場合】
**Azure ディスク バックアップ** ソリューションを利用して、定期的なバックアップ取得 (=スナップショット取得) が可能です。
 
また、Windows OS の Azure VM であれば、共有ディスクに対する、「ローカル ディスク」としての **MARS バックアップ**は可能です。

> [!NOTE]
> MARS バックアップを利用して共有ディスクをバックアップする場合の注意点 
> --- 
> ・ 「共有ディスク」 が NTFS であり、「クラスター共有ボリューム」には割り当てられていなければ、MARS バックアップとしてバックアップは可能です。  
> ・ MARS はクラスター リソースを識別することができませんが、ローカル ディスクとして識別されているボリュームであれば、バックアップが可能です。  
> ・ 「クラスター サポート」とは、共有ボリュームがオンラインになっている場所 (ノード) を気にすることなく継続的にバックアップが可能であるか、という意味になりますが、MARS バックアップにおいては、これをサポートしていません。

### Q3. 「Azure VM 内の SQL Server バックアップ」 (または Azure VM 内の SAP HANA) と 「Azure VM バックアップ」の違いは何ですか？
Azure VM にある SQL Serverに対し、「Azure Backup」として提供できるサービスとしては  **Azure VM Backup** と **Azure VM 内の SQL Server をバックアップ** の両方でバックアップが可能です。  
**Azure VM 内の SQL Server バックアップ** では データベースのみのバックアップであり、VM 自体がバックアップされません。  
それに対して **Azure VM Backup** では VM 自体がバックアップされ、その中に SQL Server が存在していれば、それも含まれてバックアップされる形になります。  
そのため、SQL Server だけでなく、VM 自体の復元が必要な場合は **Azure VM Backup** の利用をご検討ください。  
**Azure VM Backup** における整合性についての詳細は下記ドキュメントをご参照ください。  
* Azure VM Backupにおける整合性について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#1-2

また、**Azure VM 内の SQL Server バックアップ** はデータベース ワークロードに特化したワークロードであり、 **Azure VM Backup** にはない、最短 15 分間の RPO (目標復旧時点) を提供し、個々のデータベースのバックアップと復元が可能です。

また、同じVM上で **Azure VM Backup** と **Azure VM 内の SQL Server バックアップ** を共存させることも可能です。  
詳細については下記ドキュメントをご参照ください。  
* FAQ - Azure VM 上の SQL Server データベースのバックアップ - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/faq-backup-sql-server#iaas-vm---azure---------sql-server-----------------    

### Q4. バックアップ失敗時にメールを通知するようにできますか？

Azure Backup でバックアップ ジョブが失敗した際、Azure Monitor を利用してメール通知を行うように構成できます。
詳細は下記ドキュメントをご参照ください。
* 「Azure Monitor を使用した組み込みのアラート」を利用したバックアップ ジョブ失敗のアラート通知作成例 | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
https://jpabrs-scem.github.io/blog/AzureBackupGeneral/How_to_set_Backup_Alert/


お客様のお役に立てれば幸いです。
本記事は以上です。