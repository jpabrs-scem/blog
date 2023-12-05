---
title: 疎通確認スクリプトの実行結果について (Linux)
date: 2023-12-12 12:00:00
tags:
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、下記ブログにてご案内している「2. Linux VM における Azure Backup 疎通確認」スクリプトの実行結果について、実行結果の見方・Azure Backup において確認にすべきポイントなどをご紹介いたします。

・2. Linux VM における Azure Backup 疎通確認
　https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RequestForInvestigatingNW/#2

> [!NOTE]
> 上記ブログ リンクでご案内している疎通確認スクリプトは、あくまで Azure Backup に関わる通信要件を満たしているかを調査するために、弊社よりご案内・実行いただいているものです。
> 疎通確認スクリプトを実行いただいた後は、専任エンジニアが詳細なトラブルシューティングを行いますので、お問い合わせチケット上へ添付ください。
> マシンの環境によっては本スクリプトでは確認しきれないネットワーク構成もあるため、お問い合わせチケットにて、お客様とどのようなネットワーク通信経路となっているかをすり合わせることとなります。
> 本ブログ記事は、お客様側でご参考までに、疎通確認スクリプトからどのようなことが判断できるのかを説明する記事となります。
> 「nc」コマンドや「curl」コマンドの戻り値については、全てを網羅した情報ではなく、Azure Backup 観点にてチェックすべきものをまとめた記事となります。

## 目次
-----------------------------------------------------------
[1. 疎通確認スクリプトの構成](#1)  
[2. プロキシ設定を確認する](#2)  
[3. 疎通確認スクリプト結果を確認する際のポイント](#3)  
[4. nslookup コマンド結果について](#4)  
[5. nc コマンド結果について](#5)
[6. curl コマンド結果について](#6)
-----------------------------------------------------------

## <a id="1"></a> 1. 疎通確認スクリプトの構成
はじめに、下記ブログ記事でご案内している疎通確認スクリプト (Check_Backup_NW_Linux_verX.X.sh) の、全体的な構成を説明します。

・2. Linux VM における Azure Backup 疎通確認
　https://jpabrs-scem.github.io/blog/AzureBackupGeneral/RequestForInvestigatingNW/#2

(1) 疎通確認スクリプトを実行したマシン情報の出力
(2) プロキシ設定を確認する
(3) Azure VM Backup 「ファイルの回復」時に必要な宛先への「nslookup」「nc」コマンド実行結果
(4) Azure Backup サービスで使用される代表的な FQDN に対する「nslookup」「nc」「curl」コマンド実行結果
(5) Azure Backup 処理時に使用される、代表的な Azure Storage の FQDN に対する「nslookup」「nc」「curl」コマンド実行結果
(6) Azure Backup 処理時に使用される、代表的な Microsoft Entra ID の FQDN に対する「nslookup」「nc」「curl」コマンド実行結果

それでは疎通確認スクリプト結果ログ (CheckNWResult_(ホスト名)_(YYYYMMDDHHMM).log) 上で確認すべきポイントを説明します。

## <a id="2"></a> 2. プロキシ設定を確認する
Linux OS のマシン上で、プロキシ サーバーを経由するよう設定しているかどうかを確認しています。
下図のように、空白行の場合は「http_proxy」「https_proxy」のプロキシ設定は無いと判断します。
![](https://github.com/jpabrs-scem/blog/assets/96324317/9f9b597d-6a5f-4180-9d8e-141d11eb5e34)

いっぽう 下図のように出力されている場合は、プロキシ設定を行っていると判断します。
![](https://github.com/jpabrs-scem/blog/assets/96324317/f4a0cdbc-8d19-497e-93cd-3d5872f68534)

## <a id="3"></a> 3. 疎通確認スクリプト結果を確認する際のポイント
プロキシ設定情報を出力した後は
Azure Backup 処理時に、シナリオによっては必要となる 下記 3 つの Azure サービスとの通信を、おもに「nslookup」「nc」「curl」コマンドで確認していきます。
・Azure Backup サービス
・Azure Storage サービス
・Microsoft Entra ID サービス

#### (Point 1) リージョンによって確認すべき FQDN が変わる可能性があります
疎通確認スクリプト上の FQDN (例：pod01-rec2.<font color="DeepPink">jpw</font>.backup.windowsazure.com) はあくまで、Azure Backup サービスで使用される FQDN のうちの 1 つです。
「jpw」と記載されている通り、疎通確認スクリプトでは、例として西日本リージョンや東日本リージョンで使用されている Azure Backup サービスとの通信を確認しています。
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


## <a id="4"></a> 4. nslookup コマンド結果について
##TRY!! nslookup  pod01-rec2.jpe.backup.windowsazure.com ##
Server:		168.63.129.16
Address:	168.63.129.16#53

Non-authoritative answer:
pod01-rec2.jpe.backup.windowsazure.com	canonical name = jpe-pod01-rec2-s2j8q.ext.trafficmanager.net.
jpe-pod01-rec2-s2j8q.ext.trafficmanager.net	canonical name = jpe-pod01-rec-01.japaneast.cloudapp.azure.com.
Name:	jpe-pod01-rec-01.japaneast.cloudapp.azure.com
<font color="DeepPink">Address: 20.191.166.150</font>

上記のように 末尾「Address」欄に IP アドレスが表示されていれば「pod01-rec2.jpe.backup.windowsazure.com」という Azure Backup で使用される FQDN の 1 つとは、 nslookup コマンドによる「名前解決はできている」と判断できます。

##TRY!! nslookup  pod01-rec2.jpe.backup.windowsazure.com ##
;; connection timed out; no servers could be reached

上記「connection timed out」のような出力の場合、名前解決できていないことが懸念されるため、お客様にてマシン上の名前解決手段を確認いただくことがございます。

## <a id="5"></a> 5. nc コマンド結果について
##TRY!! nc -vz pod01-manag1.jpe.backup.windowsazure.com 443 ##
Ncat: Version 7.50 ( https://nmap.org/ncat )
Ncat: <font color="DeepPink">Connected to </font>20.191.166.134:443.
Ncat: 0 bytes sent, 0 bytes received in 0.06 seconds.

上記のように 「Connected to <宛先の IP アドレス>」が表示されていれば対象のアドレスと nc コマンドによる通信は確立できていると判断できます。

##TRY!! nc -vz pod01-rec2.jpe.backup.windowsazure.com 3260 ##
Ncat: Version 7.50 ( https://nmap.org/ncat )
Ncat: <font color="DeepPink">Connection timed out.</font>

##TRY!! nc -vz pod01-prot1.jpe.backup.windowsazure.com 443 ##
nc: connect to pod01-prot1.jpe.backup.windowsazure.com port 443 <font color="DeepPink">(tcp) failed: Connection timed out</font>

上記のように「failed」「Connection timed out.」と出力されている場合、 nc コマンドによる通信は確立できていないと判断できます。

#### (Point 3) プロキシ サーバーを経由するマシンの場合 nc コマンドだけでは判断できません
弊チームの疎通確認スクリプト上の nc コマンドでは、プロキシを経由した通信確認を行えないため
プロキシを経由しているマシン上で実行している場合、たとえ「Connected to <宛先の IP アドレス>」と出力されていても「プロキシを経由して通信確立できている」とはいえません。
別途「curl」コマンドにて確認する必要があります。

## <a id="6"></a> 6. curl コマンド結果について
##TRY!! curl -I https://login.microsoft.com ##
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0 20001    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 <font color="DeepPink">200 OK</font>

上記のように「200 OK」と返却されていれば「通信疎通できている」と判断できます。

##TRY!! curl -I https://ceuswatcab01.blob.core.windows.net ##
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 <font color="DeepPink">400 Value for one of the query parameters specified in the request URI is invalid.</font>

##TRY!! curl -I https://md-dlbrhcw4gn5r.z33.blob.storage.azure.net ##
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
HTTP/1.1 <font color="DeepPink">403 Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.</font>

##TRY!! curl -I https://pod01-manag1.jpe.backup.windowsazure.com ##
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 <font color="DeepPink">404 Not Found</font>

400・403・404 エラーについては、一度対象の宛先とは通信でき、その後 対象の宛先からエラーが返却されているので
Azure Backup の通信確認観点では「通信疎通できている」と判断できます。

##TRY!! curl -I https://pod01-manag1.jpe.backup.windowsazure.com ##
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  (中略)
  0     0    0     0    0     0      0      0 --:--:--  0:02:11 --:--:--     0
curl: (7) <font color="DeepPink">Failed to connect to pod01-manag1.jpe.backup.windowsazure.com port 443: Connection timed out</font>

##TRY!! curl -I https://loginex.microsoftonline.com ##
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  （中略）
  0     0    0     0    0     0      0      0 --:--:--  0:05:00 --:--:--     0
curl: (28) <font color="DeepPink">Connection timed out </font>after 300001 milliseconds

上記のように「Failed to connect」や「Connection timed out」と出力されている場合、 curl コマンドによる通信は確立できていないと判断できます。



説明は以上となります。