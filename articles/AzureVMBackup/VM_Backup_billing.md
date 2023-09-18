---
title: Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの料金の違い
date: 2023-09-27 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、Azure VM Backup において、
「Standard バックアップ ポリシー (標準ポリシー) 」でバックアップを取得した場合と
「Enhanced バックアップ ポリシー (拡張ポリシー) 」でバックアップを取得した場合の、それぞれの料金の違いについて説明します。 
※　料金の違いは、現在公開ドキュメント上にも明記するよう、計画中です。
![image](https://github.com/jpabrs-scem/blog/assets/96324317/8ccd86d4-3e8e-4f19-9155-27ae50c50b9a)

(参考 関連ブログ記事)
・料金計算ツールを用いた Azure VM Backup の料金見積もりについて | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)
　https://jpabrs-scem.github.io/blog/AzureVMBackup/VM_Backup_calculator/

## 目次
-----------------------------------------------------------
[1. はじめに : Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの機能の違いについて](#1)
[2. Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの料金の違い](#2)
[3. Enhanced バックアップ ポリシー利用時の料金算出方法](#3)
-----------------------------------------------------------

## 1. はじめに : Standard バックアップ ポリシーと Enhanced バックアップ ポリシーの機能の違いについて<a id="1"></a>
それぞれのバックアップ ポリシーで Azure VM Backup を取得する場合の、機能の違いは下記公開ドキュメントをご参照ください。
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

・バックアップのコスト
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#backup-costs
　"保護されたインスタンス サイズの計算は、"実際の" VM のサイズに基づきます。"
　"同様に、バックアップ ストレージの課金は、Azure Backup に格納されているデータ量 (各回復ポイントの実際のデータの合計) に基づきます。"

いっぽう (3) の課金は、「Standard バックアップ ポリシー」でバックアップ取得する場合と、「Enhanced バックアップ ポリシー」でバックアップ取得する場合とで、料金の加算方法が変わってきます。

### 「Azure VM Backup の機能で取得されるスナップショットに対する課金」の加算方法の違い
「Standard バックアップ ポリシー」では、最初に取得されるスナップショットに対して料金はかかりません。
「Enhanced バックアップ ポリシー」では、初回のスナップショット取得時点で、使用データ量分のスナップショットに対して料金が発生します。

また、1 GB あたりの課金額は以下の通りそれぞれ違いがあります。
 
標準ポリシー:  0.12 ドル/ 1 GB
拡張ポリシー:  0.05 ドル/ 1 GB

* リージョンにより料金が異なる場合がございます。(上記 および 以下の参考例は、USEast2 の価格となります。)
 
下記の表は 100 GB の容量をもつ Azure 仮想マシンに対して、毎日 1 GB の増分が発生するケースにおいて、スナップショットを 4 日間保管した場合の比較表となります。
*表中の料金は月額を示しており、実際の料金は保存期間によって変動する場合があります。
(参考例)
![image](https://github.com/jpabrs-scem/blog/assets/96324317/c614385e-2489-40c9-9f2f-9a6a2e7c9b19)

上記サンプルケースでは Enhanced バックアップ ポリシー 利用時の方が費用は高くなりますが、初回のバックアップデータ量が減った場合や、翌日以降の増分データ量が増加する場合は、Standard バックアップ ポリシー利用時の方が割高となるシナリオも考えられます。

「(3) Azure VM Backup の機能で取得されるスナップショットに対する課金」における
リージョン毎のスナップショット料金詳細は下記をご参照ください。

#### Standard バックアップ ポリシー - スナップショットに対する料金
下記リンクから、リージョン・通貨をご希望のものへと設定変更いただければ、スナップショットに対する料金を確認できます。
・Azure ページ BLOB Storage の価格 | Microsoft Azure
　https://azure.microsoft.com/ja-jp/pricing/details/storage/page-blobs/

![image](https://github.com/jpabrs-scem/blog/assets/96324317/727481b0-cbab-4f49-976a-2b8428d5f209)

#### Enhanced バックアップ ポリシー - スナップショットに対する料金
下記リンクから、リージョン・通貨をご希望のものへと設定変更いただければ、スナップショットに対する料金を確認できます。
・料金 - Managed Disks | Microsoft Azure
　https://azure.microsoft.com/ja-jp/pricing/details/managed-disks/

![image](https://github.com/jpabrs-scem/blog/assets/96324317/69d004e5-cef6-4930-a777-43a986c713ec)

## 3. Enhanced バックアップ ポリシー利用時の料金算出方法<a id="3"></a>
現時点では、料金計算ツールは「Standard バックアップ ポリシー」利用時の料金計算見積もりとなっており
「Enhanced バックアップ ポリシー」利用時の料金計算ツールの用意がございません。

このため、「Enhanced バックアップ ポリシー」を利用して Azure VM Backup を取得する場合の料金見積もりは、下記のようにお見積りください。

(算出方法)
1 . 以下料金計算ツールにて、毎日 1 回バックアップをスケジュールする場合の金額を見積もる。(-> これを A とします)
料金計算ツール
https://azure.microsoft.com/ja-jp/pricing/calculator/
 
2 . 初回バックアップ時の VM のインスタンスサイズに対し、スナップショット料金の加算分を計算する。
100 GB であれば 0.05($) を乗算し、5$ (-> これを B とします) 。
 
3 . 日次の変更データ量に対するスナップショット料金の減額分を計算する。
「Standard バックアップ ポリシー」利用時の料金との差額は 1GB あたり 0.12 - 0.05 = 0.07 $ である為、日次で想定される変更データ量が 1GB の場合、毎日 0.07 $ x 1GB = 0.07$ の減額が発生する。
月間 31 日では、0.07 $ x 31 = 2.17 $ 発生。(-> これを C とします)
※料金計算ツールの「平均日次データ チャーン」項目について、100 GB のインスタンスサイズに対し、1 GB の変更が生じる場合、一般的なチャーンレートとしては1% となる為、平均日次チャーンは “低” となります。
![image](https://github.com/jpabrs-scem/blog/assets/96324317/1d5da2f1-93a6-4b35-9a9e-2d806c9c6450)

4 . 料金計算ツールにて、A に、BならびにC を加え、概算費用を計算します。
・初月 A - C + B (「Azure VM Backup の機能で取得されるスナップショットに対する課金」部分が反映されることになります)
・2 か月目以降 A - C

本記事の内容は以上となります。