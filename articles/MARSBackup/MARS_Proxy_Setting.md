---
title: プロキシを利用した MARS エージェントによるバックアップについて
date: 2022-02-09 12:00:00
tags:
  - MARS Backup 
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートの荘司です。
今回は、**プロキシを利用した MARS  エージェントによるバックアップの設定例及び挙動**について、認証が必要な場合や pac ファイルをご利用の場合も含めてご案内します。

MARS エージェント によるバックアップはマシン内のファイルやフォルダーやシステム状態のバックアップを行い Azure 上に保存するバックアップサービスです。
対象のバックアップ環境はオンプレミスでも Azure でも可能です。

- 参考
・Microsoft Azure Recovery Services (MARS) エージェントを使用したバックアップのサポート マトリックス
 https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mars-agent



## 目次
-----------------------------------------------------------
[1. MARS エージェントのプロパティ設定を利用したプロキシ設定例](#1)
[2. Windows のシステムアカウントプロキシ設定を利用した設定例](#2)
[3. 認証プロキシを利用する際の設定例](#3)
[4. PAC ファイルを利用したプロキシ設定を適用する場合の設定例](#4)
[5. MARS Backup と Windows (システムアカウント) の両方にプロキシ設定がある場合の挙動](#5)
[6. まとめ](#6)
-----------------------------------------------------------

## 1. MARS エージェントのプロパティ設定を利用したプロキシ設定例<a id="1"></a>
本設定に関連した公式ドキュメントは下記でございます。
- 参考
・Azure Backup MARS エージェントをインストールする - エージェントをインストールして登録する
　https://docs.microsoft.com/ja-jp/azure/backup/install-mars-agent#install-and-register-the-agent

MARS のインストール時の下記プロキシ設定に、プロキシ サーバーの IP アドレス及びポートを記入することで、プロキシを利用したバックアップが可能です。

![MARS_Proxy_01](https://user-images.githubusercontent.com/71251920/152903682-258c22e6-793d-4c62-82d4-20f293c8d330.png)


* MARS Backup エージェントのプロキシ設定では PAC ファイルによるプロキシの設定はできません。後述のシステムアカウントを用いたプロキシ設定により可能です。

## 2. Windows のシステムアカウントプロキシ設定を利用した設定例 <a id="2"></a>
本設定に関連した公式ドキュメントは下記でございます。
- 参考
・Windows のプロキシ設定を確認する
　https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-mars-troubleshoot#verifying-proxy-settings-for-windows

MARS エージェントが参照する Windows のプロキシ設定はシステムアカウントにて設定する必要がございます。
PsExec を用いることにより、設定可能でございます。
下記手順は PsExec にて Windows のプロキシ設定する手順をご紹介しております。

1. 下記 URL より PsExec をダウンロードします。
・PsExec - Windows Sysinternals | Microsoft Docs
　https://docs.microsoft.com/ja-jp/sysinternals/downloads/psexec

2. コマンドプロンプトを開き、PsExec のあるフォルダまで移動した後、以下コマンドを実行します。
psexec -i -s "c:\Program Files\Internet Explorer\iexplore.exe"

3. 以下画面が出た場合は Agree をクリックしてください。
![MARS_Proxy_02](https://user-images.githubusercontent.com/71251920/152903684-37a1b7d4-8e85-4e6a-92df-7f5cb0faba7a.png)

4. Internet Explorerが起動されますので、[ツール] > [インターネット オプション] > [接続] > [ LAN の設定] より、プロキシサーバーの IP アドレス及びポートを記入します。
![MARS_Proxy_03](https://user-images.githubusercontent.com/71251920/152903686-eadf5857-01e8-40fa-89a6-6d8337c4be12.png)

5. Windows のプロキシ設定がされている場合、MARS インストール時にプロキシ設定をしなくても、プロキシを利用したバックアップが可能です。

## 3. 認証プロキシを利用する際の設定例 <a id="3"></a>
MARS のインストール時に下記プロキシ設定に、プロキシサーバーの IP アドレス及びポート、認証の際のユーザーネーム、パスワードを記入することで、認証プロキシを利用したバックアップが可能です。
*[2. の Windows のシステムアカウントプロキシ設定](#2)だけでは認証が通らないため、認証プロキシの設定はできません。
![MARS_Proxy_04](https://user-images.githubusercontent.com/71251920/152904399-0e4149d2-2911-4516-bcdd-938ea9fbaa0c.png)



## 4. PAC ファイルを利用したプロキシ設定を適用する場合の設定例 <a id="4"></a>
1.  [2. の Windows のシステムアカウントプロキシ設定](#2)の 1 から 3 の手順によって Internet Explorer を起動します。

2. [ツール] > [インターネット オプション] > [接続] > [ LAN の設定] より、PAC ファイルの URL を記入することで、PAC ファイルの設定によるプロキシを利用したバックアップが可能です。
![MARS_Proxy_05](https://user-images.githubusercontent.com/71251920/152903691-9d2000f4-2f9f-4748-b2e1-442de641449e.png)


## 5.  MARS Backup と Windows (システムアカウント) の両方にプロキシ設定がある場合の挙動 <a id="5"></a>
MARS Backup エージェントのプロパティと Windows の両方にプロキシの設定がされている場合は、MARS Backup エージェントに設定されている内容が優先されます。

## 6.  まとめ <a id="6"></a>
各シナリオと設定例、及び優先される設定を以下の表にまとめますので、プロキシ設定の際のご参考にしていただければ幸いです。
 ①MARSのプロキシ設定とは[1. MARS エージェントのプロパティ設定を利用したプロキシ設定例](#1)です。
 ②Windows のプロキシ設定とは[2. Windows のシステムアカウントプロキシ設定](#2)です。
![MARS_Proxy_06](https://user-images.githubusercontent.com/71251920/152903692-27e268c0-7e89-44a4-ab36-1430047dde2e.png)
① はプロキシサーバーの IP アドレス、プロキシサーバーのポート、認証プロキシのユーザーネーム、認証プロキシのユーザーのパスワードを設定可能
② はプロキシサーバーの IP アドレス、プロキシサーバーのポート又は PAC ファイルの URL 設定を設定可能