---
title: 「Azure Monitor を使用した組み込みのアラート」を利用したバックアップ ジョブ失敗のアラート通知作成例
date: 2022-01-24 12:00:00
tags:
  - Recovery Services vaults
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、**「Azure Monitor を使用した組み込みのアラート」を利用して、Recovery Services コンテナーにてバックアップ構成済のバックアップ ジョブが失敗した際にメール通知を出すよう、アラート処理ルールを作成する例** をご紹介します。

## 概要
・「Azure Monitor を使用した組み込みのアラート」を利用
・アラート処理ルールには、バックアップを構成している対象のRecovery Services コンテナーをスコープとして指定し、バックアップ ジョブが失敗した際に、指定のメールアドレスへ通知メールを送信させる


## アラート処理ルール 作成手順
Azure Backup にて、バックアップ ジョブが失敗した際にアラート通知を出す手段は、下記ドキュメントの通り複数種類ございます。
今回は **「Azure Monitor を使用した組み込みのアラート」** を利用します。
・Azure Backup の監視とレポートのソリューション
https://docs.microsoft.com/ja-jp/azure/backup/monitoring-and-alerts-overview#monitoring-and-reporting-scenarios

![How_to_set_Backup_Alert_01](https://user-images.githubusercontent.com/71251920/151009982-ca6af556-0142-42f7-b991-33de2714c482.png)

「Azure Monitor を使用した組み込みのアラート」を利用した、アラート ルールの作成手順の公開ドキュメントは下記にございます。
・ジョブの失敗のシナリオに対して Azure Monitor のアラートを有効にする
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor#turning-on-azure-monitor-alerts-for-job-failure-scenarios

![How_to_set_Backup_Alert_02](https://user-images.githubusercontent.com/71251920/151009985-41e50961-1328-4ca2-9814-116dd8eb63cf.png)

・アラートの通知を構成する
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor#configuring-notifications-for-alerts

バックアップ センター ＞ アラート処理ルール にて、新しいアラート処理ルールを作成することができます。

![How_to_set_Backup_Alert_03](https://user-images.githubusercontent.com/71251920/151009987-c76bcfcd-04f3-49f4-ae05-033d3eee4d4e.png)

![How_to_set_Backup_Alert_04](https://user-images.githubusercontent.com/71251920/151009990-288bd354-12f3-4a43-a567-3bb4b5ea9cab.png)

今回は、Recovery Services コンテナー「RSV-JPE-LRS」にて Azure Files をバックアップ構成しているため、スコープを「Recovery Services コンテナー：RSV-JPE-LRS」としています。

![How_to_set_Backup_Alert_05](https://user-images.githubusercontent.com/71251920/151009992-071f529c-b069-4e95-b579-57e41d858db5.png)

また、バックアップ ジョブのエラーを検知した際にアラート通知を発報したいため、「フィルター：重要度」とし、「階層：１ - エラー」を選択します。
・Azure Backup で保護されたワークロードの監視
　https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor#azure-monitor-alerts-for-azure-backup-preview

![How_to_set_Backup_Alert_06](https://user-images.githubusercontent.com/71251920/151009994-805f0f47-4085-4c6b-b1e0-5453f242f62f.png)

![How_to_set_Backup_Alert_07](https://user-images.githubusercontent.com/71251920/151009996-9dc217c3-e7ed-43dd-b777-a7f82bf9081b.png)

![How_to_set_Backup_Alert_08](https://user-images.githubusercontent.com/71251920/151009999-50e00252-c95e-47df-b6c9-60fb7255e24a.png)

「アクション グループ」には、送信したいメールアドレスを設定しているアクション グループを追加する、もしくは新規作成します。
今回はあらかじめ作成済のアクション グループを選択しています。


![How_to_set_Backup_Alert_09](https://user-images.githubusercontent.com/71251920/151010003-78799d24-3c6a-4ff6-a8ff-39c7c7c95e90.png)

 （補足）アクショングループには、下図のように電子メールへの通知を設定済となっています

![How_to_set_Backup_Alert_10](https://user-images.githubusercontent.com/71251920/151010005-e0d96c25-d7cc-4789-9b1e-6be5458b86f6.png)

![How_to_set_Backup_Alert_11](https://user-images.githubusercontent.com/71251920/151010009-0b53d0c3-1d15-4902-9059-ad96f54cb6e6.png)

![How_to_set_Backup_Alert_12](https://user-images.githubusercontent.com/71251920/151010014-e76647b0-3eb5-4cc8-8558-b38636996f48.png)

上図のように設定することで、Recovery Services コンテナー「RSV-JPE-LRS」にてバックアップ構成済のバックアップ ジョブが失敗した際に、指定した電子メール宛先へ、通知メールが送信されるようになります。
**Subscription 全体を指定指定していただくことで Subscription 全体の Recovery Services コンテナーに対するバックアップアラートを設定することもできます。**


![How_to_set_Backup_Alert_13](https://user-images.githubusercontent.com/71251920/151009979-8f6868a8-2edd-4d08-86a5-ef843a877bda.png)

