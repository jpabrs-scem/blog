---
title: Azure Files Backup を意図的に失敗させる方法
date: 2022-01-10 12:00:00
tags:
  - Azure Files Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、アラート通知のテスト等のために、**Azure Files （Azure ファイル共有）のバックアップを意図的に失敗させる方法**についてご案内します。
方法としては、バックアップ構成しているAzure Files のストレージ アカウントに対して「読み取り専用」ロックを追加しておき、スケジュール バックアップを実施する方法がございます。


## Azure Files のAzure Backup ジョブを意図的に失敗させる方法
1) テスト希望時間に、スケジュールされたバックアップを実行させたい場合は、（ストレージ アカウントへ「読み取り専用」ロックを追加する前に）Recovery Services コンテナー ＞ バックアップ ポリシー にて、スケジュール バックアップを実行したい時間を変更しておきます。
![](https://user-images.githubusercontent.com/71251920/148649503-d62312ca-088e-49ea-98a1-f503b4b0f5e2.png)

2) バックアップ構成をしている Azure Files のストレージ アカウントに対して「読み取り専用」ロックを追加しておき、スケジュール バックアップが実行開始されるまで待ちます。(または今すぐバックアップを実行します。)
（※ 「AzureBackupProtectionLock」という「削除」ロックが自動的に追加されている場合、「読み取り専用」ロックを追加してもバックアップが成功します。
一度「AzureBackupProtectionLock」ロックを削除したうえで「読み取り専用」ロックを追加しておきます。）
![](https://user-images.githubusercontent.com/71251920/148649504-9477278b-381c-4966-ad88-c38750bddf3f.png)
![](https://user-images.githubusercontent.com/71251920/148649505-f9da8577-1942-42a8-9ffb-1b6b01d365a1.png)
![](https://user-images.githubusercontent.com/71251920/148649491-01ec384a-493e-4c28-b40c-5150c3fe894a.png)

3) バックアップの実行後に、Recovery Services コンテナー ＞ バックアップ ジョブ にて、ジョブが失敗していることを確認します。
![](https://user-images.githubusercontent.com/71251920/148649493-f43a1cdf-dae3-4b30-b3a0-7efa24eb8d7d.png)
「View details」をクリックすると、「Error Code：400190」にてAzure Files のバックアップが失敗していることが確認できます。
![](https://user-images.githubusercontent.com/71251920/148649494-a738edda-9b29-4b64-8d49-b89281946dce.png)

4) 指定したメールアドレスへアラート通知を送信するよう設定している場合、指定のメールアドレスへアラート通知が送信されていることが確認できます。

アラート設定に関しましては下記をご覧ください。
・「Azure Monitor を使用した組み込みのアラート」を利用したバックアップ ジョブ失敗のアラート通知作成例
https://jpabrs-scem.github.io/blog/AzureBackupGeneral/How_to_set_Backup_Alert/

![](https://user-images.githubusercontent.com/71251920/148649496-1799a8de-0156-4556-b02f-447c64605e69.png)

![](https://user-images.githubusercontent.com/71251920/148649498-49c6aea5-4381-4cdc-8e1c-5a181eec5e5d.png)

5) バックアップ センター でもアラートを確認可能です。
バックアップ センター ＞ 概要 ＞ データソースの種類：Azure Files（Azure Storage）を選択します。
「ジョブ(過去 24 時間)」欄に「スケジュールされたバックアップ 失敗」にカウントされていること、「アクティブなアラート(過去 24 時間)」欄に「Sev1」としてカウントされていることが確認できます。

![](https://user-images.githubusercontent.com/71251920/148649499-e7dd44af-21e0-4217-b1b6-638e17ed6f16.png)

![](https://user-images.githubusercontent.com/71251920/148649500-fce2b072-d882-416e-a919-9124b9cf314a.png)

アラート通知の検証後は、ストレージ アカウントに対して自動的に追加されていた「削除」ロックを再追加・「読み取り専用」ロックを削除し、元のロック状態に戻します。

![](https://user-images.githubusercontent.com/71251920/148649502-836ffea1-9659-475d-9230-8ec612158642.png)


