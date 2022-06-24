---
title: Azure Backup の障害調査に必要な情報 (疎通確認)
date: 2022-06-24 12:00:00
tags:
  - Recovery Services vaults
  - 情報採取
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure Backup のバックアップ失敗、リストア失敗の時の調査をするにあたり、NW 観点で提供いただきたい情報をお伝えいたします。
NW 観点以外の情報採集提供依頼については下記をご覧ください
・Azure Backup の障害調査に必要な情報
https://jpabrs-scem.github.io/blog/RecoveryServicesVaults/RequestForInvestigating/

## 目次
-----------------------------------------------------------
[1. Windows VM における Azure Backup 疎通確認](#1)
[2. Linux VM における Azure Backup 疎通確認(作成中)](#2)
-----------------------------------------------------------


## 1.Windows VM における Azure Backup 疎通確認<a id="1"></a>
まず、下記 リンク先から疎通確認スクリプトのダウンロードをお願いします。
[Check_Backup_NW_ver1.4.zip](https://github.com/jpabrs-scem/blog/files/8975919/Check_Backup_NW_ver1.4.zip)
 

(スクリプト実行手順)
1. 疎通確認スクリプトをダウンロードし、展開してください。
※ ファイルの解凍パスワードは **“AzureBackup”** となります。
 
2. PowerShell を右クリックし、管理者として実行をクリックしてください。

 ![](https://user-images.githubusercontent.com/71251920/175529513-5196c393-be7b-439e-aba3-063969d1ce26.png)

3. PowerShell にて手順 1 で展開したスクリプトの場所に移動してください。
例 ) "Takato" というユーザーのデスクトップ上の PowerShell というフォルダ内にスクリプトをダウンロードしたときの移動コマンド
>cd C:\Users\Takato\Desktop\powershell
 
4. 以下コマンドを実行し、スクリプトを実行してください。
(現在画像とバージョンが異なりますが、同様の手順でございます。)
>.\Check_Backup_NW_ver1.4.ps1

![](https://user-images.githubusercontent.com/71251920/175529518-afd3ab91-e450-42b9-b7b6-310c6633cca1.png)
* 上記スクリプト実施時に実行ポリシーの制限によりスクリプトが実行できない場合はPowerShell を管理者権限で起動し、下記コマンドを実行し実行ポリシーを変更後、再度実行していただければ幸いでございます。
>Set-ExecutionPolicy Unrestricted
 
5. 以下のような “ScriptStart Completed” 出力がされるまで、お待ちください。
*コマンドの実行には、環境によって 20 分ほど要する場合がございます。20 分経っても完了しない場合は、control + c を押下して強制終了してください。

![](https://user-images.githubusercontent.com/71251920/175529520-b67e7eab-baef-4036-8c89-64ec9a86e40b.gif)
 
6. コマンド実行が完了すると、スクリプトと同じフォルダ内に以下のようなログファイルが出力されますので、こちらを後述のアップロードサイトまでアップロード願います。
ログファイル名: AzureBackup_Check_NW_yyyymmdd_hhmmss.log

![](https://user-images.githubusercontent.com/71251920/175529523-b5004d01-f4cd-4879-9c48-b9de17a8c477.jpg)
* control + c にて強制終了した場合においても該当のログファイルが出力されますので、アップロードをお願いします。
