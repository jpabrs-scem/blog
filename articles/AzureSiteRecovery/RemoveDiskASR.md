---
title: Azure Site Recovery レプリケーション中にディスクを削除した場合
date: 2024-06-04 12:00:00
tags:
  - Azure Site Recovery
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Site Recovery サポートです。
今回は、Azure Site Recovery ( 以下、ASR ) レプリケーション中に、ディスクを削除した場合についてお話します。

ASR レプリケーション中に以下のディスクを削除すると、レプリケーション エラーが発生し、ASR の運用に不具合が発生する場合がございます。

・レプリケーション中の保護対象サーバーに接続されているディスク (ソース ディスク)
・レプリカ マネージド ディスク (本記事の下部に詳細を記載いたします)

**そのため、ASR レプリケーション運用中は、該当ディスクを削除されないようご留意いただけますと幸いです。**

### ASR レプリケーション中にソース VM からディスクを削除されたい場合
ASR レプリケーション中に、ソース VM からディスクを削除されたい場合、一度レプリケーションを無効化いただき、ディスク削除後に、再度レプリケーションを有効化いただく必要がございます。
また、ASR レプリケーション中に特定のディスクをレプリケーションから除外されたい場合も、一度レプリケーションを無効化いただき、以下公開情報をご参考いただき ASR 除外構成を実施いただけますと幸いです。

・ディザスター リカバリーからディスクを除外する
https://learn.microsoft.com/ja-jp/azure/site-recovery/exclude-disks-replication

### レプリカ マネージド ディスクとは
ASR レプリケーションでは、すべてのソース ディスクで、データは Azure 上のマネージド ディスクにレプリケートされます。 
このコピー先のマネージド ディスクがレプリカ マネージド ディスクです。ここには、ソース ディスクのコピーとすべての回復ポイントのスナップショットが格納されます。
レプリカ マネージド ディスクは、ディスク名に ASRReplica や asrseeddisk といった文字列が含まれておりますので、見分けることができます。

Azure ポータルの ASR 管理画面よりご確認いただくことも可能です。
ホーム > バックアップ センター | インスタンスのバックアップ > レプリケートされた項目 > (対象の VM) | ディスク と移動し、[レプリカ ディスク名] の欄からご確認いただけます。

・ターゲット リソース
https://learn.microsoft.com/ja-jp/azure/site-recovery/azure-to-azure-architecture#target-resources

・asrseeddisk とは何ですか?
https://learn.microsoft.com/ja-jp/azure/site-recovery/vmware-azure-common-questions#what-is-asrseeddisk

### 参考文献
レプリケートされるマシン - ストレージ
https://learn.microsoft.com/ja-jp/azure/site-recovery/azure-to-azure-support-matrix#replicated-machines---storage
*"ディスクのホット リムーブ - サポートされていません - VM 上でデータ ディスクを削除する場合は、レプリケーションを無効にしてから、もう一度 VM に対してレプリケーションを有効にする必要があります。"*

Azure Site Recovery レプリケーション中にディスクを削除した場合の案内は、以上となります。
