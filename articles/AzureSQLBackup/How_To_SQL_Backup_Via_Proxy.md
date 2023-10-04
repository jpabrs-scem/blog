---
title: Proxy Server を経由した、SQL Server DB に対する Azure Backup を構成する方法
date: 2023-10-01 12:00:00
tags:
  - Azure SQL Backup
  - how to
disableDisclaimer: false
---

皆様こんにちは、Azure Backup サポートです。
今回は、Proxy Server を経由した、SQL Server DB に対する Azure Backup を構成する方法についてお伝えします。

> [!TIP]
> SQL Server DB に対する Azure Backupを、Proxy Server をバイパスし、PE 経由でバックアップする方法につきましては、以下の記事でご案内しております。
> ---
> ・ SQL Server DB に対する Azure Backupを、Proxy Serverをバイパスして PE 経由でバックアップする場合の設定
> 　 https://jpabrs-scem.github.io/blog/AzureSQLBackup/How_to_PE_SQL_backup_bypass_proxy/

## 目次 - 手順概略
-----------------------------------------------------------
[1. 認証なしの Proxy Server を用意する](#1)  
[2. バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、Local System アカウントに対して、プロキシを設定する](#2)  
[3. 「データベースの検出」「バックアップの有効化」を実施する](#3)  
[4. バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、サービス アカウント ( NT Service\AzureWLBackupPluginSvc ) に対して、プロキシを設定する](#4)  
[5. SQL Server DB に対する Azure Backup「今すぐバックアップ」を実行](#5)  
-----------------------------------------------------------

## <a id="1"></a> 1. 認証なしの Proxy Server を用意する
認証を要求しない Proxy Server をご用意ください。

> [!WARNING]
> 認証付きの Proxy Server はご利用いただけませんので、ご注意ください。


## <a id="2"></a> 2. バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、Local System アカウントに対して、プロキシを設定する

#### Local System アカウントに対するプロキシ設定手順の詳細
1. 以下より PsExec をダウンロードします。​  
    - PsExec v2.2  
      https://docs.microsoft.com/ja-jp/sysinternals/downloads/psexec  

1. 管理者特権のコマンド プロンプトから、ダウンロードしたファイルを解凍したフォルダに移動し、次のコマンドを実行して Internet Explorer を開きます。​  
    - (実行コマンド)  
      ``psexec -i -s "c:\Program Files\Internet Explorer\iexplore.exe"​``

1. 以下の画面が出た場合には、``Agree`` を選択します。  
    ![PsExec License Agreement](https://github.com/jpabrs-scem/blog/assets/124880886/4baf88bf-216c-42ad-aef4-aca75108afb1)

1. Internet Explorer が起動されるため、``[Tools] > [Internet Options] > [Connections] > [LAN settings]``の順に移動します。  
    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/e3f1e1d4-f3eb-41db-a07f-59a7c8e59399" width="400">

1. ``Proxy Server`` 欄の以下項目のチェックを有効化し、Proxy Server の IP およびポート番号を入力します。  
   ``Use a proxy server for your LAN …``
    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/cd475c7f-a266-475d-a76a-47da64b1b7e4" width="400">

1. ``Proxy Server`` 欄の以下項目のチェックを有効化します。  
    ```Bypass proxy server for local addresses```
    > [!NOTE]
    > VM 内の localhost 通信はプロキシから除外します。  

    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/451d67c3-07df-44e0-9521-165773004f78" width="400">

1. ``Proxy Server`` 欄の ``[Advanced]`` を選択します。
    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/3992f893-17fa-4629-bd3d-e87713c61db5" width="400">

1. ``Exceptions`` 欄に、プロキシから除外する IP アドレスおよび FQDN を入力します。  
    Azure VM においては、以下の 3 項目を入力ください。  
    - localhost
    - 168.63.129.16 (Wire Server)
    - 169.254.169.254 (Azure Instance Metadata Service)
    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/cdad2f29-f7aa-4e07-a8c9-0a10b57a2e64" width="400">

1. 各設定を ``OK`` ボタンを押下して保存してください。プロキシ設定は完了です。
    > [!WARNING]
    > バックアップ対象の SQL Server DB が存在する Azure 仮想マシンで、
    > ネットワーク セキュリティ グループや Firewall によって、Proxy Server に対するアウトバウンド通信が制限されていないことを、あらかじめご確認ください。  


## <a id="3"></a> 3. 「データベースの検出」「バックアップの有効化」を実施する
Azure ポータル上から、バックアップ対象の SQL Server DB に対して「データベースの検出」「バックアップの有効化」を行います。  
以下手順に沿って実施してください。  

- SQL Server データベースを検出する  
  コンテナーから複数の SQL Server VM をバックアップする - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#discover-sql-server-databases

- バックアップの構成  
  コンテナーから複数の SQL Server VM をバックアップする - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#configure-backup


## <a id="4"></a> 4. バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、サービス アカウント ( NT Service\AzureWLBackupPluginSvc ) に対して、プロキシを設定する

項目 3 にて実施した「データベースの検出」によって、VM 上にサービス アカウント ( NT Service\AzureWLBackupPluginSvc ) が作成されるため、このサービス アカウントに対してもプロキシ設定を行います。  


> [!NOTE]
> サービス アカウントのプロキシ設定は、サービス アカウントのレジストリ キーを編集することで設定しますが、
> 設定する一部の値の型が "REG_BINARY" となり、バイナリ データを登録する必要がございます。  
> 設定の簡易化のため、本手順では、現在ログインしているユーザー (カレント ユーザー) のプロキシ設定を継承する PowerShell コマンド (スクリプト) を用いて、サービス アカウントのプロキシ設定を行います。  


### サービス アカウント ( NT Service\AzureWLBackupPluginSvc ) に対するプロキシ設定手順の詳細
1. レジストリ エディターを開き、以下パスに遷移し、サービス アカウント ( NT Service\AzureWLBackupPluginSvc ) が作成されていることを確認します。  
   ``HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151``  
   <img src="https://github.com/jpabrs-scem/blog/assets/124880886/66d6c303-da57-403c-a2d6-1db766ff2c03" width="500">

    > [!WARNING]
    > もし上記レジストリ キーが存在していない場合、上記項目 3 の「データベースの検出」「バックアップの有効化」が正常に完了していない可能性がございます。
    > あらためて、「データベースの検出」「バックアップの有効化」操作が成功していることをご確認ください。
1. 現在ログインしているユーザー (カレント ユーザー) で、``[設定] > [ネットワークとインターネット] > [プロキシ]`` を開き、一時的に Proxy Server を設定します。  
   上記項目 2 と同じプロキシ設定を行ってください。  
    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/93c32f74-2bcc-42ee-a57c-8c142d7dfa04" width="500">

1. 下記リンク先から、サービス アカウント ( NT Service\AzureWLBackupPluginSvc ) に対するプロキシを設定するスクリプトをダウンロードします。  
    - [SetProxyforAzureWLBackupPluginSvcfromCurrentUser.zip](https://github.com/jpabrs-scem/blog/files/12788965/SetProxyforAzureWLBackupPluginSvcfromCurrentUser.zip)

1. バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上に、ダウンロードしたスクリプトを配置し、展開します。  
    - ファイルの解凍パスワードは **``AzureBackup``** です

1. 管理者特権の PowerShell から、ダウンロードしたファイルを解凍したフォルダに移動し、次のコマンドを実行します。
    - (実行コマンド)  
      ``.\SetProxyforAzureWLBackupPluginSvcfromCurrentUser.ps1``  
    - スクリプトを実行すると、以下ログファイルが作成されます。  
      ``<スクリプトを実行したフォルダ>/AzureBackup_Set_Proxy_For_AzureWLBackup_PluginSvc_yyyyMMdd_HHmmss.log``

    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/898d1c2e-7c84-48a6-9818-d159883e64ae" width="900">

    > [!WARNING]
    > 本手順でご案内しているスクリプトについては、お客様の責任のもと、ご利用いただきますようお願い申し上げます。  
    > スクリプト実行時のエラーや、想定外の問題について、当社は責任を負いかねますのでご了承ください。
1. 現在ログインしているユーザー (カレント ユーザー) で、``[設定] > [ネットワークとインターネット] > [プロキシ]`` を開き、Proxy Server の設定を元に戻します。

### サービス アカウント ( NT Service\AzureWLBackupPluginSvc ) に対するプロキシ設定の確認手順
1. 以下ドキュメントにある「Azure Backup 接続テスト スクリプト (AzureBackupConnectivityTestScriptsForWindows.zip) 」を対象 Azure 仮想マシン上にダウンロードし、 zip ファイルを展開します。
    - Azure Backup 接続テスト スクリプト  
      コンテナーから複数の SQL Server VM をバックアップする - Azure Backup | Microsoft Learn  
      https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#establish-network-connectivity

1. 展開した zip ファイル内の「Start-ConnectivityTests.ps1」を、対象 Azure 仮想マシン上で実行します。
    - (実行コマンド)  
      ``.\Start-ConnectivityTests.ps1``  

1. 「Start-ConnectivityTests.ps1」を実行した後、ターミナル上に出力された結果に問題が無いことを確認します。
    - 1. ``WinInet settings for NT Authority\System (used by Azure Workload Backup Coordinator service)`` の以下項目の値が、以下のとおりであることを確認します。
        - ProxyEnable : 1
        - ProxyServer : 利用する Proxy Server とそのポート番号
        - ProxyOverride : プロキシから除外した接続先  
          例) ``localhost, 168.63.129.16 (Wire Server), 169.254.169.254 (Azure Instance Metadata Service)``
    - 2. ``WinInet settings for NT Service\AzureWLBackupPluginSvc (used by Azure Workload Backup Plugin service)`` の以下項目の値が、以下のとおりであることを確認します。
        - ProxyEnable : 1
        - ProxyServer : 利用する Proxy Server とそのポート番号
        - ProxyOverride : プロキシから除外した接続先  
          例) ``localhost, 168.63.129.16 (Wire Server), 169.254.169.254 (Azure Instance Metadata Service)``

    <img src="https://github.com/jpabrs-scem/blog/assets/124880886/23248c75-35d3-4453-84f6-dab43917f7d8" width="800">


## <a id="5"></a> 5. SQL Server DB に対する Azure Backup「今すぐバックアップ」を実行
Azure ポータル画面上で設定した、バックアップ ポリシーに従った次回の スケジュールバックアップが成功することを確認いただく、もしくは「今すぐバックアップ」を実行してオンデマンド バックアップが成功することをご確認ください。  

- オンデマンド バックアップを実行する  
  チュートリアル - Azure への SQL Server データベースのバックアップ - Azure Backup | Microsoft Learn  
  https://learn.microsoft.com/ja-jp/azure/backup/tutorial-sql-backup#run-an-on-demand-backup

Proxy Server を経由した、SQL Server DB に対する Azure Backup を構成する方法は以上となります。