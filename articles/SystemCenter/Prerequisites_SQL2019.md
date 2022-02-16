---
title: 一部の System Center 2019 で SQL Server 2019 を使用する際の前提条件
date: 2022-02-16 12:00:00
tags:
  - System Center
  - SCOM
  - SCSM
disableDisclaimer: false
---

<!-- more -->
皆さんこんにちは、System Center サポートチームの 保科と申します。


2022 年 2 月 16 日現在、System Center 2012 の延長サポートが終了間近であったり、System Center 2016 のメインストリームサポートが終了となります。
これに伴い、System Center 2019 へのアップグレードや新規環境構築を検討されているお客様も多くいらっしゃるかと思います。
System Center 2019 で使用するデータベースでは、SQL Server 2019 の使用がサポートされております。
本記事では、一部の System Center 2019 で SQL Server 2019 を使用する際の注意点について説明いたします。

### 本記事が対象とする System Center 製品
> ・System Center Operations Manager (SCOM) 2019
> ・System Center Service Manager (SCSM) 2019

### 概要
冒頭でもお伝えしました通り、System Center 2019 では SQL Server 2019 の利用がサポートされております。
一方で、本記事が対象としている System Center 製品においては、インストール直後の SQL Server 2019 にデータベースを構成するようにインストールを行うと、インストールに失敗する場合があります。
これは、**対象の System Center 2019 製品では、SQL Server 2019 に加えて、SQL Server 2019 CU8 以上の適用が必要となるため**です。
CU8 以上の適用はインストール時に表示される前提条件では確認できず、インストール開始まで進めることが可能です。
この際、CU8 以上が適用されていないため内部的にエラーが発生し、System Center 2019 のインストールが失敗します。
こちらは、各 System Center 2019 でサポートされる構成が掲載された弊社公開情報にも CU8 以上の適用が必須なことが明記されております。
・SCOM 2019 における SQL Server 2019 CU8 以上の適用が必要な旨記載された弊社公開情報:
https://docs.microsoft.com/ja-jp/system-center/scom/plan-sqlserver-design?view=sc-om-2019
("SQL Server の要件" 項を参照ください。)
・SCSM 2019 における SQL Server 2019 CU8 以上の適用が必要な旨記載された弊社公開情報:
https://docs.microsoft.com/ja-jp/system-center/scsm/system-requirements?view=sc-sm-2019
("SQL Server の要件" 項を参照ください。)

なお、System Center Virtual Machine Manager (SCVMM) 2019 および System Center Orchestrator (SCORCH) 2019、System Center Data Protection Manager (SCDPM) においては、SCOM 2019 および SCSM 2019 と同様に SQL Server 2019 の使用がサポートされております。
一方で、これらの System Center 2019 製品では CU8 以上のアップデートが SQL Server 2019 での適用が必須と明記されておりません。
また、実際に CU8 以上が適用されていない状態でもインストールに成功することを弊社検証環境において確認しております。

### 対処方法
SQL Server 2019 を対象となる System Center 2019 製品で使用する場合、SQL Server 2019 に CU8 以上の適用が必要となります。
各 SQL Server のバージョンで提供されている最新の CU アップデートは下記の弊社公開情報から参照いただけます。
- アプリケーションとそのコンポーネントのバージョン、エディション、および更新SQL Server決定する
https://docs.microsoft.com/ja-jp/troubleshoot/sql/general/determine-version-edition-update-level

SQL Server 2019 の最新版の CU アップデートを入手される場合、こちらの公開情報より "現在サポートされているバージョンの更新プログラムで利用可能な最新SQL Server" 項の表を参照します。
"バージョン" 列が "SQL Server 2019" と記載された行の "最新の累積的な更新プログラム" より、"CU **xx** for 2019" と書かれた文字をクリックすることで、対象の CU アップデートの内容およびダウンロード先が掲載された弊社サイトが開かれます。
( **xx** には、CU アップデートの数値が記載されております。
2022 年 2 月 16 日現在、こちらは "CU15 for 2019" と記載されております。)
開かれたサイトより最新版の CU アップデートをダウンロードいただけるリンクをクリックし、アップデートファイルを入手します。
そのアップデートファイルを System Center 2019 製品で使用する SQL Server 上で適用することでアップデートが完了します。
アップデート後、System Center 2019 のインストールが行えるかご確認ください。
