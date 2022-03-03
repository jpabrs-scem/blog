---
title: Azure VM Backup における CRR (クロスリージョン リストア)について
date: 2022-02-13 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートです。
今回は、Azure Backup での リージョンをまたがる復元（ = Cross-Region Restore / CRR）にて頻繁にいただくお問い合わせに関して、下記 3 点ご案内いたします。


## 目次
-----------------------------------------------------------
[1. CRR 機能を有効した場合の、冗長性オプションは「GRS」になるのか、「RA-GRS」になるのか？](#1)
[1-1. Azure Portal での CRR 有効時の確認方法](#1-1)
[2. セカンダリ リージョンへ復元ポイントがレプリケートされるまでに、最大何時間かかるのか？](#2)
[3. セカンダリ リージョンへ復元ポイントがいつレプリケート完了したか、Azure ポータル画面上でどのように確認すればよいのか？](#3)
[3-1. 補足：バックアップ ジョブについて](#3-1)
-----------------------------------------------------------

## <a id="1"></a> 1 CRR 機能を有効した場合の、冗長性オプションは「GRS」になるのか、「RA-GRS」になるのか？

結論から申し上げますと、RA-GRS となります。
![CRR_01](https://user-images.githubusercontent.com/71251920/153718070-4b865afe-f876-47e2-afd0-2484e7889235.gif)

・Azure Backup 用語集 - Azure Backup | Microsoft Docs
https://docs.microsoft.com/ja-jp/azure/backup/azure-backup-glossary#grs

 
Azure Backup における冗長性の概要については、以下ブログ記事をご参考ください。
**・(ページ作成中)**

### <a id="1-1"></a>  Azure Portal での CRR 有効時の確認方法
ご参考までに、CRR 機能を有効にした場合の Azure ポータル画面上の見え方を説明いたします。 
Recovery Services コンテナー「RSV-JPE-GRS-CRR」は「ストレージ レプリケーションの種類：geo 冗長」かつ「リージョンをまたがる復元：有効にする」となっております。
これによって CRR 機能が有効 (=RA-GRS) となります。

![CRR_02](https://user-images.githubusercontent.com/71251920/153718069-e91606c7-4001-40d7-8ec1-4596719263c5.gif)

CRR 機能が有効になっている場合、「バックアップ アイテム」画面上では「主要領域」のほかに「2 次領域」も選択できるよう、活性化されます。
![CRR_03](https://user-images.githubusercontent.com/71251920/153718068-75b83793-921b-41ce-a330-4d957fd9e11f.gif)
![CRR_04](https://user-images.githubusercontent.com/71251920/153718067-585d2fb5-242b-4352-87e9-efbb5ba0984e.gif)

 一方でRecovery Services コンテナー「リージョンをまたがる復元：無効にする」の場合は、下図のように「主要領域」のみが選択となり、かつ非活性表示となります。
 ![CRR_05](https://user-images.githubusercontent.com/71251920/153718066-3ecee4e8-f824-49c1-bd0c-8e9fed23b2f1.png)

## <a id="2"></a> 2. セカンダリ リージョンへ復元ポイントがレプリケートされるまでに、最大何時間かかるのか？
セカンダリリージョンへのデータのレプリケーションは、プライマリリージョンへのバックアップジョブが完了 (最大24時間) してから 12 時間以内にレプリケーションが完了するように動作します。
そのため、プライマリリージョンのバックアップジョブ完了とセカンダリリージョンへのレプリケーションにはラグが生じます。

・Azure portal を使用して VM を復元する - Azure Backup | Microsoft Docs
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-in-secondary-region
> 現在、セカンダリ リージョンの RPO は "36 時間" です。 これは、プライマリ リージョンの RPO が "24 時間" であり、プライマリからセカンダリ リージョンへのバックアップ データのレプリケーションに最大 "12 時間" かかることがあるためです。

## <a id="3"></a> 3. セカンダリ リージョンへ復元ポイントがいつレプリケート完了したか、Azure ポータル画面上でどのように確認すればよいのか？
Recovery Services コンテナー ＞ バックアップ アイテム ＞ 2 次領域 ＞ Azure Virtual Machine ＞ 対象の仮想マシンを選択し、「復元ポイント」欄に、対象の復元ポイントが表示されていれば、 2 次領域へのレプリケートは完了していると判断できます。
![CRR_08](https://user-images.githubusercontent.com/71251920/153718060-4b01fca7-5815-4b8a-b2e8-3eb2f32ffa17.png)
作業例）主要領域に配置されている仮想マシン「SAPHANA03」を「今すぐバックアップ」を実施し、取得された復元ポイントが 2 次領域に複製されているかを確認する



下図画面の黄色罫線部分が、「今すぐバックアップ」にてトリガーし、バックアップが完了したバックアップ ジョブです。
***2021/12/9 17:50 に「今すぐバックアップ」のバックアップ ジョブがトリガーされ、18:21 ごろにバックアップが完了しております。***
![CRR_09](https://user-images.githubusercontent.com/71251920/153718059-212e67d8-e43b-483f-9f18-19906a8b0805.gif)

バックアップ アイテム ＞ 主要領域 ＞ Azure Virtual Machine 画面上の「最新の復元ポイント」に表示されている時刻は、バックアップが実行開始された時刻となります。
![CRR_10](https://user-images.githubusercontent.com/71251920/153718057-67e701d6-4f7b-44e7-bbfc-add77d52be00.jpg)

「主要領域」側のバックアップ項目画面では、「復元ポイント」欄に、取得済の復元ポイントが表示されています。
![CRR_11](https://user-images.githubusercontent.com/71251920/153718056-ffaa1520-c74a-424e-a0ed-b58585c6235d.png)

一方で、バックアップ アイテム ＞ 2 次領域 ＞ Azure Virtual Machine ＞ 対象の仮想マシンをクリックします。
バックアップ項目画面では、***「復元ポイント」欄に、12/09 18:32 時点では、12/09 に主要領域側にて取得済の復元ポイントはまだ表示されておらず、2 次領域側に復元ポイントが複製されていないことが分かります。***
（2021/12/09 24時ごろも確認しましたが、復元ポイントは表示されておりませんでした）
![CRR_12](https://user-images.githubusercontent.com/71251920/153718055-f4e602c6-942e-4542-bc68-1105e1e595d2.png)


同じく、「セカンダリ リージョンへの復元」をクリックし、「復元ポイントの選択」欄を表示しても、***12/09 17:50 に開始・取得済の復元ポイントは表示されていないことが確認できます。***
![CRR_13](https://user-images.githubusercontent.com/71251920/153718054-b2f2fa69-cee7-4fb6-9997-46186c01f2b2.png)

2021/12/09 17:50 Auzre VM Backup 開始後、 ***12 時間以上経過した 2021/12/10 8:09 時点では、「復元ポイントの選択」欄にて、セカンダリ リージョンのデータとして 17:50 のバックアップ開始分が表示されていることが確認できました。***

![CRR_14](https://user-images.githubusercontent.com/71251920/153718052-24c17913-41e2-4936-bb36-39735f087e94.png)

### <a id="3-1"></a> 補足：バックアップ ジョブについて
Recovery Services コンテナー ＞ バックアップ ジョブ ＞「View jobs in secondary region」をクリックすると、2 次領域のバックアップ ジョブを確認可能です。
しかし、主要領域に配置されている仮想マシン「SAPHANA03」の「今すぐバックアップ」のバックアップ ジョブは、 2 次領域のバックアップ ジョブ上には表示されません。
![CRR_15](https://user-images.githubusercontent.com/71251920/153718051-58d3846a-cb16-4509-982d-f9034093cf3d.gif)

![CRR_16](https://user-images.githubusercontent.com/71251920/153718050-bf4b2841-6c14-40fa-8c21-94d806c47872.jpg)
 


CRR に関する説明は以上となります。
