---
title: Azure Backup におけるウイルス除外設定について
date: 2024-06-19 12:00:00
tags:
  - Azure VM Backup
  - how to
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
[2. MARS バックアップの場合のウイルス検知除外設定](#2)
-----------------------------------------------------------

## 1. Azure VM Backup の場合のウイルス検知除外設定<a id="1"></a>
Azure VM Backup とは Azure 上の VM に対するバックアップサービスです。
・Azure VM バックアップの概要
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction

Windows OS と Linux OS に場合分けしてお伝えします。

### 1-1. Windows OS の場合<a id="1-1"></a>
Windows OS の場合、下記をアンチウイルス ソフトの除外設定にいれてください。
> C:\Packages\Plugins\Microsoft.Azure.RecoveryServices.VMSnapshot
> C:\WindowsAzure\Logs\Plugins\Microsoft.Azure.RecoveryServices.VMSnapshot


なお、上記は下記の公式ドキュメントにも記載されております。
・Azure Backup の失敗のトラブルシューティング:エージェント/拡張機能に関する問題 - 手順 4:Azure Backup VM 拡張機能の正常性を確認する
https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-troubleshoot-vm-backup-fails-snapshot-timeout#step-4-check-azure-backup-extension-health

・VMRestorePointInternalError - VM で構成されているウイルス対策により、バックアップ拡張機能の実行が制限されています
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-troubleshoot#vmrestorepointinternalerror---antivirus-configured-in-the-vm-is-restricting-the-execution-of-backup-extension


### 1-2. Linux OS の場合<a id="1-2"></a>
Linux OS の場合、下記をアンチウイルス ソフトの除外設定にいれてください。
> /var/lib/waagent/WALinuxAgent
> /var/lib/waagent/Microsoft.Azure.RecoveryServices.VMSnapshotLinux


### 2 .MARS バックアップの場合のウイルス検知除外設定<a id="2"></a>
MARS バックアップ (Azure MARS Backup エージェントを利用したバックアップ) とはクラウドかオンプレミス環境かを問わず、Windows OS において、ファイルとフォルダー単位のバックアップやシステム状態のバックアップを 取得し Azure 上に保存するバックアップサービスです。

・Microsoft Azure Recovery Services (MARS) エージェントを使用したバックアップのサポート マトリックス
　https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mars-agent


MARS バックアップをお使いの場合、MARS のインストール フォルダ配下をアンチウイルス ソフトのスキャン除外設定にいれてください。
デフォルトでは以下のパスに MARS はインストールが行われます。
> C:\Program Files\Microsoft Azure Recovery Services Agent

もし MARS のインストール時に以下のように "インストール フォルダ" とは異なるフォルダに "キャッシュの場所" を指定していた場合は、指定した "キャッシュの場所" のフォルダもスキャン除外対象に別途ご指定ください。
![MARS インストール画面](https://github.com/jpabrs-scem/blog/assets/141192952/c6390ca3-00d5-413b-af1a-cd1f3dda6c42)

また、上記に加えて MARS のインストール フォルダ配下の以下プロセスもスキャン除外の対象としてご設定ください。
> [Install Path]\bin\cbengine.exe

参考までに弊社検証環境にて Windows Defender で除外設定を行った場合のサンプル イメージを以下に記載いたします。
※ 指定しているフォルダ パスは前述の MARS インストール画面での設定例をベースにしております。
![除外設定例](https://github.com/jpabrs-scem/blog/assets/141192952/0b8cb085-71f5-432c-a10c-5f0ba94c8f3f)
あくまで参考イメージでございますので、実際に指定する除外パスや指定方法については、お客様のご要件あるいはウィルス対策ソフト ベンダーの仕様に依存いたしますことご留意ください。

なお、上記 MARS のウィルス スキャン除外設定は下記の公式ドキュメントにも記載されております。
・Azure Backup でファイルとフォルダーのバックアップが遅い場合のトラブルシューティング - 原因: Azure Backup の妨げになっている別のプロセスまたはウイルス対策ソフトウェア
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-troubleshoot-slow-backup-performance-issue#cause-another-process-or-antivirus-software-interfering-with-azure-backup

