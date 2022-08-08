---
title: Azure VM Backup と Azure Site Recovery による DR 要件について
date: 2022-08-08 12:00:00
tags:
  - Recovery Services vaults
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは。Azure VM 、Azure Site Recovery 担当です。
今回は Azure のリージョン障害などを想定した Azure VM の Disaster Recovery (DR) 対策を検討中のお客様よりお問合せをいただきます「Azure Bacup と Azure Site Recovery どちらを利用すればいいのか？」について解説させていただきます。

結論としては、お客様の DR 要件である RTO, RPO をクリアにしていただく必要があり、ここがクリアになれば Azure VM Backup と Azure Site Recovery どちらを選択すればいいか判断できるようになると存じます。


## 目次
-----------------------------------------------------------
[1. DR, RTO, RPO について](#1)
   [  1.1 Disaster Recovery (DR)](#1-1)
   [  1.2 Recovery Time Objective (RTO)](#1-2) 
   [  1.3 Recovery Point Objective (RPO)](#1-3) 
[2. データディスクの数とバックアップやリストアにかかる時間](#2)
   [  2.1 リストア検証](#2-1) 
-----------------------------------------------------------


## <a id="1"></a> 1. DR, RTO, RPO について
まずは前提知識について DR, RTO, RPO について簡単に説明いたします。

### <a id="1-1"></a> Disaster Recovery (DR)
大規模災害などの影響によりシステムやデータセンターが障害を受けた際に、利用できなくなったシステムを素早く復旧するための計画やそのような状態を未然に防ぐことを指します。
事業者様によって整備されている、BCP (事業継続計画) をご確認いただくことで後の RTO, RPO の指標が明確になるかと存じます。

### <a id="1-2"></a> Recovery Time Objective (RTO)
「目標復旧時間」のことで、大規模災害などの影響によりシステムやデータセンターが障害を受けシステムが停止した時に、その時点から復旧までにかかる時間のことを指します。どのくらいの時間がダウンタイムとして許容できるかをご確認いただくのが良いかと存じます。
* ダウンタイムの許容時間は最大 24 時間。など

### <a id="1-3"></a> Recovery Point Objective (RPO)
「目標復旧時点」のことで、大規模災害などの影響によりシステムやデータセンターが障害を受けシステムが停止した時に、過去のどの時点のデータまでを復旧できるかを指します。障害時点から復旧ポイントまでの間の時間のデータは復旧できないことになるため、データ復旧ができなくても許容できる時間をご確認いただくのが良いかと存じます。
* データ損失の許容時間は直前 12 時間以内。など


 

## <a id="2"></a> 2. Azure VM Backup と Azure Site Recovery の比較
以下は Azure VM Backup と Azure Site Recovery の比較表です。
2 時間以上のダウンタイム (RTO) が許容されない場合や、24 時間以上のデータ損失が許容されない場合など Azure VM Backup で対応できない場合には Azure Site Recovery の採用をご検討いただければと存じます。

| # | Azure VM Backup | Azure Site Recovery |
| :--- | :--- | :--- |
| 機能 | Azure VM のバックアップを取得します。<br>
Recovery Services コンテナーを GRS (または RA-GRS) にすることで、ペア リージョンへのバックアップ データのレプリケーションが行われペア リージョンでの復元ができるようになります。
 | Azure VM のデータをターゲット リージョンのディスクへレプリケーションします。 |
| RTO に関する SLA | RTO について SLA はありません。 | SLA で 2 時間以内の RTO を保証します。<br> ・Azure Site Recovery の SLA<br>https://azure.microsoft.com/ja-jp/support/legal/sla/site-recovery/v1_2/<br>
>オンプレミスと Azure 間の計画上および計画外のフェールオーバー用に構成された保護された各インスタンスにつき、マイクロソフトは、2 時間の目標復旧時間を保証します。
| 復旧ポイントの保持期間 | 最大 99 年保持することができます。 | Unmanaged Disk では最大 72 時間 (3 日) 保持することができます。
Managed Disk では最大 15 日保持することができます。 |
| Recovery Time Objective (RTO) | 24時間以内に完了する仕様となっております。
* 大容量の VM では復元に 24 時間以上かかる場合がございます。
 | 2 時間以内の RTO を提供します。 |
| Recovery Point Objective (RPO)| TD | TD |


### <a id="2-1"></a> 2.1 リストア検証
(検証内容と結果)
下記それぞれの内容で 同じVM のリストアを実施し、リストア時間の所要時間を比較いたしました。
>#1　アタッチしたディスク：256GiB  × 4 本、 所要時間： 13:43
>#2　アタッチしたディスク：1024GiB × 1 本、 所要時間： 12:10

その結果、上記の通りのディスクの本数が 4 本のものが 1 本のものに比べ、 1 分 33 秒 多く時間がかかったことが結果として得られました。


お客様のお役に立てれば幸いです。
本記事は以上です。