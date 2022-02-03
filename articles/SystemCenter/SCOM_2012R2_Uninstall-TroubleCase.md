---
title: SCOM 2012 R2 エージェントのアンインストール時のトラブル事例
date: 2022-02-04 12:00:00
tags:
  - System Center
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、System Center サポートチームの 佐藤 です。

本日は System Center Operations Manager（以後 SCOM）のエージェントの入れ替え作業の失敗事例をご紹介いたします。
2022 年 1 月現在の状況として、（[SCOM 2012 R2の延長サポートのフェーズが2022年7月に終了](https://docs.microsoft.com/ja-jp/lifecycle/products/microsoft-system-center-2012-r2-operations-manager)）することに伴い、SCOM 2016や2019 など後継バージョンの環境を新規構築して移行を進めている、もしくはご計画されているお客様もいるかと存じます。


その際、監視対象コンピューターにて **SCOM 2012 R2 のエージェントのアンインストールを行う事となりますが、アンインストール時に想定外に発生したトラブル事例**についてご紹介いたします。

アンインストールした際には下記パスのように SCOM エージェント専用のフォルダやフォルダ配下のファイルが削除されるのは当然ですが、その他に別ソフトウェアでも使用するファイルが配置しているフォルダにある SCOM エージェント で使用するファイルも削除する対象となります。

例）
>SCOM エージェント専用のフォルダの例
>　C:\Program Files\Microsoft Monitoring Agent\Agent
>別ソフトウェアでも使用するファイルが配置しているフォルダの例
>　C:\Windows\System32

上記例に記載しているフォルダ「C:\Windows\System32」からは以下ファイルが削除対象となります。
　AcsMsgs.dll
　AdtAgent.exe
　InterceptCounters.dll
　msvcp100.dll
　msvcr100.dll

通常他ソフトウェアで上記ファイルを使用している場合は Windows のレジストリの設定値（複数のプログラムで使用しているため、アンインストールしない設定）によりアンインストール時に削除されないようになっているはずが、その設定がされておらず想定外にファイル msvcp100.dll が削除される事例がございました。

### ■レジストリ設定個所
　HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDLLs

当事象は基本発生しないはずですが、万一発生してしまった場合は削除されたファイルを再度インストールする事で基本は復旧いたします。
必要なファイルについては各ソフトウェア次第でございますので、ここでのご説明は省略させていただきますが、上記ファイル msvcp100.dll の例でしたら
当ファイル含むランタイム一式を下記サイトから取得いただき、再度インストールいただく事で復旧いたしました。
x86 と x64 については、今回消失してしまったモジュールにあわせて選択していただく必要がありますのでご留意ください。
https://www.microsoft.com/ja-jp/download/details.aspx?id=26999 


