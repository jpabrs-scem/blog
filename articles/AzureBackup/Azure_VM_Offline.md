---
title: Azure VM Backup では オフライン バックアップができるのか
date: 2021-10-01 12:00:00
tags:
  - Azure Backup 
disableDisclaimer: false
---

<!-- more -->
####  Azure VM Backup では オフライン バックアップができるのか
皆様こんにちは。Azure Backup サポートの山本です。
今回はお問い合わせをいただくことが多い、 Azure VM Backup でオフライン バックアップができるのかというご要望について解説します。

こちら結論から申し上げますと可能でございます。

### オフラインバックアップについて
次に、オフライン バックアップの場合、VM の電源が落ちているのでエージェントは動いていないため、VM との連携をせずにスナップショットを取得します。(VM 内部と連携しません。)
その際の整合性は Windows VM / Linux VM を問わずクラッシュ整合性となります。

### 留意点
上記のとおり、 Azure VM の電源はオン / オフ どちらでも Azure VM Backup を取得することが可能です。
留意点としましては、バックアップ実行中 (正確にはスナップショット取得中) には電源状態の変更を行わないようにお願いします。
Azure VM Backup が失敗する可能性がございます。


以下の文章では、任意のタイミングで取得していただくバックアップを [アドホック バックアップ] 、スケジュールされ取得していただくバックアップを [スケジュール バックアップ] としています。



#### 参考情報
・Azure VM バックアップの概要 - スナップショットの整合性
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-consistency

・Azure Linux VM のアプリケーション整合性バックアップ
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-linux-app-consistent
