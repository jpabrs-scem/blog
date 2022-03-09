---
title: Azure VM Backup のデータ転送フェーズを意図的に失敗させる方法
date: 2022-03-10 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートの 荘司 です。
今回は、**Azure VM Backup における転送フェーズを意図的に失敗させる方法**について、ご案内いたします。
*転送フェーズとは Transfer to vault フェーズを指します。
詳細については幣ブログの関連のページをご覧ください
・Transfer to vault フェーズ - Azure VM Backup の通信要件や処理の流れについて
https://jpabrs-scem.github.io/blog/AzureVMBackup/NWRequirementAndProcess/#2-2

また下記幣ブログの記事では Take Snapshot フェーズを失敗させる方法をご案内しております。
・Azure VM Backup を意図的に失敗させる方法
https://jpabrs-scem.github.io/blog/AzureVMBackup/How_to_fail_VM_backup/

## 目次
-----------------------------------------------------------
[1. Transfer to vault を失敗させる方法概略](#1)
[2. ransfer to vault を失敗させる方法の注意点](#2)
[3. Transfer to vault を失敗させる手順](#3)
-----------------------------------------------------------


## 1. Transfer to vault を失敗させる方法概略<a id="1"></a>
Azure VM Backup を実行し、Take Snapshot 完了後に該当の Azure VM のリストアポイントコレクション (ローカルスナップショットのメタデータ) を削除します。
そうすることで Transfer to vault が失敗し、バックアップストレージ(標準コンテナー/ Recovery Services コンテナー)への転送が失敗します。

## 2. ransfer to vault を失敗させる方法の注意点<a id="2"></a>
1. この方法ではリストアポイントコレクションを削除するため、リストアポイントコレクションを削除する前に取得された復元ポイントおよび該当のバックアップ ジョブで作成された復元ポイントではインスタントリストアが出来なくなります。
つまり、回復の種類が "スナップショット" のものは下記のように ***"UserErrorInstantRpNotFound" と復元するためのリソースがない旨のエラーメッセージがでて復元ができなくなります***。
"スナップショットと標準コンテナー" のものは バックアップストレージ からの復元が可能です。
![](https://user-images.githubusercontent.com/71251920/157503085-0d5ff930-b877-444f-83ab-7637015cbfeb.png)
2. この方法を実施したあと下記のようなエラーが発生しますが、再度バックアップを実行することにより解消されます。
![](https://user-images.githubusercontent.com/71251920/157502733-09a19fbb-23f5-430a-a334-55591de41b52.png)

その場合、復元した際に **"UserErrorInstantRpNotFound"** となっていた復元ポイントは **無効/Invalid** と表示されます。
![](https://user-images.githubusercontent.com/71251920/157502744-47f216d0-2f8a-4fa4-a72c-79f78a80a546.png)


## 3. Transfer to vault を失敗させる手順<a id="3"></a>
1. 失敗させたい VM にて今すぐバックアップを実行します。

2. バックアップ ジョブより該当のジョブの詳細を開き、サブタスクが以下の状態となっていることを確認します。(この状態になるのに通常 5 ~ 10 分程度かかります)
　・Take Snapshot：Completed
　・Transfer data to vault：In progress
![](https://user-images.githubusercontent.com/71251920/157502743-dd6c88d7-a959-47e1-b3cd-8cded953ceb0.png)

3. ポータルのホーム画面にて "Restore Point Celloctions" と検索し、サービス欄に出てきた Restore Point Celloctions をクリックします。
![](https://user-images.githubusercontent.com/71251920/157502742-73239758-d52f-4230-96ba-005cb7e411f6.png)

4. 検索欄に該当の VM 名を入力し、出てきた RestorePoint Collection をクリックします。
　RestorePoint Collection は "AzureBackup_<VM 名>_xxxxxxxxxxxxx" といった命名規則にて存在しております。
![](https://user-images.githubusercontent.com/71251920/157502740-150a8c21-19e4-4bdd-89ea-28e1f9db93fd.png)
5. Delete をクリックし、出現したメッセージの OK をクリックして RestorePoint Collection を削除します。
![](https://user-images.githubusercontent.com/71251920/157502739-4d1655cc-2ee2-4eb2-ba22-d8cb9d73d4af.png)
6. バックアップ ジョブが完了するのを待ちます。(状況によって数十分から数時間要する場合があります)

7. 時間が経過すると、以下のように Transfer data to vault プロセスが失敗したことを確認できます。
![](https://user-images.githubusercontent.com/71251920/157502737-ba0b8cda-001e-421e-a6d7-e3648c2c38fa.png)



