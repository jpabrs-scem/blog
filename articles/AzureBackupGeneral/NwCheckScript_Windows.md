---
title: 疎通確認スクリプトの実行結果について (Windows)
date: 2023-12-12 12:00:00
tags:
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、下記ブログにてご案内している「1. Windows VM における Azure Backup 疎通確認」スクリプトの実行結果について、実行結果の見方・Azure Backup において確認すべきポイントなどをご紹介いたします。

・1. Windows VM における Azure Backup 疎通確認
　https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RequestForInvestigatingNW/#1

> [!NOTE]
> 上記ブログ リンクでご案内している疎通確認スクリプトは、あくまで Azure Backup に関わる通信要件を満たしているかを調査するために、弊社よりご案内・実行いただいているものです。
> 疎通確認スクリプトを実行いただいた後は、専任エンジニアが詳細なトラブルシューティングを行いますので、お問い合わせチケット上へ添付ください。
> マシンの環境によっては本スクリプトでは確認しきれないネットワーク構成もあるため、お問い合わせチケットにて、お客様とどのようなネットワーク通信経路となっているかをすり合わせることとなります。
> 本ブログ記事は、お客様側でご参考までに、疎通確認スクリプトからどのようなことが判断できるのかを説明する記事となります。
> 「tnc」コマンドや「Invoke-webRequest」コマンドの戻り値については、全てを網羅した情報ではなく、Azure Backup 観点にてチェックすべきものをまとめた記事となります。

## 目次
-----------------------------------------------------------
[1. 疎通確認スクリプトの構成](#1)  
[2. プロキシ設定を確認する](#2)  
[3. 疎通確認スクリプト結果を確認する際のポイント](#3)  
[4. tnc コマンド結果について](#4)  
[5. Invoke-webRequest コマンド結果について](#5)
[6. SSL, TLS 設定を確認する](#6)
-----------------------------------------------------------

## <a id="1"></a> 1. 疎通確認スクリプトの構成
はじめに、下記ブログ記事でご案内している疎通確認スクリプト (Check_Backup_NW_verX.X.ps1) の、全体的な構成を説明します。

・1. Windows VM における Azure Backup 疎通確認
　https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RequestForInvestigatingNW/#1

(1) 疎通確認スクリプトを実行したマシン情報の出力
(2) プロキシ設定を確認する
(3) Azure Backup サービスで使用される代表的な FQDN 2 種に対する「tnc」「Invoke-webRequest」コマンド実行結果
(4) Azure Backup 処理時に使用される、代表的な Azure Storage の FQDN 3 種に対する「tnc」「Invoke-webRequest」コマンド実行結果
(5) Azure Backup 処理時に使用される、代表的な Microsoft Entra ID の FQDN 3 種に対する「tnc」「Invoke-webRequest」コマンド実行結果
(6) Azure VM Backup 「ファイルの回復」時に必要な宛先への「tnc」「Invoke-webRequest」コマンド実行結果
(7) SSL, TLS 設定 情報の出力

それでは疎通確認スクリプト結果ログ (AzureBackup_Check_NW_yyyymmdd_hhmmss.log) 上で確認すべきポイントを説明します。

## <a id="2"></a> 2. プロキシ設定を確認する
Windows OS のマシン上で、プロキシ サーバーを経由するよう設定しているかどうかを確認しています。

- WinInet settings for current user (used by ILR but not supported ,not used by Azure SQL / MARS Backup)
 <font color="DodgerBlue">マシン上のカレント ユーザーに対するプロキシ設定が行われているかどうかを確認します</font>
- WinInet settings for NT Authority\System (used by Azure SQL / MARS Backup)
 <font color="DodgerBlue">マシン上のシステム ユーザーに対するプロキシ設定が行われているかどうかを確認します</font>
- WinInet settings for NT Service\AzureWLBackupPluginSv (used by Azure Workload Backup Plugin service)
 <font color="DodgerBlue">「SQL Server DB に対する Azure Workload Backup」や「SAP HANA DB に対する Azure Workload Backup」にて作成・使用される「AzureWLBackupPluginSv」ユーザーに対するプロキシ設定が行われているかどうかを確認します</font>
- ##Check WinHttpProxy
 <font color="DodgerBlue">WinHttp プロキシ設定が行われているかどうかを確認します</font>

下図のように「ProxyEnable」「ProxyServer」「ProxyOverride」箇所が「0」やブランク表示となっていれば「プロキシ設定は行われいない」と判断します。
![](https://github.com/jpabrs-scem/blog/assets/96324317/79f511c3-9e4e-4f46-9365-e3ee0519161e)

下図のように「ProxyEnable: 1」となっていれば、プロキシ設定がされていると判断できます。
「ProxyServer」箇所が経由しているプロキシ サーバーです。
「ProxyOverride」箇所には、プロキシ バイパス設定内容が確認できます。
![](https://github.com/jpabrs-scem/blog/assets/96324317/6d30b9e4-0cfc-4285-b1b7-9de7f07d94b3)

(マシン上の設定例)
![](https://github.com/jpabrs-scem/blog/assets/96324317/26b8cd0a-bdce-45b0-8fb8-35ac66892571)


## <a id="3"></a> 3. 疎通確認スクリプト結果を確認する際のポイント
プロキシ設定情報を出力した後は
Azure Backup 処理時に、シナリオによっては必要となる 下記 3 つの Azure サービスとの通信を「tnc」「Invoke-webRequest」コマンドで確認していきます。
・Azure Backup サービス
・Azure Storage サービス
・Microsoft Entra ID サービス

#### (Point 1) リージョンによって確認すべき FQDN が変わる可能性があります
疎通確認スクリプト上の FQDN (例：pod01-manag1.<font color="DeepPink">jpe</font>.backup.windowsazure.com) はあくまで、Azure Backup サービスで使用される FQDN のうちの 1 つです。
「jpe」と記載されている通り、疎通確認スクリプトでは、例として東日本リージョンで使用されている Azure Backup サービスとの通信を確認しています。
お客様が利用するリージョンによって、通信確立が必要な FQDN は変更されます。
これは Azure Storage サービスにおいても同様です。

(参考) MARSエージェントを使ったバックアップで必要な通信要件
https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mars-agent#url-and-ip-access
また、疎通確認スクリプト上で確認している FQDN は、不定期で変更する場合がございます。

#### (Point 2) 確認している FQDN はパブリックな Azure サービスです
プライベート エンドポイント経由で Azure Backup を利用する場合、
確認すべき Azure Backup ・ Azure Storage サービスの FQDN は、疎通確認スクリプト上で確認しているパブリックな FQDN ではなく、お客様毎にそれぞれ異なる FQDN の通信を確認する必要があります。
この場合は下記ブログ記事に従って、ご確認ください。

(確認方法) 3. プライベート エンドポイント環境における Azure Backup 疎通確認
https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RequestForInvestigatingNW/#3


## <a id="4"></a> 4. tnc コマンド結果について
Result of tnc - 443 / from 10.8.0.6 /To URL  pod01-manag1.jpe.backup.windowsazure.com <font color="DarkTurquoise">IPaddress 20.191.166.134</font> / <font color="DeepPink">TcpTestSucceeded: True</font>

上記のように「TcpTestSucceeded: True」と出力されていれば「pod01-manag1.jpe.backup.windowsazure.com」という Azure Backup で使用される FQDN の 1 つとは、 tnc コマンド (Test-NetConnection コマンド) による通信は確立できていると判断できます。
また、「IPaddress」の後に IP アドレスが出力されていれば、「名前解決はできている」と判断できます。

``nslookup pod01-manag1.jpe.backup.windowsazure.com``
と実行いただければ、「pod01-manag1.jpe.backup.windowsazure.com」の IP アドレスを確認可能です。
![](https://github.com/jpabrs-scem/blog/assets/96324317/80dbbee4-57a2-4160-86a2-ea7c7bb56563)

Result of tnc - 443 / from 10.2.0.23 /To URL  pod01-manag1.jpe.backup.windowsazure.com <font color="DarkTurquoise">IPaddress 20.191.166.134</font> / <font color="DeepPink">TcpTestSucceeded: False</font>

上記のように「TcpTestSucceeded: False」と出力されていれば「pod01-manag1.jpe.backup.windowsazure.com」とは、 tnc コマンドによる通信は確立できていないと判断できます。
いっぽう「IPaddress」の後に IP アドレスが出力されているため「名前解決はできている」と判断できます。

#### (Point 3) プロキシ サーバーを経由するマシンの場合 tnc コマンドだけでは判断できません
弊チームの疎通確認スクリプト上の tnc コマンドでは、プロキシを経由した通信確認を行えないため
プロキシを経由しているマシン上で実行している場合、たとえ「TcpTestSucceeded: True」と出力されていても「プロキシを経由して通信確立できている」とはいえません。
別途「Invoke-webRequest」コマンドにて確認する必要があります。


## <a id="5"></a> 5. Invoke-webRequest コマンド結果について
#TRY!! Invoke-webRequest login.microsoft.com
Result of Invoke-webRequest  / <font color="DeepPink">StatusCode: 200</font>/ StatusDescription: OK

上記のように「StatusCode: 200」と返却されていれば「通信疎通できている」と判断できます。

---
#TRY!! Invoke-webRequest pod01-manag1.jpe.backup.windowsazure.com
PS>TerminatingError(Invoke-WebRequest): <font color="DeepPink">"リモート サーバーがエラーを返しました: (404) 見つかりません"</font>

404 エラー・403 エラーについては、一度「pod01-manag1.jpe.backup.windowsazure.com」とは通信でき、その後「pod01-manag1.jpe.backup.windowsazure.com」からエラーが返却されているので
Azure Backup の通信確認観点では「通信疎通できている」と判断できます。

---
#TRY!! Invoke-webRequest ceuswatcab01.blob.core.windows.net
PS>TerminatingError(Invoke-WebRequest): <font color="DeepPink">"InvalidQueryParameterValueValue for one of the query parameters specified in the request URI is invalid. </font>RequestId:3549fc2a-201e-0069-07eb-0edf28000000 Time:2023-11-04T06:52:24.8125809Zcomp"

「InvalidQueryParameterValueValue」エラーは、一度「ceuswatcab01.blob.core.windows.net」とは通信でき、その後「ceuswatcab01.blob.core.windows.net」からエラーが返却されているので
Azure Backup の通信確認観点では「通信疎通できている」と判断できます。

---
#TRY!! Invoke-webRequest md-dlbrhcw4gn5r.z33.blob.storage.azure.net
PS>TerminatingError(Invoke-WebRequest): <font color="DeepPink">"AuthenticationFailedServer failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature. </font>RequestId:2a4e4e9a-001c-00bc-34eb-0e8bd7000000 Time:2023-11-04T06:52:28.3332912Z"

「AuthenticationFailedServer」エラーは、一度「md-dlbrhcw4gn5r.z33.blob.storage.azure.net」とは通信でき、その後「md-dlbrhcw4gn5r.z33.blob.storage.azure.net」からエラーが返却されているので
Azure Backup の通信確認観点では「通信疎通できている」と判断できます。

---
#TRY!! Invoke-webRequest pod01-manag1.jpe.backup.windowsazure.com
PS>TerminatingError(Invoke-WebRequest): <font color="DeepPink">"Unable to connect to the remote server"</font>

#TRY!! Invoke-webRequest weus2watcab01.blob.core.windows.net
PS>TerminatingError(Invoke-WebRequest): <font color="DeepPink">"リモート サーバーに接続できません。"</font>

上記のように
・Unable to connect to the remote server
・リモート サーバーに接続できません。
が返却された場合、「Invoke-webRequest」コマンドによる該当 FQDN への通信は失敗しており「通信が確立できていない」といえます。

#### (Point 4) Invoke-webRequest コマンドにてプロキシ サーバーを経由した通信の確認が可能
疎通確認スクリプト上の「Invoke-webRequest」コマンドは、「-proxy」引数ありのコマンド実行には*なっておりません*。
スクリプト実行対象のマシン (=バックアップ対象マシン) がプロキシ サーバーを経由するマシンであり「Azure Backup サービスとの通信はプロキシを経由したい」という場合、「-proxy」引数にて、別途コマンドを実行して確認いただく必要がございます。

(コマンド例 Azure Backup サービスとの通信を確認する)
``Invoke-WebRequest https://pod01-manag1.jpe.backup.windowsazure.com -Proxy <プロキシサーバーの URL>:<プロキシ サーバーで使用するポート>``

下図例：
(前段)　「-Proxy」引数無しで実行し、プロキシ サーバーを経由せずに通信確立できていない結果
(後段)　「-Proxy」引数有りで実行し、プロキシ サーバー (10.2.0.16) を経由して (404 エラー返却による) 通信が確立できている結果
![](https://github.com/jpabrs-scem/blog/assets/96324317/35455b53-c66e-4025-9b86-68b49af4d3cb)


## <a id="6"></a> 6. SSL, TLS 設定を確認する
ログ上の後方「TLS CHECK」部分は、SSL/TLS のレジストリキー設定を出力しています。
Azure Backup においては、TLS 1.2 が無効化されているマシンの場合、バックアップ構成・バックアップ処理が失敗する可能性があるため確認しております。

・(参考) TLS 1.2 を有効にしないと、どのような影響がありますか?
　https://learn.microsoft.com/ja-jp/azure/backup/transport-layer-security#what-is-the-impact-of-not-enabling-tls-12

スクリプトでは、マシン上のレジストリキー 
(HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols 配下)
の値を出力しています。

(画面例)
![](https://github.com/jpabrs-scem/blog/assets/96324317/0990e2f3-b319-4da1-96c6-7e6e4834d820)

なお、「TLS 1.2」のレジストリキーが明示的に設定されていなくでも、「Windows Server 2012 R2」以降では TLS 1.2 は規定で有効化されています。

・Azure Backup でのトランスポート層セキュリティ
　https://learn.microsoft.com/ja-jp/azure/backup/transport-layer-security#verify-windows-registry
　"ここに示す値は、Windows Server 2012 R2 以降のバージョンでは既定で設定されています。 これらのバージョンの Windows では、レジストリ キーが存在しない場合、作成する必要はありません。"

Azure Backup の失敗において、TLS 1.2 プロトコルに関わる懸念がある場合は、対象マシン上のその他の設定箇所も確認しながら、トラブルシューティングを進めていくこととなります。

・.NET Framework で TLS 1.1 および TLS 1.2 を有効化する方法 - まとめ - | Japan Developer Support Internet Team Blog (jpdsi.github.io)
　https://jpdsi.github.io/blog/internet-explorer-microsoft-edge/dotnet-framework-tls12/


説明は以上となります。