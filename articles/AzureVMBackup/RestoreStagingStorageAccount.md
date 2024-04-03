---
title: Azure VM Backup でリストアする際に利用するステージングの場所として利用するストレージ アカウントについて
date: 2022-10-28 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートの山本です。
今回は、Azure VM Backup でリストアする際に利用するステージングの場所として利用するストレージ アカウントについて、下記の通りお伝えします。


## 目次
-----------------------------------------------------------
[1. 公開情報 (Docs)](#1)
[2. 利用できるストレージ アカウント](#2)
[3. リストアされた後にストレージ アカウントに残るファイルについて](#3)
[4. 参考画面ショット](#4)
-----------------------------------------------------------

### <a id="1"></a>1. 公開情報 (Docs)
まず最初に、本件に関する Docs は下記でございます。
・ストレージ アカウント - Azure portal で Azure VM データを復元する方法
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#storage-accounts
>抜粋:"Vault-Standard 復元ポイントからマネージド VM のディスクを復元するときに、マネージド ディスクと Azure Resource Manager (ARM) テンプレートが、ステージング場所にあるディスクの VHD ファイルと共に復元されます。 インスタント復元ポイントからディスクを復元する場合、マネージド ディスクと ARM テンプレートのみが復元されます。"

>抜粋:リージョン間復元では、 ステージング場所 (ストレージ アカウントの場所) は、Recovery Services コンテナーが セカンダリ リージョンとして扱うリージョンに存在する必要があります。 たとえば、Recovery Services コンテナーは米国東部 2 リージョンにあります (geo 冗長性とリージョン間復元が有効になっています)。 これは、セカンダリ リージョンは米国中部であることを意味します。 そのため、VM のリージョン間復元を行なうには、米国中部でストレージ アカウントを作成する必要があります。
[すべての地域の Azure リージョン間レプリケーションのペアリングに関する記事](https://learn.microsoft.com/ja-jp/azure/availability-zones/cross-region-replication-azure)をご覧ください。


### <a id="2"></a>2. 利用できるストレージ アカウント
選択できるストレージ アカウントは下記の条件を満たすものです。
・リストア先 (=ターゲット) のサブスクリプション内およびコンテナーと同じリージョンにある
・ZRS 以外の冗長性 (LRS・GRS)
・Premium Storage アカウントではない

### <a id="3"></a>3.リストアされた後にストレージ アカウントに残るファイルについて
マネージドディスクの Azure VM の復元が完了しますと対象のストレージ アカウントの中に下記のファイルが残ります。
下記の通り、ストレージ アカウントにファイルが残るかおよび、どのファイルが残るかはリストア シナリオによって異なります。


| # | |リストアシナリオ | ステージングのストレージ アカウントに残るファイル |
| :--- | :--- | :--- |:--- |
|  |  |**Recovery Services コンテナー (vault-standrd) 層からのリストア**|  |
| 1 | |新規 VM 作成| 無し |
| 2  || ディスクの復元| VHD ファイルと json ファイル |
| 3 | | 既存の置換え| VHD ファイル |
|  | |**スナップショット 層からのリストア (インスタントリストア)**|  |
| 4 |  |新規 VM 作成| 無し |
| 5 | | ディスクの復元|  json ファイル |
| 6 |  |既存の置換え| 無し |
|  | |**クロスリージョン リストア**|  |
| 7  || 新規 VM 作成| 無し |
| 8  | |ディスクの復元|  VHD ファイルと json ファイル |

これらのファイルはリストア後自動では削除されませんが、手動で削除することが可能です。

### <a id="4"></a>4.参考画面ショット
 VM 名：VM-RHEL-PE という Azure VM (OS ディスク 1 つ、データディスク 2 つ) を (2) の既存の置換えにてリストアしたあとのストレージ アカウントです。
 

 ![](https://user-images.githubusercontent.com/71251920/198330594-30a09f02-cb39-41c8-ae39-1ab9a21779ac.png)

 >コンテナー名：
 vmrhelpe-51f2bd236a2e479a95cfc2bdd53b986c
 上記の通り、Azure VM 名にランダムな文字列のコンテナー名のコンテナーが作成されます。

 >VHD：
 vmrhelpe-datadisk-000-20220319-233028.vhd
 vmrhelpe-datadisk-001-20220319-233028.vhd
 vmrhelpe-osdisk-20220319-233028.vhd
 上記の通り、Azure VM 名にディスク種別および LUN 番号リストア日時 (UTC表記) が付加された vhd ファイルが作成されます。

 >json：
 azuredeployf08911fe-654a-49e1-9baa-41ca15cbb272.json
 config-sqlvm13-f08911fe-654a-49e1-9baa-41ca15cbb272.json
 parameterf08911fe-654a-49e1-9baa-41ca15cbb272.json
 上記の通り、
 「azuredeploy<リストア ジョブで使用されるJob ID>」
 「config-<VM 名>-<リストア ジョブで使用されるJob ID>」
 「parameter<リストア ジョブで使用されるJob ID>」の名前から始まるファイルが 3 つ作成されます。

「Job ID」は、コマンドからの確認や、Recovery Services コンテナー > バックアップ ジョブ > 「ジョブのエクスポート」より確認ができます。

・ジョブをエクスポートする
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-manage-windows-server#export-jobs
