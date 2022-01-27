---
title: SCOM エージェントの入れ替え作業の失敗事例
date: 2022-01-28 12:00:00
tags:
  - System Center
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、System Center サポートチームの 佐藤 です。

本日は System Center Operations Manager（以後 SCOM）  のエージェントの入れ替え作業の失敗事例をご紹介いたします。
2022 年 1 月現在の状況として、（[SCOM 2012 R2の延長サポートのフェーズが2022年7月に終了](https://docs.microsoft.com/ja-jp/lifecycle/products/microsoft-system-center-2012-r2-operations-manager)）することに伴い、SCOM 2016や2019 など後継バージョンの環境を新規構築して移行を進めている、もしくはご計画されているお客様もいるかと存じます。

その際、監視対象コンピューターにて SCOM 2012 R2 のエージェントのアンインストールを行い、SCOM 2016 や 2019 のエージェントをインストールすることになりますが、アンインストール時に想定通り削除が出来ず、SCOM 2012 R2 向けのレジストリ設定やフォルダが残存してしまい SCOM エージェントをインストールする際に失敗する事例が発生しております。

## Error Message
具体的にはプッシュインストール時には下記のようなインストール失敗メッセージが出力されます
-----------------------------メッセージ内容------------------------------------------------------------
リモート コンピューター <<コンピューターFQDN>> のエージェント管理オペレーションは エージェントのインストール に失敗しました。 
インストール アカウント: XXX 
エラー コード: 80070643 
エラーの説明: インストール中に致命的なエラーが発生しました。 
Microsoft インストーラーのエラーの説明: 
詳細については、管理サーバーの Windows インストーラーのログ ファイル "C:\Program Files\Microsoft System Center 2016\Operations Manager\Server\AgentManagement\AgentLogs\xxxAgentInstall.LOG 
C:\Program Files\Microsoft System Center 2016\Operations Manager\Server\AgentManagement\AgentLogs\XXXMOMAgentMgmt.log" を参照してください。 
-----------------------------メッセージ内容------------------------------------------------------------

## 対処策
当事象が発生した際には
下記に記載するフォルダとレジストリを確認いただき、残存している場合は削除いただきますようお願いします。
 
※下記 2 つの値は環境によりで異なっております。
> D996D247BE65CC940AA413D70EF113DC
> 742D699D-56EB-49CC-A04A-317DE01F31CD
 
以下のように確認いただき、お客様環境の文字列に読み替えをお願いします。
 
・D996D247BE65CC940AA413D70EF113DC
パス「HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products」において
下図のように [InstallProperties] の [DisplayName] が “Microsoft Monitoring Agent”となっている箇所の フォルダ名
 
下図の確認結果として ”D996D247BE65CC940AA413D70EF113DC” を ”5C0796876F6E14A42B83EA524D9BE1AE” に読み替えます。
![SCOM_agent_failures_01](https://user-images.githubusercontent.com/71251920/151289630-3ed34906-47a7-467f-ac70-4bf269148ce7.gif)


・742D699D-56EB-49CC-A04A-317DE01F31CD
パス「HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\」において
下図のように [DisplayName] が “Microsoft Monitoring Agent”となっている箇所の フォルダ名
 
下図の確認結果として ”742D699D-56EB-49CC-A04A-317DE01F31CD” を”786970C5-E6F6-4A41-B238-AE25D4B91EEA” に読み替えます。
![SCOM_agent_failures_02](https://user-images.githubusercontent.com/71251920/151289631-00aa5d7c-8b20-4bf3-baca-4baefd861d66.gif)




### 削除対象のレジストリ
・全てフォルダとなります。keyではございません。
・2行目の[XXXX\C96403E8AD6025B4F9E1FE9C574E34AE]は固定文字列のフォルダとなります。

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\D996D247BE65CC940AA413D70EF113DC
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UpgradeCodes\C96403E8AD6025B4F9E1FE9C574E34AE
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\D9960A263C3B3F948AE9C9793043B7C9
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{742D699D-56EB-49CC-A04A-317DE01F31CD}
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\System Center
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\System Center Operations Manager
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Operations Manager
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\D996D247BE65CC940AA413D70EF113DC
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Features\D996D247BE65CC940AA413D70EF113DC
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\UpgradeCodes\C96403E8AD6025B4F9E1FE9C574E34AE
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\MOMConnector
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\HealthService
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\System Center Management APM

###  削除対象のフォルダ
C:\Windows\Installer\{742D699D-56EB-49CC-A04A-317DE01F31CD}
C:\Program Files\Common Files\Microsoft Shared\Operations Manager
 
上記レジストリ及びフォルダの確認、削除が完了しましたらここで OS の再起動をお願いします。


確認および削除手順は以上となります。新規エージェントをインストールする際に失敗する事象が発生した際は、ぜひ一度上記確認をお願いいたします。
