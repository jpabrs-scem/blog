---
title: Azure VM Backup にて取得した復元ポイントの保持期限を確認する方法
date: 2024-05-08 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、**Azure VM Backup にて取得した復元ポイントの保持期限を確認する方法** について、ご案内いたします。


## 目次
-----------------------------------------------------------
[1. スケジュール バックアップにて取得した復元ポイントの保持期限を確認されたい場合](#1)
[2. 「今すぐバックアップ」にて取得した復元ポイントの保持期限を確認されたい場合](#2)
 [ 2-1. Azure ポータル画面から確認する](#2-1)
 [ 2-2. Azure ポータル画面より、定期的に csv へエクスポートする](#2-2)
[3. 参考 - 改善リクエストについて](#3)
-----------------------------------------------------------

## 1. スケジュール バックアップにて取得した復元ポイントの保持期限を確認されたい場合<a id="1"></a>
スケジュール バックアップにて取得する復元ポイントは、バックアップ ポリシーにて設定した保持期限に従って保持されますので、設定しているバックアップ ポリシーを参照ください。

Recovery Services コンテナー ＞ バックアップ ポリシー にて確認可能です。
もしくは、下図のように Recovery Services コンテナー ＞ バックアップ アイテム ＞ Azure Virtual Machine ＞ 対象の仮想マシンを選択し、「バックアップ ポリシー」を確認可能です。

![HowToCheckRetentionPeriodForVMBackup_01](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_01.png)


## 2. 「今すぐバックアップ」にて取得した復元ポイントの保持期限を確認されたい場合<a id="2"></a>
### 2-1. Azure ポータル画面から確認する<a id="2-1"></a>

以下のいずれかの方法で「今すぐバックアップ」にて取得した復元ポイントの保持期限の確認が可能です。

＜バックアップ ジョブから確認する場合＞

「今すぐバックアップ」にて取得した復元ポイントの保持期限は、Azure ポータル画面上の「バックアップ ジョブ」画面から確認可能です。
対象のRecovery Services コンテナー ＞ バックアップ ジョブ ＞ 「View details」をクリックいただき、「Recovery Point Expiry Time in UTC」欄をご確認ください。

・復旧ポイントの管理
https://docs.microsoft.com/ja-jp/azure/backup/manage-recovery-points#frequently-asked-question

![HowToCheckRetentionPeriodForVMBackup_02](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_02.png)

![HowToCheckRetentionPeriodForVMBackup_03](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_03.png)

なお、復元ポイントの保持期限情報を含めた、Azure ポータル画面上のバックアップ ジョブ情報の保持期間は、最大 6 か月間でございます。
（弊社検証環境にて確認したところ、現状 1 年以上前のバックアップ ジョブも確認はできましたが、仕様としては 6 か月間となっております）
そのため、6 か月以上前の バックアップ ジョブ履歴を保持し、オンデマンド バックアップにて取得したバックアップ ポイントの保持期限を確認されたい場合は[ csv へのエクスポート ](#2-2)をご検討ください。

＜バックアップ項目から確認する場合＞

「今すぐバックアップ」にて取得した復元ポイントの保持期限は、Azure ポータル画面上の「バックアップ項目」画面からも確認可能です。
対象のRecovery Services コンテナー ＞ バックアップ アイテム ＞ バックアップ対象の VM の「View details」をクリックいただき、バックアップ項目の「有効期限」欄をご確認ください。

![image](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_04.png)

なお、「有効期限」はUTC表記となります。
「有効期限」は、スナップショット層に保管されている復元ポイントについては、「インスタント回復スナップショットの保有期間」が表示される仕様となっております。

### 2-2.Azure ポータル画面より、定期的に csv へエクスポートする<a id="2-2"></a>
対象の Recovery Services コンテナー ＞ バックアップ ジョブから、「Filter」にて任意の期間等を選択いただき、バックアップ ジョブが存在するうちに「Export jobs」を実施いただきますよう、お願いいたします。
 ![HowToCheckRetentionPeriodForVMBackup_04](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_05.png)
 ![HowToCheckRetentionPeriodForVMBackup_05](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_06.png)
 ![HowToCheckRetentionPeriodForVMBackup_07](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_07.png)
 ![HowToCheckRetentionPeriodForVMBackup_08](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_08.png)

## 3. 参考 - 改善リクエストについて<a id="3"></a>
・現状は「今すぐバックアップ」で取得した復元ポイントの保持期限は、Azure ポータル画面＞バックアップ ジョブからのみ確認可能
・Azure ポータル画面＞バックアップ ジョブ は、6 か月で表示が切れる仕様のため、すべての情報を保持したい場合は、最低 6 か月ごとにAzure ポータル画面からCSVエクスポートを手動で行う必要がある
（Azure PowerShell 、Azure CLI 、REST API にて「保持期限」を含めたバックアップ ジョブの確認やExportは不可な状況）
上記の仕様については、お客様よりコマンド実行で保持期限を取得できるようにするなど、利便性を向上してほしいとのこと、ご要望をいただいております。
そのため下記サイトにて、弊社開発部門へ機能の改善リクエストを投稿しております。
下記サイトは、お客様が希望する機能がない場合にお客様から、弊社開発部門へ機能のリクエストを上げることができるサイトとなっております。
https://feedback.azure.com/d365community/idea/fb238a80-2954-ec11-a81a-6045bd78b970
 
当サイトは多数の要望がリクエストされ、投票数が多いものから機能改修の検討がなされますため、現状仕様の改善をご要望の場合は、可能であれば下図「投票数」のボタンをクリックいただけますと幸いです。
（「投票」時はマイクロソフト アカウントが必須となります）
![HowToCheckRetentionPeriodForVMBackup_09](./HowToCheckRetentionPeriodForVMBackup/HowToCheckRetentionPeriodForVMBackup_09.png)

Azure VM Backup にて取得した復元ポイントの保持期限を確認する方法について、ご案内は以上となります。
