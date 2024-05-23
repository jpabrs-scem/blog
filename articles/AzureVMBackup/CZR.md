---
title: Azure VM Backup における CZR (クロス ゾーン リストア) について
date: 2024-5-31 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートです。  
今回は Azure Backup での異なる可用性ゾーンへの復元 ( = Cross Zonal Restore / CZR ) についてご紹介します。
今回ご紹介する内容は、それぞれの公開情報に掲載されておりますが、一つのページに集約されておりません。  
よくお問い合わせいただく内容ですので、本記事では情報を集約化してお伝えします。

## 目次
-----------------------------------------------------------
[1. CZR を行うための各条件](#1)  
  [1-1. CZR が行える Azure VM の条件](#1-1)  
  [1-2. CZR が行える Recovery Services コンテナーの条件](#1-2)  
  [1-3. CZR で利用できる復元オプション](#1-3)  
[2. 参考情報](#2)
-----------------------------------------------------------

## <a id="1"></a>1. CZR を行うための各条件
CZR を利用することで、Azure VM バックアップによって保護されている VM またはディスクを、復旧ポイントから別のゾーンに復元することができます。
CZR を利用するために Recovery Services コンテナーおよび Azure VM バックアップにより保護されている VM が満たすべき条件を下記表にまとめました。  

![image01](https://github.com/jpabrs-scem/blog/assets/109163295/020dae7d-6eca-4b60-b8ee-bec506556efc)
> [!NOTE]
> ※1 非ゾーン固定 VM に対して、Recovery Services コンテナー が ZRS の場合のみに CZR が行えて、GRS かつクロス リージョン リストアの場合は CZR が行えない  
> ※2 Recovery Services コンテナーが GRS かつクロス リージョン リストアを行うとき、 セカンダリーリージョンへの復元を行う場合にのみ CZR が行えて、プライマリーリージョンへの復元を行う場合は CZR が行えない

### <a id="1-1"></a>1-1. CZR が行える Azure VM の条件
CZR を行うためには、Azure VM バックアップにより保護されている VM が次の条件を満たす必要があります。
* マネージド VM であること
* Azure VM がゾーン固定または非ゾーン固定は影響しない (どちらともサポートされている)  
  ただし、Recovery Services コンテナーが GRS かつクロス リージョン リストアを行うときは、ゾーン固定 VM に対してのみ CZR が行えます。
* [暗号化された Azure VM](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#encryption-of-azure-vm-backups) ではないこと
* [トラステッド起動の Azure VM](https://learn.microsoft.com/ja-jp/azure/virtual-machines/trusted-launch) ではないこと 
  
#### Azure VM が特定の可用性ゾーンに固定されているかどうかを確認する方法
ご参考までに、Azure VM が可用性ゾーンに固定されているかどうかの、Azure ポータル画面での確認方法を説明いたします。  
下記画像の VM 「CZR-stand-z1」は可用性ゾーン「ゾーン1」に固定されている状態です。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/4a433214-3f04-4212-994c-c21851896d71" width="600px">

一方で下記画像の VM 「CZR-standard」はどのにもゾーンに固定されていない状態になります。  
(この場合は可用性ゾーンは空欄になります。)  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/63cfa831-c538-456c-8804-cf8bc24edaec" width="600px">

### <a id="1-2"></a>1-2. CZR が行える Recovery Services コンテナーの条件
CZR は以下の条件を満たす Recovery Services コンテナーで行うことができます。  
* Recovery Services コンテナーのストレージ レプリケーションの種類が ZRS (ゾーン冗長ストレージ) になっていること、または GRS (geo 冗長ストレージ) かつ [CRR (クロス リージョンリストア) 機能](https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#set-cross-region-restore) が有効になっていること  
  なお、ストレージ レプリケーションの種類が GRS かつ CRR (クロス リージョンリストア) 機能が有効の場合、[セカンダリ リージョンへの復元](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-in-secondary-region)を行う際に CZR を利用することができます。  
  セカンダリーリージョンへの復元ではなくプライマリーリージョンへの復元を行う場合は CZR を利用することができません。  

* 復旧ポイントが「コンテナー層」にのみ存在すること  
  ただし、「スナップショット層」のみ、または「スナップショット層とコンテナー層」の場合は CZR がサポートされていません。

> [!TIP]
> CRR については下記の弊社ブログにて紹介しております。  
> ・ Azure VM Backup における CRR (クロスリージョン リストア) について | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)  
> 　 https://jpabrs-scem.github.io/blog/AzureVMBackup/CRR/  
> ---
> ペア リージョンについて、および可用性ゾーンをサポートしているリージョンについては下記ドキュメントをご覧ください。  
> ・ Azure のリージョン間レプリケーション | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/reliability/cross-region-replication-azure#azure-paired-regions  
> ・ Availability Zones をサポートする Azure サービス | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support  

#### Azure Portal で Recovery Services コンテナー の冗長設定を確認する方法
ご参考までに、ZRS が有効になっている場合の Azure ポータル画面上の見え方を説明いたします。  
下記画像の Recovery Services コンテナーでは ZRS (ゾーン冗長ストレージ) が設定されています。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/014f7a8d-8c30-4721-a339-be3856f4059b" width="800px">  

> [!TIP]
> コンテナーで既にバックアップを構成している場合は冗長設定を変更することができません。  
> 冗長設定の変更が必要な場合は下記ドキュメントをご参照ください。  
> ・ Recovery Services コンテナーを作成して構成する - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#set-storage-redundancy

### <a id="1-3"></a> 1-3. CZR で利用できる復元オプション
CZR は次の復元を行う場合にのみ利用できます。
* VM の作成
* ディスクの復元

なお、[既存のディスクの置き換え](https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#replace-existing-disks) はサポートされていません。

#### VM の作成
復旧ポイントから VM の新規作成を行う際に前述の条件を満たしている場合に、復元先の可用性ゾーンを指定することができます。  
<img src="https://github.com/jpabrs-scem/blog/assets/109163295/97179be0-53cb-41b6-ade5-15d3dc68e705" width="600px"> 

具体的な復元の手順は下記の公開情報をご覧ください。  
* VM の作成 | Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#create-a-vm

#### ディスクの復元
復旧ポイントから ディスクの復元を行う際に前述の条件を満たしている場合に、復元先の可用性ゾーンを指定することができます。  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/8971e205-7641-4537-92f2-27a232dc468d" width="600px">  

具体的な復元の手順は下記の公開情報をご覧ください。  
* セカンダリ リージョンに復元する | Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-in-secondary-region

## <a id="2"></a>2. 参考情報

* 復元オプション | Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-options  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/d07419b8-ee3f-44c0-a451-a6d60afa2e3e" width="600px">  

* VM の作成 | Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#create-a-vm  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/d1efa7d0-1b7f-4b45-b38e-f25775672ccd" width="600px">  

* ディスクを復元する | Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-disks  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/61e32cee-5a4b-4d5c-af1a-26fff662b13f" width="600px">  

* セカンダリ リージョンに復元する | Azure Backup を使用して Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-in-secondary-region  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/54032b7a-47de-448a-9f76-7c97cd58a6f2" width="600px">  

* サポートされる復元方法 | Azure VM バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#supported-restore-methods  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/7444f151-d694-484e-b2c1-f6a42b745a16" width="600px">  

* FAQ-Azure VM をバックアップする - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vm-backup-faq#azure-------------------------  
  <img src="https://github.com/jpabrs-scem/blog/assets/109163295/aaacae5d-b7e4-4e8b-8627-878db9895b9c" width="600px">  
