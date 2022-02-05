---
title: Azure Backup におけるウイルス除外設定
date: 2022-02-06 12:00:00
tags:
  - Azure VM Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回はお問い合わせをいただくことが多い、 **Azure Backup を利用する際のウイルス検知の除外設定**  について、Azure VM Backup と MARS バックアップの場合それぞれについてご説明させていただきます。

## 目次
-----------------------------------------------------------
[1. Azure VM Backup の場合のウイルス検知除外設定](#1)
 [1-1. Windows OS の場合](#1-1)
 [1-2. Linux OS の場合](#1-2)
[2. サブタスク (Take Snapshot フェーズ) にかかった時間を確認する方法](#2)
 [ フィードバックご協力のお願い](#2-1)
-----------------------------------------------------------

## 1. Azure VM Backup の場合のウイルス検知除外設定<a id="1"></a>
Azure VM Backup とは Azure 上の VM に対するバックアップサービスです。
・Azure VM バックアップの概要
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction

wWindows OS と Linux OS に場合分けしてお伝えします。

### 1-1. Windows OS の場合<a id="1-1"></a>
下記をアンチウイルス ソフトの除外設定から除外してください。
> C:\Packages\Plugins\Microsoft.Azure.RecoveryServices.VMSnapshot
> C:\WindowsAzure\Logs\Plugins\Microsoft.Azure.RecoveryServices.VMSnapshot


### 1-2. Linux OS の場合<a id="1-2"></a>
下記をアンチウイルス ソフトの除外設定から除外してください。
> `/var/lib/waagent/WALinuxAgent
> /var/lib/waagent/Microsoft.Azure.RecoveryServices.VMSnapshotLinux


#### 2.MARS バックアップのウイルス検知除外設定<a id="2"></a>
MARS バックアップ (Azure MARS Backup エージェントを利用したバックアップ) とはクラウドかオンプレミス環境かを問わず、Windows OS において、ファイルとフォルダー単位のバックアップやシステム状態のバックアップを 取得し Azure 上に保存するバックアップサービスです。

・Microsoft Azure Recovery Services (MARS) エージェントを使用したバックアップのサポート マトリックス
https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mars-agent


下記をアンチウイルス ソフトの除外設定から除外してください。
> C:\Program Files\Microsoft Azure Recovery Services Agent\bin\cbengine.exe (プロセスとして除外)
> C:\Program Files\Microsoft Azure Recovery Services Agent\ 
>スクラッチ場所 (標準的の場所を使用していない場合)

なお、上記は下記の公式ドキュメントにも記載されております。
・Azure Backup でファイルとフォルダーのバックアップが遅い場合のトラブルシューティング - 原因: Azure Backup の妨げになっている別のプロセスまたはウイルス対策ソフトウェア
  https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-troubleshoot-slow-backup-performance-issue#cause-another-process-or-antivirus-software-interfering-with-azure-backup

