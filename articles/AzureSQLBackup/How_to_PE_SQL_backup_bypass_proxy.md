---
title: SQL Server DB に対する Azure Backupを、Proxy Serverをバイパスして PE 経由でバックアップする場合の設定
date: 2022-10-27 12:00:00
tags:
  - Azure SQL Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、SQL Server DB に対する Azure Backupを、Proxy Serverをパイパスして PE 経由でバックアップする場合の設定方法についてお伝えします。

#### ポイント
##### ( ポイントその 1 )
Poxyを経由させてSQL Server DB に対する Azure Backupを行いたい場合は、下記2種類のアカウントに対して、クライアントOS上でProxy設定を行う必要があります。
　１つ目：Local System アカウント
　２つ目：NT Service\AzureWLBackupPluginSvcアカウント

そのため、Proxyは経由せず（＝「Proxyをバイパスする」）、バックアップを取得したい場合は、上記 ２ つのアカウントに対してバイパス設定を行う必要があります。
※もともと２つのアカウントに対してProxy Server 設定を行っていないのであれば、SQL Server DB に対する Azure BackupにおいてProxyを経由してバックアップすることはありません。

上記２つのアカウントに対してProxyを設定している、かつ　Proxy を経由せずに、プライベート エンドポイント（PE）経由でSQL Backupをさせたい場合、下記をバイパスさせる必要があります。
（例外リスト/バイパスリスト）
	　LocalHost 、Wire Server （168.63.129.16）、169.254.169.254、以下ドキュメント記載のAzure Backup、Azure Storage、Azure Active Directory
	
・プライベート エンドポイントを使用して Recovery Services コンテナー用のプロキシ サーバーを設定する
　https://docs.microsoft.com/ja-jp/azure/backup/private-endpoints#set-up-proxy-server-for-recovery-services-vault-with-private-endpoint 

##### ( ポイントその 2 )
本ブログ記事作成時点 (2022/10) では、Azure Active Directory ( =AAD ) はプライベート エンドポイントに対応していませんので、AAD は PE 以外の疎通ルートを確立させる必要があります。

## 目次 - 手順概略
-----------------------------------------------------------
[1. Recovery Services コンテナー上にプライベート エンドポイントを作成](#1)
[2．バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、Local System アカウントに対して、SQL Server DB に対する Azure Backup サービスがバイパスされるよう、設定](#2)
[3. 「データベースの検出」「バックアップの有効化」](#3)
[4. バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、サービスアカウント ( NT Service\AzureWLBackupPluginSvc ) に対して、 SQL Server DB に対する Azure Backup サービスがバイパスされるよう、設定](#4)
[5. SQL Server DB に対する Azure Backup「今すぐバックアップ」を実行](#5)


-----------------------------------------------------------

## <a id="1"></a> 1. Recovery Services コンテナー上にプライベート エンドポイントを作成
こちらは 弊社公開ドキュメントに詳細手順を公開しておりますので、下記をご参考に作成ください。
・Azure Backup のプライベート エンドポイントの作成と使用
　https://docs.microsoft.com/ja-jp/azure/backup/private-endpoints 

## <a id="2"></a> 2．バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、Local System アカウントに対して、SQL Server DB に対する Azure Backup サービスがバイパスされるよう、設定
##### Local System アカウント に対する Proxy Server バイパス設定 手順詳細
以下より PsExec をダウンロードします。​
​　・PsExec v2.2
　　https://docs.microsoft.com/ja-jp/sysinternals/downloads/psexec 

管理者特権のプロンプトから ダウンロードしたファイルを解凍したフォルダに移動し 、次のコマンドを実行して Internet Explorer を開きます。​
（実行コマンド）
  >psexec -i -s "c:\Program Files\Internet Explorer\iexplore.exe"​

Internet Explorer で、[ツール] > [インターネット オプション] > [接続] > [LAN の設定] の順に移動します。​
システム アカウントの Proxy 設定を確認します。 
Proxy の IP アドレスとポートを設定します。​

・下図例では、Proxy Server の IP アドレスが「10.2.0.16」である前提の画面スクリーンショットとなっています。
・下図中央の「Local Area Network (LAN) Settings」ウィンドウ ＞ 「Byspass proxy server for local addresses」チェックボックスを ON とします。
　これは、下記公開ドキュメント「VM 内の localhost 通信のプロキシを無効にします。」と記載している設定に該当しています。
　・トラフィックをルーティングするために HTTP プロキシ サーバーを使用する
　　https://docs.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#use-an-http-proxy-server-to-route-traffic

・下図一番右側の「Proxy Settings」ウィンドウ ＞ 「Exceptions」欄に記入すべきものが、SQL Server DB に対する Azure Backup 実行時 (= Local Sysytem アカウントが利用される際) に、Proxy Server を経由させずに通信したい場合のアドレスを入力する欄です。
　ここに、以下を記入することで、SQL Server DB に対する Azure Backup 実行時はプロキシをバイパスさせることができます。
　LocalHost 、Wire Server （168.63.129.16）、169.254.169.254、上記ドキュメント記載のAzure Backup、Azure Storage、AAD

(実際の入力値)
localhost;168.63.129.16;169.254.169.254;*.backup.windowsazure.com;*.queue.core.windows.net;*.blob.core.windows.net;
*.blob.storage.azure.net;*.msftidentity.com;*.msidentity.com;account.activedirectory.windowsazure.com;
accounts.accesscontrol.windows.net;adminwebservice.microsoftonline.com;api.passwordreset.microsoftonline.com;
autologon.microsoftazuread-sso.com;becws.microsoftonline.com;clientconfig.microsoftonline-p.net;
companymanager.microsoftonline.com;device.login.microsoftonline.com;graph.microsoft.com;graph.windows.net;
login.microsoft.com;login.microsoftonline.com;login.microsoftonline-p.com;login.windows.net;
logincert.microsoftonline.com;loginex.microsoftonline.com;login-us.microsoftonline.com;nexus.microsoftonline-p.com;
passwordreset.microsoftonline.com;provisioningapi.microsoftonline.com;20.190.128.*;40.126.*;*.hip.live.com;
*.microsoftonline.com;*.microsoftonline-p.com;*.msauth.net;*.msauthimages.net;*.msecnd.net;*.msftauth.net;
*.msftauthimages.net;*.phonefactor.net;enterpriseregistration.windows.net;management.azure.com;policykeyservice.dc.ad.msft.net

![](https://user-images.githubusercontent.com/96324317/197693453-7e4e98b9-a52b-4965-bd0a-f5751bfd4c90.png)
	
## <a id="3"></a> 3．「データベースの検出」「バックアップの有効化」
Azure ポータル画面上から、対象の SQL Server DB に対して「データベースの検出」「バックアップの有効化」を行います。

・コンテナーから複数の SQL Server VM をバックアップする - Azure Backup | Microsoft Docs
　https://docs.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#discover-sql-server-databases 

## <a id="4"></a> 4．バックアップ対象の SQL Server DB が存在する Azure 仮想マシン上で、サービスアカウント ( NT Service\AzureWLBackupPluginSvc ) に対して、 SQL Server DB に対する Azure Backup サービスがバイパスされるよう、設定
「バックアップの有効化」が成功後、Azure Backup サービスによって対象マシン上に生成済の「NT Service\AzureWLBackupPluginSvc」アカウントに対する、Proxy Server のバイパス設定を行います。
バイパスリストは  Local Sysytem アカウントに対して設定した内容と同一です。
下記に、「NT Service\AzureWLBackupPluginSvc」アカウントへの設定手順の一例を記載します。
一例としては、カレントユーザーに対して行ったProxy設定を、コマンド実行によって「NT Service\AzureWLBackupPluginSvc」アカウントに対して引き継ぐ手順です。
そのため、一時的にまずはカレントユーザーに対しても、Proxy Server のバイパス設定を行います。

##### (一例) 「NT Service\AzureWLBackupPluginSvc」アカウントに対する Proxy バイパス設定 手順詳細
まずは「NT Service\AzureWLBackupPluginSvc」アカウントが存在しているかを、念のため確認します。
対象マシン上で、スタートボタンを右クリック ＞ ファイル名を指定して実行 ＞ 「regedit」を入力し「OK」をクリックします。
![](https://user-images.githubusercontent.com/96324317/197693696-1df4ae35-e8c8-4afc-b4ff-cf21ab2f912d.png)

![](https://user-images.githubusercontent.com/96324317/197693727-6c4cef17-55b3-4865-be4d-660435ad3b4a.png)

レジストリ エディターが開きますので、以下パスへ遷移します。
（対象パス）
        HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151

上記レジストリキー (フォルダー)「S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151」が、「NT Service\AzureWLBackupPluginSvc」アカウントを表しています。
この時点で存在していない場合、「データベースの検出」「バックアップの有効化」もしくは「再登録」が正常完了していない可能性がありますので、「データベースの検出」「バックアップの有効化」「再登録」が成功しているかどうかを再度確認・再実行願います。
![](https://user-images.githubusercontent.com/96324317/197693875-49891f05-2b67-4040-9641-1f99ca7b271a.png)

レジストリ エディター上でレジストリキー (フォルダー)「S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151」が存在していることを確認出来たら、一時的に カレントユーザーに対して Proxy Server の設定を行います。

・設定内容は、Local System アカウント に対する Proxy Server バイパス設定と同一です
・下図例 では、Proxy Server の IP アドレスが「10.2.0.16」である前提の画面スクリーンショットとなっています。
・下図中央の「Don’t use the proxy server for local (intranet) addresses」チェックボックスを ON とします。
　これは、下記公開ドキュメント「VM 内の localhost 通信のプロキシを無効にします。」と記載している設定に該当しています。
　・トラフィックをルーティングするために HTTP プロキシ サーバーを使用する
　　https://docs.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#use-an-http-proxy-server-to-route-traffic

・下図一番右側 黄色罫線箇所が、Proxy Server を経由させずに通信したい場合のアドレスを入力する欄です。
　ここに、以下を記入することで、SQL Server DB に対する Azure Backup 実行時はプロキシをバイパスさせることができます。
　LocalHost 、Wire Server （168.63.129.16）、169.254.169.254、上記ドキュメント記載のAzure Backup、Azure Storage、AAD

(実際の入力値)
localhost;168.63.129.16;169.254.169.254;*.backup.windowsazure.com;*.queue.core.windows.net;*.blob.core.windows.net;
*.blob.storage.azure.net;*.msftidentity.com;*.msidentity.com;account.activedirectory.windowsazure.com;
accounts.accesscontrol.windows.net;adminwebservice.microsoftonline.com;api.passwordreset.microsoftonline.com;
autologon.microsoftazuread-sso.com;becws.microsoftonline.com;clientconfig.microsoftonline-p.net;
companymanager.microsoftonline.com;device.login.microsoftonline.com;graph.microsoft.com;graph.windows.net;
login.microsoft.com;login.microsoftonline.com;login.microsoftonline-p.com;login.windows.net;
logincert.microsoftonline.com;loginex.microsoftonline.com;login-us.microsoftonline.com;nexus.microsoftonline-p.com;
passwordreset.microsoftonline.com;provisioningapi.microsoftonline.com;20.190.128.*;40.126.*;*.hip.live.com;
*.microsoftonline.com;*.microsoftonline-p.com;*.msauth.net;*.msauthimages.net;*.msecnd.net;*.msftauth.net;
*.msftauthimages.net;*.phonefactor.net;enterpriseregistration.windows.net;management.azure.com;policykeyservice.dc.ad.msft.net

![](https://user-images.githubusercontent.com/96324317/197693971-4fcf367e-2685-4284-b0f4-4e8c0c457e38.png)

カレントユーザーに対して、Proxy Server のバイパス設定を保存した後に、PowerShell を立ち上げ、以下コマンドを実行します。
下記コマンドを実行することで、カレントユーザーに対して行った設定が、「NT Service\AzureWLBackupPluginSvc」アカウントへ引き継がれます。

（実行コマンド）
  >$obj = Get-ItemProperty -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"
  >Set-ItemProperty -Path Registry::"HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" -Name DefaultConnectionSettings -Value $obj.DefaultConnectionSettings
  >Set-ItemProperty -Path Registry::"HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" -Name SavedLegacySettings -Value $obj.SavedLegacySettings
  >$obj = Get-ItemProperty -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"  
  >Set-ItemProperty -Path Registry::"HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value $obj.ProxyEnable
  >Set-ItemProperty -Path Registry::"HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name Proxyserver -Value $obj.Proxyserver
  >Set-ItemProperty -Path Registry::"HKEY_USERS\S-1-5-80-1631947889-4033244730-3205203906-53534054-4184208151\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyOverride -Value $obj.ProxyOverride

![](https://user-images.githubusercontent.com/96324317/197694217-0ac20679-c842-419b-a6f4-a68bf609eccb.png)

上記コマンド実行後、カレントユーザーに対する Proxy Server 設定を、元の状態に戻します。
念のため、以下スクリプトを実行いただき、Local System アカウントとNT Service\AzureWLBackupPluginSvcアカウントに対して、Proxy Server バイパス設定が正しく設定されているかを確認します。

##### １．下記ドキュメント上の「Azure Backup 接続テスト スクリプト (AzureBackupConnectivityTestScriptsForWindows.zip) 」を対象 Azure 仮想マシン上にダウンロードし、 zip ファイルを展開します。
・ネットワーク接続を確立する
　https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-database-azure-vms#establish-network-connectivity

##### ２．展開した zip ファイル内の「Start-ConnectivityTests.ps1」を、対象 Azure 仮想マシン上で実行します。
今回は、Azure Backup サービスと Azure Storage サービスに対しては、プライベート エンドポイント経由で通信するため、引数に「-IsPrivateEndpointEnabled」を追加して実行します。
（実行コマンド 例）
  >.\Start-ConnectivityTests.ps1 -IsPrivateEndpointEnabled

![](https://user-images.githubusercontent.com/96324317/197697047-3663b672-184f-499b-b405-e95770135b27.png)

![](https://user-images.githubusercontent.com/96324317/197704009-4d226d75-3057-4439-88ae-b2a42af0f7e5.png)

「Start-ConnectivityTests.ps1」スクリプトを実行後、ターミナル上に結果が返却されます。

##### 「Start-ConnectivityTests.ps1」実行結果の期待値
（１）
WinInet settings for NT Authority\System (used by Azure Workload Backup Coordinator service)
ProxyEnable: <span style="color: red; ">1</span>
となっていること。(=プロキシ設定 ON を表す)

（２）
WinInet settings for NT Authority\System (used by Azure Workload Backup Coordinator service)
「ProxyOverride:」以降が、設定した例外リスト/バイパスリストの内容となっていること

（３）
WinInet settings for NT Service\AzureWLBackupPluginSvc (used by Azure Workload Backup Plugin service)
ProxyEnable: <span style="color: red; ">1</span>
となっていること。(=プロキシ設定 ON を表す)

（４）
WinInet settings for NT Service\AzureWLBackupPluginSv (used by Azure Workload Backup Plugin service)
「ProxyOverride:」以降が、設定した例外リスト/バイパスリストの内容となっていること
![](https://user-images.githubusercontent.com/96324317/197704402-d3ac2ec2-6778-4bfa-bf48-356c975f8d4a.png)

## <a id="5"></a> 5．SQL Server DB に対する Azure Backup「今すぐバックアップ」を実行
Azure ポータル画面上で設定した、バックアップ ポリシーに従った次回の スケジュールバックアップが成功することを確認いただく、もしくは「今すぐバックアップ」を実行してオンデマンド バックアップが成功することをご確認ください。

・オンデマンド バックアップを実行する
　https://docs.microsoft.com/ja-jp/azure/backup/tutorial-sql-backup#run-an-on-demand-backup

SQL Server DB に対する Azure Backupを、Proxy Serverをパイパスして PE 経由でバックアップする場合の設定方法は以上となります。