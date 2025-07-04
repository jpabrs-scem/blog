---
title: Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの料金の違い
date: 2025-06-30 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、Azure VM Backup において、
「Standard バックアップ ポリシー (標準ポリシー) 」でバックアップを取得した場合と
「Enhanced バックアップ ポリシー (拡張ポリシー) 」でバックアップを取得した場合のそれぞれの料金の違いについて説明します。 
![image](./VM_Backup_billing/VM_Backup_billing_01.png)

(参考 関連ブログ記事)
・料金計算ツールを用いた Azure VM Backup の料金見積もりについて | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)
　https://jpabrs-scem.github.io/blog/AzureVMBackup/VM_Backup_calculator/

## 目次
-----------------------------------------------------------
[1. Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの機能の違いについて](#1)
[2. Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの料金の違い](#2)
[3. スナップショット料金の請求先について](#3)
-----------------------------------------------------------

## 1. Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの機能の違いについて<a id="1"></a>
それぞれのバックアップ ポリシーで Azure VM Backup を取得する場合の機能の違いは下記公開ドキュメントをご参照ください。
・拡張ポリシーを使用して Azure VM をバックアップする - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-enhanced-policy?tabs=azure-portal


## 2. Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの料金の違い<a id="2"></a>
### Azure VM Backup の料金
Azure VM Backup を利用する場合、その料金を見積もる際には以下 3 点が課金項目となります。
　(1) Azure 仮想マシンのインスタンスに対する課金
　(2) Recovery Services コンテナーに保管されるバックアップ データに対する課金
　(3) Azure VM Backup の機能で取得されるスナップショットに対する課金

(1) と (2) の課金は、「Standard バックアップ ポリシー」でバックアップ取得しても、「Enhanced バックアップ ポリシー」でバックアップ取得しても、どちらも同じ料金計算方式となります。

この 2 項目は、下記公開ドキュメント上で説明している「保護されたインスタンス サイズ (1) 」「バックアップ ストレージの課金 (2) 」箇所に相当します。

(参考ドキュメント)  
・バックアップのコスト
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#backup-costs
　引用 : "保護されたインスタンス サイズの計算は、"実際の" VM のサイズに基づきます。"
　引用 : "同様に、バックアップ ストレージの課金は、Azure Backup に格納されているデータ量 (各回復ポイントの実際のデータの合計) に基づきます。"

いっぽう (3) の課金は、「Standard バックアップ ポリシー」でバックアップ取得する場合と、「Enhanced バックアップ ポリシー」でバックアップ取得する場合とで、料金の加算方法が変わってきます。

> [!WARNING]
> Standard バックアップ ポリシーにてトラステッド起動 VM のバックアップを取得する場合にのみ、(3) の課金は「Enhanced バックアップ ポリシー」でバックアップを取得する場合と同じになります。  
> もし該当する場合には、以下説明は「Enhanced バックアップ ポリシー」の箇所をご確認ください。  

### 「Azure VM Backup の機能で取得されるスナップショットに対する課金」の加算方法の違い
「Standard バックアップ ポリシー」では、初回のスナップショット取得時点では料金は発生しません。
「Enhanced バックアップ ポリシー」では、初回のスナップショット取得時点で、使用データ量分のスナップショットに対して料金が発生します。

また、1 GB あたりの課金額は以下の通りそれぞれ違いがあります。
 
Standard (標準) ポリシー : 0.12 ドル/ 1 GB
Enhanced (拡張) ポリシー : 0.05 ドル/ 1 GB

※ リージョンにより料金が異なる場合がございます。(上記 および 以下の参考例は、USEast2 の価格となります。)
 
下記の表は 100 GB の容量をもつ Azure 仮想マシンに対して、毎日 1 GB の増分が発生するケースにおいて、スナップショットを 4 日間保管した場合の比較表となります。
※ 表中の料金は前日からの増分により発生した課金の月額を示しており、実際の料金は保存期間によって変動する場合があります。
(参考例)
![](./VM_Backup_billing/VM_Backup_billing_02.png)
※1 便宜上 100 GB と記載しておりますが、より正確には初回のスナップショット取得時点では 0 GB となります。
(その後の変更ブロック発生によりスナップショット サイズが増大いたします)

上記サンプルケースでは Enhanced バックアップ ポリシー 利用時の方が費用は高くなりますが、初回のバックアップ データ量が減った場合や、翌日以降の増分データ量が増加する場合は、Standard バックアップ ポリシー利用時の方が割高となるシナリオも考えられます。

「(3) Azure VM Backup の機能で取得されるスナップショットに対する課金」における
リージョン毎のスナップショット料金詳細は下記をご参照ください。

#### Standard バックアップ ポリシー - スナップショットに対する料金
下記リンクから、リージョン・通貨をご希望のものへと設定変更いただければ、スナップショットに対する料金を確認できます。
・Azure ページ BLOB Storage の価格 | Microsoft Azure
　https://azure.microsoft.com/ja-jp/pricing/details/storage/page-blobs/

![](./VM_Backup_billing/VM_Backup_billing_03.png)

#### Enhanced バックアップ ポリシー - スナップショットに対する料金
下記リンクから、リージョン・通貨をご希望のものへと設定変更いただければ、スナップショットに対する料金を確認できます。
・料金 - Managed Disks | Microsoft Azure
　https://azure.microsoft.com/ja-jp/pricing/details/managed-disks/

![](./VM_Backup_billing/VM_Backup_billing_04.png)

## 3. スナップショット料金の請求先について<a id="3"></a>
　(1) Azure 仮想マシンのインスタンスに対する課金
　(2) Recovery Services コンテナーに保管されるバックアップ データに対する課金
　(3) Azure VM Backup の機能で取得されるスナップショットに対する課金

上記料金の請求書上では、各項目 および バックアップ ポリシーの違いによって、次に示す表のように表示されます。 
Azure Backup の 料金として請求される項目は (1) (2) であり、(3) は スナップショットにかかった料金 として別の項目として請求されます。 

|  課金項目  |  バックアップ ポリシー  |  サービス名  |  請求上の表示 (Meter)  |  請求されるリソースグループ   |
| :----- | :----- | :----- | :----- | :----- |
|  (1)  |  Standard / Enhanced バックアップ ポリシー  |  Backup  |  Azure VM Protected Instances  |  Recovery Services コンテナーのリソース グループ  |
|  (2)  |  Standard / Enhanced バックアップ ポリシー  |  Backup  |  <span style="color: red; ">LRS</span> Data Stored   |  Recovery Services コンテナーのリソース グループ  |
|  (3)  |  Standard バックアップ ポリシー  |  Storage  |  LRS snapshots   |  Managed Disk のリソース グループ  |
|  (3)  |  Enhanced バックアップ ポリシー  |  Storage  |  Snapshots ZRS Snapshots   |  復元ポイント コレクションのリソース グループ  |

　( <span style="color: red; ">赤文字</span>部分は、対象 Recovery Services コンテナーの「ストレージ レプリケーションの種類」によって変わります)

ご参考までに、弊社検証環境にて確認した各項目の表示例を以下に示します。 
画像 1 : コスト分析画面にて確認した (1) および (2) の表示例（ストレージ レプリケーションの種類  : ローカル冗長 (LRS)） 
![画像 1](./VM_Backup_billing/VM_Backup_billing_05.png)

 画像 2 : コスト分析画面にて確認した (3) の表示例 (Standard バックアップ ポリシー) 
![画像 2](./VM_Backup_billing/VM_Backup_billing_06.png)

(参考) 画像 2 のバックアップ対象 の VM の Azure Managed Disk のリソース グループ名 : rgsqlag 
![参考](./VM_Backup_billing/VM_Backup_billing_07.png)

画像 3 : コスト分析画面にて確認した (3) の表示例 (Enhanced バックアップ ポリシー) 
![画像 3](./VM_Backup_billing/VM_Backup_billing_08.png)

(参考) 画像 3 の復元ポイント コレクションのリソース グループ名 : azurebackuprg_eastus_1 
![参考](./VM_Backup_billing/VM_Backup_billing_09.png)

(補足)
各バックアップ ポリシーにて取得されるスナップショットはそれぞれ以下のスナップショット層へ格納されます。 
　・Standard バックアップ ポリシー : LRS のスナップショット層 
　・Enhanced バックアップ ポリシー : ZRS のスナップショット層 

(参考ドキュメント)  
・拡張ポリシーを使用して Azure VM をバックアップする
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-enhanced-policy?tabs=azure-portal
　引用 : "インスタント復元層では、ゾーン冗長ストレージ (ZRS) の回復性を使用してゾーン冗長性が確保されています。"

本記事の内容は以上となります。