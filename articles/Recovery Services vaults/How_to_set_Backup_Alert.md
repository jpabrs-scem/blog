---
title: 「Azure Monitor を使用した組み込みのアラート」を利用したバックアップ ジョブ失敗のアラート通知作成例
date: 2022-01-24 12:00:00
tags:
  -  Recovery Services vaults
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
・Azure Backup の監視とレポートのソリューション - Azure Backup | Microsoft Docs
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
・Azure Backup で保護されたワークロードの監視 - Azure Backup | Microsoft Docs
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

上図のように設定することで、Recovery Services コンテナー「RSV-JPE-LRS」にてバックアップ構成済ののバックアップ ジョブが失敗した際に、指定した電子メール宛先へ、通知メールが送信されるようになります。 


![How_to_set_Backup_Alert_13](https://user-images.githubusercontent.com/71251920/151009979-8f6868a8-2edd-4d08-86a5-ef843a877bda.png)

-----------------------------------------------------------

## バックアップを故意に失敗させる方法 (手順概略)
・「バックアップを故意に失敗させる方法 (Windows VM の場合) 」
>	1.Backup 対象の VM にリモート ログイン
>	2.Services 内で "RbAgent" と "Windows Azure Guest Agent" の停止、スタートアップの無効化
>	3.Backup を実施し、エラーの確認
>	4.Agent の再度起動

・「バックアップを故意に失敗させる方法 (Linux VM の場合) 」
>	1.Backup 対象の VM に SSH 接続
>	2.Agent の停止、および自動起動停止
>	3.Agent の Service を停止
>	　（Ubuntu の場合）` ` `sudo systemctl stop walinuxagent ` ` `
>	　（Ubuntu 以外の場合）` ` `sudo systemctl stop waagent` ` `
>	4.自動起動を停止
>	　（Ubuntu の場合）` ` `sudo systemctl disable walinuxagent ` ` `
>	　（Ubuntu 以外の場合）` ` `sudo systemctl disable waagent` ` `
>	5.Backup を実行し、エラーの確認
>	・Agent の再起動
>	（Ubuntu の場合）
>	　　` ` `sudo systemctl start walinuxagent ` ` `
>		　　` ` `sudo systemctl enable walinuxagent ` ` `
>		　　` ` `systemctl status walinuxagent ` ` `
>		（Ubuntu 以外の場合）
>		　　` ` `sudo systemctl start waagent` ` `
>		　　` ` `sudo systemctl enable waagent` ` `
>	　  　` ` `systemctl status waagent` ` `

## 目次
-----------------------------------------------------------
[1. バックアップを故意に失敗させる方法 (Windows VM の場合)](#1)
[2. バックアップを故意に失敗させる方法 (Linux VM の場合)](#2)
-----------------------------------------------------------

## 1. バックアップを故意に失敗させる方法 (Windows VM の場合)  (所要時間 : 2時間～6時間)<a id="1"></a>
### 1.1. 環境
本項目では以下の環境で検証を実施しております。
VM名 : vm-BackupFailTest-win2016
OS : Windows (Windows Server 2016 Datacenter) Version 1607
Recovery Service コンテナー名 : vault-BackupFailTest

### 1.2.手順概略 
"サービス" から プロセス "RdAgent"、"Windows Azure Guest Agent" を停止し、スタートアップを無効化しバックアップを実行します。
バックアップが失敗したらそれぞれをもとに戻します。
> 1. Backup 対象の VM にリモート ログイン
> 2. Services 内で "RbAgent" と "Windows Azure Guest Agent" の停止、スタートアップを無効化
> 3. Portal にて Backup を実施し、エラーの確認
> 4. Agent の再起動

### 1.3.詳細手順
Backup 対象の VM : Azure portal上で作成した、Backup 対象の VM
Backup 対象の VM にリモートログインし、Services を開き、下記 2 つのサービスに対し設定を行います。

#### RdAgent
最初に "RdAgent" を停止、スタートアップ無効にします。
・Sercives 一覧の画面で "RdAgent" を右クリック → "Properties" を選択します。
・Startup type で "Disabled" を選択 → Service status で Stop を選択 → Service 停止プロセスが完了した後、"OK" を選択します。
・Services 一覧の画面にて、 RbAgent の Status の Running が消えており、Startup Type が Disabled 場合、 RbAgent の停止が完了となります。

![RdAgent](https://user-images.githubusercontent.com/71251920/142736495-97875c34-577f-483d-a46e-c1f7c53d5133.png)

#### Windows Azure Guest Agent
次に "Windows Azure Guest Agent" を停止、スタートアップ無効にします。
・Sercives 一覧の画面で "Windows Azure Guest Agent" を右クリック → "Properties" を選択します。
・Startup type で "Disabled" を選択 → Service status で Stop を選択 → Service 停止プロセスが完了した後、 "OK" を選択します。
・Services 一覧の画面にて、 Windows Azure Guest Agent の Status の Running が消えており、Startup Type が Disabled 場合、 Windows Azure Guest Agent の停止が完了となります。

![WindowsAzureGuestAgent](https://user-images.githubusercontent.com/71251920/142736485-37260305-e959-4d30-ab6d-d2167dc8096c.png)


以上で、VM 側の設定は完了となります。

#### Backup を実施し、エラーの確認
・Azure portal を開いていただき、VM のページに移動 → "バックアップ" を選択 → "今すぐパックアップ" を選択。
この操作により、バックアップが開始されます。
・ 次に Backup の状態を確認します。
　Recovery Services コンテナーのページへ移動 → "バックアップ ジョブ" を選択後、最新の Backup の "View details" を選択します。
このページで Backup の状態を確認することができます。 
結果が表示されるまで数時間掛かりますので、 定期的に (1 時間おきなど) 更新して確認することをお勧めいたします。

![FailCheck_01](https://user-images.githubusercontent.com/71251920/142736544-cc800afd-14c5-400d-9b9c-74d535fdf1f4.png)

・Take Snapshot の Status が Failed 、Error Code **”UserErrorGuestAgentStatusUnavailable”** となり、失敗し完了となります。本環境では 5 時間 25 分かかりました。　

![FailCheck_02](https://user-images.githubusercontent.com/71251920/142736548-c5cc94e5-4343-4c81-9b8b-52ef8c46f4d8.png)

#### Agentの再起動
・エラーの発生確認完了後は、 VM に再度ログインして頂き、各 Agent の Service properties 画面で、Start up type を **"Automatic"** に、Service Status で **"Start"** を選択し、 Agent を再度起動させてください。


## 2．バックアップを故意に失敗させる方法 (Linux VM の場合) (所要時間 : 2時間～6時間) <a id="2"></a>

### 2.1. 環境
本項目では以下の環境で検証を実施しております。
#### OS
> VM名 : vm-BackupFailTest-linux-suse / OS : Linux (sles 15.2)
> VM 名 : vm-BackupFailTest-linux-rhel / OS : Linux (redhat 8.2)
> VM 名 : vm-BackupFailTest-linux-ubuntu /OS : Linux (ubuntu 20.04)
> VM 名 : vm-BackupFailTest-linux-centos / OS : Linux (centos 7.9.2009)

####  Recovery Services コンテナー
> Recovery Service コンテナー名 : vault-BackupFailTest

### 2.2手順概略 
下記コマンドを実行しagent プロセスを停止しバックアップを失敗させます。
失敗したのを確認したのち、Agent の再起動を行います。

#### Agent の停止
> Backup 対象の VM に SSH 接続します。

> ・以下のコマンドで、 Agent の Service を停止します。
> （Ubuntu の場合）sudo systemctl stop walinuxagent 
> （Ubuntu 以外の場合）sudo systemctl stop waagent

> ・以下のコマンドで、自動起動を停止します。
> （Ubuntu の場合）sudo systemctl disable walinuxagent 
> （Ubuntu 以外の場合）sudo systemctl disable waagent


#### Agent の再起動
バックアップ エラーの検証後は、以下コマンドで waagent を再開します。
> （Ubuntu の場合）
> 	sudo systemctl start walinuxagent 
> 	sudo systemctl enable walinuxagent 
> 	systemctl status walinuxagent 
> （Ubuntu 以外の場合）
> 	sudo systemctl start waagent
> 	sudo systemctl enable waagent
> 	systemctl status waagent


### 2.3. 詳細手順
Linux の場合、 OS により Agent のプロセス名が異なります。
#### Agent プロセス名
Ubuntu の場合
> walinuxagent.service

Suse & RHEL & CentOS の場合
> waagent.service


下記の手順で agentのプロセスを停止し、バックアップを失敗させます。
#### Agent の停止
・Backup 対象の VM に SSH 接続します。

> ・以下のコマンドで、 Agent の Service を停止します。
> （Ubuntu の場合）sudo systemctl stop walinuxagent 
> （Ubuntu 以外の場合）sudo systemctl stop waagent

> ・以下のコマンドで、自動起動を停止します。
> （Ubuntu の場合）sudo systemctl disable walinuxagent 
> （Ubuntu 以外の場合）sudo systemctl disable waagent

> ・以下のコマンドで、 Agent の Service の状態を確認できます。
> （Ubuntu の場合）systemctl status walinuxagent 
> （Ubuntu 以外の場合）systemctl  waagent

#### Ubuntu 環境の実行例

![Ubuntu_agent_stop_01](https://user-images.githubusercontent.com/71251920/142736815-a24dfbd6-e29c-4a08-8c90-604a8fdbae81.png)

![Ubuntu_agent_stop_02](https://user-images.githubusercontent.com/71251920/142736817-6a1fee8c-7bd2-4d5b-9bc5-c9e8ffda6f7b.png)
RHEL 環境の実行例
![RHEL_agent_stop_01](https://user-images.githubusercontent.com/71251920/142736834-94f46a91-f554-4de5-b6ea-7089b9607ff5.png)

![RHEL_agent_stop_02](https://user-images.githubusercontent.com/71251920/142736825-0e6032e3-f26f-4760-9f0b-5772d4a02168.png)

#### バックアップの実行 & 失敗確認
バックアップを実行し、バックアップ ジョブ が失敗したことを確認します。 
*バックアップの実行から失敗まで数時間かかる場合がございます。
Status が Failed 、Error Code **”UserErrorGuestAgentStatusUnavailable”** となり、失敗し完了となります。本環境では 4 時間 20 分かかりました。　

![FailCheck_03](https://user-images.githubusercontent.com/71251920/142736877-fd3190e0-596a-4a51-b0d2-f682b2a34a3e.png)


#### Agent の再起動
バックアップ エラーの検証後は、以下コマンドで waagent を再開します。
>（Ubuntu の場合）
>	sudo systemctl start walinuxagent 
>	sudo systemctl enable walinuxagent 
>	systemctl status walinuxagent 
（Ubuntu 以外の場合）
>	sudo systemctl start waagent
>	sudo systemctl enable waagent
>	systemctl status waagent

#### Ubuntu 環境の実行例　
![Ubuntu_agent_start](https://user-images.githubusercontent.com/71251920/142736924-8e033f57-60aa-449e-bb34-2fb5c410d633.png)

#### RHEL 環境の実行例　
![RHEL_agent_start](https://user-images.githubusercontent.com/71251920/142736923-43d72bbc-e3cb-46a4-825b-a4b71fe61d9a.png)

