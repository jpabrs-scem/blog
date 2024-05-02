---
title: ASR を意図的に失敗させる方法
date: 2024-05-09 12:00:00
tags:
  - Azure Site Recovery
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Site Recovery サポートです。
今回は、アラートをテスト目的で発報するために、意図的に Azure Site Recovery ( 以下、ASR ) を失敗させる方法をご紹介します。

ASR を意図的に失敗させたい場合、主に下記 2 種類の方法にて失敗させることができます。
<font color="MediumBlue">1 種類目：</font>キャッシュ用ストレージ アカウントへの通信を切断しておく
<font color="MediumBlue">2 種類目：</font>ASR レプリケーションに関わるサービスをソース マシン上で停止しておく

本ブログ記事では [Azure VM to Azure VM (ASR)] シナリオを例として、上記の具体的な作業手順を説明します。

## 目次
-----------------------------------------------------------
[1. キャッシュ用ストレージ アカウントへの通信を切断しておく方法](#1)  
[2. ASR レプリケーションに関わるサービスをソース マシン上で停止しておく方法](#2)   
[2-1. ASR レプリケーションに関わるサービスをソース マシン上で停止しておく方法 (Winodws OS 詳細)](#2-1)  
[2-2. ASR レプリケーションに関わるサービスをソース マシン上で停止しておく方法 (Linux OS 詳細)](#2-2)  
-----------------------------------------------------------

## <a id="1"></a> 1. キャッシュ用ストレージ アカウントへの通信を切断しておく方法
[Azure VM to Azure VM (ASR)] シナリオのため、ソース マシンは Azure 仮想マシンとなります。
もっとも簡単な方法として、ソース マシンの ネットワーク セキュリティ グループ (以下、NSG) 上で下記のような送信規則を追加しておけば
キャッシュ用ストレージ アカウントへの通信を行うことができず、後続の ASR レプリケーション処理が失敗します。

・(参考) アラートのシナリオ
　https://learn.microsoft.com/ja-jp/azure/site-recovery/site-recovery-monitor-and-troubleshoot#alerts-scenarios
　"Azure Site Recovery を使用してテスト VM のアラートの動作をテストするには、キャッシュ ストレージ アカウントのパブリック ネットワーク アクセスを無効にし、"レプリケーションの正常性に重大な問題があります" アラートが生成されるようにします。"

【NSG 送信規則例】
宛先 : Service Tag
宛先サービス タグ : Storage
サービス : HTTPS
アクション : 拒否

(画面例)
![](https://github.com/jpabrs-scem/blog/assets/96324317/f0c1c8dd-4f66-49a7-b66b-709d05ca0068)

![](https://github.com/jpabrs-scem/blog/assets/96324317/bd924838-dc59-4c26-8f64-266794c07459)

(画面例 : NSG 設定前は「レプリケーション ヘルス：正常」)
![](https://github.com/jpabrs-scem/blog/assets/96324317/02ab7387-f6e2-4f2d-8261-20751bbc9683)

(画面例 : NSG 設定をしておよそ 15 分経過後)
![](https://github.com/jpabrs-scem/blog/assets/96324317/4241b9e0-a5a4-450a-bf99-a7be97f9037d)

![](https://github.com/jpabrs-scem/blog/assets/96324317/ce13af7f-75f0-4514-a606-9514ebcaeb54)

今回は事前に下記 2 種類のアラートをどちらも構成していたため、2 種類のメールアラートが発報されました。

・アラートの電子メール通知
　　https://learn.microsoft.com/ja-jp/azure/site-recovery/site-recovery-monitor-and-troubleshoot#subscribe-to-email-notifications

・Azure Site Recovery に関する組み込みの Azure Monitor アラート
　https://learn.microsoft.com/ja-jp/azure/site-recovery/site-recovery-monitor-and-troubleshoot#built-in-azure-monitor-alerts-for-azure-site-recovery-preview

![](https://github.com/jpabrs-scem/blog/assets/96324317/16faf592-6bed-4d3c-b51f-c2e6e8f3262c)

・(参考) Recovery Services コンテナーの Azure Site Recovery の現在の電子メール通知ソリューションは、引き続き動作しますか?
　https://learn.microsoft.com/ja-jp/azure/site-recovery/monitoring-common-questions#will-the-current-email-notification-solution-for-azure-site-recovery-in-recovery-services-vault-continue-to-work
　"現在のところ、既存の電子メール通知ソリューションは、新しい組み込みの Azure Monitor アラート ソリューションと共存しています。 
　　新しいエクスペリエンスに慣れ、その機能を活用するために、Azure Monitor ベースのアラートを試すことをお勧めします。"

(メール例 : アラートの電子メール通知)
件名：Azure Site Recovery Critical Notification: Virtual machine health is in Critical state
![](https://github.com/jpabrs-scem/blog/assets/96324317/07145a97-6ee7-4def-96fa-83371136fbf2)

(メール例 : 組み込みの Azure Monitor アラート)
件名：Fired:Sev1 Azure Monitor Alert Replication health changed to Critical. on rsv-jpe-lrs ( microsoft.recoveryservices/vaults ) at 5/1/2024 6:15:35 AM
![](https://github.com/jpabrs-scem/blog/assets/96324317/ebcda96b-3637-4668-bf5c-5b9f360b0a4d)

## <a id="2"></a> 2. ASR レプリケーションに関わるサービスをソース マシン上で停止しておく方法
【Windows OS の場合】
ソース マシン上の「サービス」画面にて、下記 2 つのサービスを停止することでレプリケーションができなくなり、アラートを発報可能です。
(1) InMage Scout Application Service
(2) InMage Scout VX Agent - Sentinel/Outpost

【Linux OS の場合】
ソース マシン上で「vxagent」サービスを停止することでレプリケーションができなくなり、アラートを発報可能です。

## <a id="2-1"></a> 2-1. ASR レプリケーションに関わるサービスをソース マシン上で停止しておく方法 (Winodws OS 詳細)

「サービス」画面を開きます。
Services.msc
![](https://github.com/jpabrs-scem/blog/assets/96324317/eaccd3a8-bd09-472c-be4b-cf4f092ef063)

下記 2 つのサービスを手動で停止します。
(1) InMage Scout Application Service
(2) InMage Scout VX Agent - Sentinel/Outpost
![](https://github.com/jpabrs-scem/blog/assets/96324317/5fb4fd79-d6b4-40ce-bfcf-23b6aa4939f8)

自動起動しないようスタートアップの種類を [無効] に変更しておきます。
![](https://github.com/jpabrs-scem/blog/assets/96324317/f86d6864-9a4e-4d80-afa0-04747af1efe0)

![](https://github.com/jpabrs-scem/blog/assets/96324317/ac2c5b20-acbf-4ed8-bad9-029d54671ffd)

![](https://github.com/jpabrs-scem/blog/assets/96324317/5646e521-e505-4b60-b8f8-fc65e178d481)

(画面例 : サービスを停止しておよそ 15 分経過後)
![](https://github.com/jpabrs-scem/blog/assets/96324317/dcf49eb8-9cfb-40f5-81c9-c2427a0d2e90)

![](https://github.com/jpabrs-scem/blog/assets/96324317/39b38c4c-e570-42c7-bec6-ff11d9ce0675)

(メール例 : 組み込みの Azure Monitor アラート)
![](https://github.com/jpabrs-scem/blog/assets/96324317/02b07554-4630-44e2-a318-92bee9beffef)

テスト終了後は、2 つのサービスの状態を元に戻しておきます。
![](https://github.com/jpabrs-scem/blog/assets/96324317/7310c3f1-6cc8-419c-87b4-7bfc8c52e0a7)

## <a id="2-2"></a> 2-2. ASR レプリケーションに関わるサービスをソース マシン上で停止しておく方法 (Linux OS 詳細)

ソース マシン上で「vxagent」サービスを停止することでレプリケーションができなくなり、アラートを発報可能です。

今回は例として SLES OS の マシン上で「vxagent」サービスを停止してみます。
![](https://github.com/jpabrs-scem/blog/assets/96324317/f3591578-9a1d-4706-ac73-2cdf6eda9e06)

「vxagent」サービスの状態を確認します。
正常にレプリケーションできているマシンの場合、下図のように「active」と表示される見込みです。
`systemctl status vxagent`
![](https://github.com/jpabrs-scem/blog/assets/96324317/324db4e7-aa8f-4219-a558-e20476f59f07)

「vxagent」サービスの状態を停止します。
`systemctl stop vxagent`
![](https://github.com/jpabrs-scem/blog/assets/96324317/7a1faaa4-5d05-4183-9c89-bc844ae7e175)

「vxagent」サービスが「inactive」になったことを確認します。
`systemctl status vxagent`
![](https://github.com/jpabrs-scem/blog/assets/96324317/2cdaee3b-171e-467e-92d4-3bfc4035f2c3)

(画面例 : サービスを停止しておよそ 15 分経過後)
![](https://github.com/jpabrs-scem/blog/assets/96324317/f903603e-df14-4ebb-91cf-ca700c7b558e)

![](https://github.com/jpabrs-scem/blog/assets/96324317/34680ce3-f95a-417c-9e22-154834dddcfb)

![](https://github.com/jpabrs-scem/blog/assets/96324317/d028d22d-5e85-41dc-aa03-ba6e833d67b9)

![](https://github.com/jpabrs-scem/blog/assets/96324317/eb57c071-60b7-4ada-8c86-28aeca3403e8)

(メール例 : 組み込みの Azure Monitor アラート)
![](https://github.com/jpabrs-scem/blog/assets/96324317/04ba8b03-5db7-487a-b8de-fc6f99014356)

テスト終了後は、「vxagent」サービスを元に戻しておきます。
`systemctl start vxagent`

`systemctl status vxagent`
![](https://github.com/jpabrs-scem/blog/assets/96324317/04ae5d93-c899-4a89-a54a-34ccd0d43b1c)


ASR を意図的に失敗させる方法の案内は、以上となります。