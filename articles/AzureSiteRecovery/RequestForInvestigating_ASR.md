---
title: ASR の障害調査に必要な情報
date: 2024-08-13 12:00:00
tags:
  - Azure Site Recovery
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Site Recovery サポートです。  
Azure Site Recovery (以下、ASR ) に関する調査をスムーズに進める為に、お客様側で確認して頂く箇所と、調査に必要な環境情報とログ情報を取得して頂き、サポートへ送付して頂く場合がございます。  
今回は、ASR の障害調査に必要な **環境情報** と **ログ情報** について、ご案内いたします。

## 目次
-----------------------------------------------------------
[1. 調査に必要な環境情報](#1)  
[2. ログの取得方法](#2)  
[2-1. Azure to Azure シナリオの障害調査に必要なログ](#2-1)  
[2-2. VMware to Azure / 物理マシン to Azure クラシック シナリオの障害調査に必要なログ](#2-2)  
[2-3. VMware to Azure / 物理マシン to Azure モダン化シナリオの障害調査に必要なログ](#2-3)  
[2-4. Hyper-V to Azure シナリオの障害調査に必要なログ](#2-4)  
[3. ログ収集ツールの使用方法](#3)  
[3-1. ASRDiagnosticTool の使用方法](#3-1)  
[3-2. collect_support_materials の使用方法](#3-2)  
-----------------------------------------------------------

## <a id="1"></a> 1. 調査に必要な環境情報

※既にお問い合わせチケット上に起票頂いている場合は、記載は不要になります。

1. 問題が発生しているサブスクリプション ID  
1. ASR のシナリオ詳細 (以下の内のどれか)  
　a. Azure to Azure  
　b. VMware to Azure モダン化  
　c. VMware to Azure クラシック  
　d. 物理マシン to Azure モダン化  
　e. 物理マシン to Azure クラシック  
　f. Hyper-V to Azure
1. 問題が発生している Recovery Service コンテナー名 
1. 問題が発生している Recovery Service コンテナーのリソース グループ名 
1. 対象の マシン名
1. 対象の Azure 仮想マシンのリソース グループ名
1. 対象の OS 
1. Proxy 設定の有無
1. ASR プライベート エンドポイント 設定の有無
1. Express Route 使用の有無

### 「モダン化」と「クラシック」を見分ける方法

ASR の VMware to Azure シナリオ / 物理マシン to Azure シナリオ では 「モダン化」 と 「クラシック」 の 2 つの構成があります。  
「モダン化」 と 「クラシック」 のどちらを利用しているかは、以下の画面から確認いただけます。

Azure Portal にて Recovery Services コンテナーを開き > はじめに - Site Recovery > 「VMware マシンを Azure に」 の下にある 1. の末尾に `(従来)` が、  
付与されている場合は、**「クラシック」の Recovery Services コンテナー** となります。  
付与されて**いない**場合は、**「モダン化」の Recovery Services コンテナー** となります。

<img src="https://github.com/user-attachments/assets/74f7a3aa-a3e9-41c9-b85f-a82c903fc74e">

## <a id="2"></a> 2. ログの取得方法

### <a id="2-1"></a> 2-1. Azure to Azure シナリオの障害調査に必要なログ

本シナリオではログを収集する方法が 2 つありますので、下記いずれかの方法にてログを収集ください。  
* 方法 1 : ツールを使用してログを収集する
* 方法 2 : 手動でログを収集する  

#### (方法 1) ツールを使用してログを収集する

<u>< Windows の場合 ></u>  
下記の手順に沿って ASRDiagnosticTool  を実行し、ログをご収集ください。  
[3-1 ASRDiagnosticTool の使用方法](#3-1)

<span style="color: red; ">またツール取得に加えて下記ファイルを手動で収集し、ご提供ください。</span>  
> C:\WindowsAzure\Logs

<u>< Linux の場合 ></u>  
下記の手順に沿って collect_support_materials.sh を実行し、ログをご収集ください。  
[3-2 collect_support_materials の使用方法](#3-2)  

<span style="color: red; ">またツール取得に加えて下記ファイルを手動で収集し、ご提供ください。</span>  

> /var/log/   
>   \- evtcollforw.log  
>   \- InstallerError.json  
>   \- tagTelemetry_*.log  
>   \- uarespawnd.log  
>   \- Waagent.log  
>   \- azure  
>   \- ASRsetuptelemetry  

#### (方法 2 ) 手動でログを収集する

<u>< Windows の場合 ></u>  
> C:\ProgramData\ASRSetupLogs  
> C:\ProgramData\Microsoft Azure Site Recovery  
> C:\Program Files\Microsoft Azure Recovery Services Agent\Temp  
> C:\Windows\System32\winevt\logs  
> C:\WindowsAzure\Logs  
> C:\Program Files (x86)\Microsoft Azure Site Recovery\agent **(※1)** 


**(※1)** 全量いただけることが望ましいですが、全量が困難な場合は下記をご提供ください。  
> C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\  
>   \- AzureRcmCli.log   
>   \- evtcollforw.log  
>   \- s2*.log  
>   \- svagent*.log   
>   \- vacp.log  
>   \- Application Data\ApplicationPolicyLogs  
>   \- vxlogs  


<u>< Linux の場合 ></u>  
> /var/log/  **(※1)**

**(※1)** 全量いただけることが望ましいですが、全量が困難な場合は下記をご提供ください。     

> /var/log/   
>   \- ApplicationPolicyLogs/vacp.log  
>   \- appservice*.log  
>   \- AzureRcmCli.log  
>   \- cdpcli.log  
>   \- evtcollforw.log  
>   \- InMage*.log  
>   \- InstallerError.json  
>   \- involflt*.log  
>   \- s2*.log  
>   \- svagent*.log  
>   \- tagTelemetry_*.log  
>   \- ua_install.log  
>   \- uarespawnd.log  
>   \- Waagent.log  
>   \- azure  
>   \- vxlogs  
>   \- ApplicationData  
>   \- ASRsetuptelemetry  

### <a id="2-2"></a> 2-2. VMware to Azure / 物理マシン to Azure クラシック シナリオの障害調査に必要なログ

ログ取得対象は下記マシン両方となります。
* 構成サーバーとして機能するマシン
* ソース マシン (保護対象マシン)

本シナリオではログを収集する方法が 2 つありますので、下記いずれかの方法にてログを収集ください。
* 方法 1 : ツールを使用してログを収集する
* 方法 2 : 手動でログを収集する

<span style="color: red; ">「構成サーバーとして機能するマシン」 と 「ソース マシン (保護対象マシン)」 両方から</span> 、 それぞれのログを収集ください。

#### (方法 1) ツールを使用してログを収集する

<u>< 構成サーバーおよび ソース マシンが Windows の場合 ></u>  
下記の手順に沿ってASRDiagnosticTool  を実行し、ログをご収集ください。  
[3-1 ASRDiagnosticTool の使用方法](#3-1)

<u>< ソース マシンが Linux の場合 ></u>  
下記の手順に沿って collect_support_materials.sh を実行し、ログをご収集ください。  
[3-2 collect_support_materials の使用方法](#3-2)

#### (方法 2 ) 手動でログを収集する
  
<u>< 構成サーバー ></u>  
> C:\ProgramData\ASRLogs  
> C:\ProgramData\ASRSetupLogs  
> C:\Windows\System32\winevt\logs  
> \<Cache InstallDir>\home\svsystems\pushinstallsvc\temporaryfiles\  

<u>< ソース マシン (Windows) ></u>  
> C:\ProgramData\ASRSetupLogs

<u>< ソース マシン (Linux) ></u>
> var/log/ua_install.log 

### <a id="2-3"></a> 2-3. VMware to Azure / 物理マシン to Azure モダン化シナリオの障害調査に必要なログ

ログ取得対象は下記マシン両方となります。
* レプリケーション アプライアンスとして機能するマシン
* ソース マシン (保護対象マシン)

本シナリオではログを収集する方法が 2 つありますので、下記いずれかの方法にてログを収集ください。

* 方法 1 : ツールを使用してログを収集する
* 方法 2 : 手動でログを収集する

<span style="color: red; ">「構成サーバーとして機能するマシン」 と 「ソース マシン (保護対象マシン)」 両方から</span> 、 それぞれのログを収集ください。

#### (方法 1) ツールを使用してログを収集する

<u>< レプリケーション アプライアンス および ソース マシンが Windows の場合 ></u>  
下記の手順に沿ってASRDiagnosticTool  を実行し、ログをご収集ください。  
[3-1 ASRDiagnosticTool の使用方法](#3-1)

<u>< ソース マシンが Linux の場合 ></u>  
下記の手順に沿って collect_support_materials.sh を実行し、ログをご収集ください。  
[3-2 collect_support_materials の使用方法](#3-2)

<span style="color: red; ">またツール取得に加えて下記ファイルを手動で収集し、ご提供ください。</span>  

> /var/log/   
>  \- evtcollforw.log  
>  \- InstallerError.json  
>  \- tagTelemetry_*.log  
>  \- uarespawnd.log  
>  \- Waagent.log  
>  \- azure  
>  \- ASRsetuptelemetry  

#### (方法 2 ) 手動でログを収集する

<u>< レプリケーション アプライアンス ></u>  
※ ファイルが存在しなければ取得不要です  
※ `<Cache InstallDir>` はアプライアンス構築時に指定したキャッシュ ディスクとなり、デフォルトでは `E:\` ドライブとなります。 

> C:\Program Files\Microsoft Azure Recovery Services Agent\Temp  
> C:\Program Files\Microsoft Azure Recovery Services On-Premise Agent\logs  
> C:\Program Files\Microsoft Azure Site Recovery Process Server\home\svsystems  
> C:\ProgramData\MicrosoftAzureDRApplianceConfigurationManager.log  
> C:\ProgramData\Microsoft Azure\Logs  
> C:\ProgramData\ASRLogs  
> C:\ProgramData\AutoUpdateInstaller.log  
> C:\ProgramData\DiscoveryServiceServerInstall.log  
> C:\ProgramData\DiscoveryServiceVmwareInstall.log  
> C:\ProgramData\InstallDra.log  
> C:\ProgramData\PushInstallAgentSetup.log  
> C:\ProgramData\RcmProxyAgentSetup.log  
> C:\ProgramData\RcmReplicationAgentSetup.log  
> C:\ProgramData\RcmReprotectAgentSetup.log  
> C:\ProgramData\ProcessServerSetup.log  
> C:\ProgramData\Install Log  
> C:\Windows\Temp\OBInstaller0Curr.errlog  
> C:\Windows\Temp\OBManagedlog.LOGCurr.errlog  
> C:\Windows\Temp\OBMsi.log  
> \<Cache InstallDir>\MarsAgent  
> \<Cache InstallDir>\PSTelemetry  
> \<Cache InstallDir>\PushInstallAgent  
> \<Cache InstallDir>\RcmProxyAgent  
> \<Cache InstallDir>\RcmReplicationAgent  
> \<Cache InstallDir>\RcmReprotectAgent  

<u>< ソース マシン (Windows) ></u>
> C:\ProgramData\ASRSetupLogs  
> \<Mobility service agent InstallDir>\agent **(※1)** 

**(※1)** 全量いただけることが望ましいですが、全量が困難な場合は下記をご提供ください。   
> \<Mobility service agent InstallDir>\agent\  
>  \- AzureRcmCli.log   
>  \- evtcollforw.log  
>  \- s2*.log  
>  \- svagent*.log   
>  \- vacp.log  
>  \- Application Data\ApplicationPolicyLogs  
>  \- vxlogs  

<u>< ソース マシン (Linux) ></u>
> /tmp/MobilityAgentAutoUpgrade/logs/ua_upgrader.log  
> /var/log/ **(※1)**

**(※1)** 全量いただけることが望ましいですが、全量が困難な場合は下記をご提供ください。  
> /var/log/   
>  \- ApplicationPolicyLogs/vacp.log  
>  \- appservice*.log  
>  \- AzureRcmCli.log  
>  \- cdpcli.log  
>  \- evtcollforw.log  
>  \- InMage*.log  
>  \- InstallerError.json  
>  \- involflt*.log  
>  \- s2*.log  
>  \- svagent*.log  
>  \- tagTelemetry_*.log  
>  \- ua_install.log  
>  \- uarespawnd.log  
>  \- Waagent.log  
>  \- azure  
>  \- vxlogs  
>  \- ApplicationData  
>  \- ASRsetuptelemetry  

### <a id="2-4"></a> 2-4. Hyper-V to Azure シナリオの障害調査に必要なログ

本シナリオではログを収集する方法は手動収集のみとなります。

<u>< Hyper-V ホスト マシン ></u>  
> C:\ProgramData\ASRLogs  
> C:\WindowsAzure\Logs  
> C:\Windows\System32\winevt\logs  
> C:\Program Files\Microsoft Azure Recovery Services Agent\Temp 

<u>< Hyper-V ゲスト マシン ></u>  
収集が必要なログはございません。

## <a id="3"></a> 3. ログ収集ツールの使用方法

### <a id="3-1"></a> 3-1. ASRDiagnosticTool の使用方法

ログ収集対象マシンが **Windows マシン** である場合、本ツールを利用して下記シナリオのログを収集できます。
* Azure to Azure
* VMware to Azure
* 物理マシン to Azure

ASRDiagnosticTool  を利用する前に、下記の各要件を満たしていることを確認してください。
* ツールを実行するマシンに .NET Framework 4.6.2 以上がインストールされていること  
（参考）方法: インストールされている .NET Framework バージョンを確認する  
https://learn.microsoft.com/ja-jp/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed#net-framework-45-and-later-versions
* C:\ ドライブにログを収集するための空き容量があること

下記の手順に沿って、  
<span style="color: red; ">「構成サーバーとして機能するマシン (クラシック)」 または 「ASR レプリケーション アプライアンス として機能するマシン (モダン化)」 と</span>  
<span style="color: red; ">「ソース マシン (保護対象マシン)」 の 2 つから、</span>  
それぞれにて本ツールを実行してログをご収集ください。

#### ステップ 1 :
対象の VM にサインインします。

#### ステップ 2 :
構成サーバー (クラシック) または ASR レプリケーション アプライアンス (モダン化) とソース マシンの下記ディレクトリに、 ASRDiagnosticTool  が配置されているか確認します。
* 構成サーバー (クラシック) : `<Cache InstallDir>\agent\ASRDiagnosticTool`
* ASR レプリケーション アプライアンス  (モダン化)  : `<Cache InstallDir>\ProgramData\Microsoft Azure\Tools\ASRDiagnosticTool`
* ソース マシン : `C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\ASRDiagnosticTool`
    
配置されていない場合は下記の手順に従って配置します。  
1. https://aka.ms/ASRDiagnosticTool から ASRDiagnosticTool.zip ファイルをダウンロードします。
2. zip ファイルを解凍し、ログを取得したいマシン上に配置します。


#### ステップ 3 :
(ソース マシン (保護対象マシン) 上でツールを実行する場合はスキップください)   

構成サーバー (クラシック) または ASR レプリケーション アプライアンス (モダン化) のキャッシュ ドライブのインストール先が E ドライブ以外の場合は、下記の設定変更を行います。  

1. `<ASRDiagnosticToolのインストール先>\ASRDiagnosticTool\Config` に移動し、ApplianceLogs.json ファイルを開きます。
2. `E:\` となっているすべての文字列を検索し、構成サーバーのキャッシュ ドライブのインストール先に変更します。  
    例えば、`M:\` ドライブにインストールしている場合は、`E:\\MarsAgent\\logs` を `M:\\MarsAgent\\logs` に変更します。

#### ステップ 4 :

下記手順に従って ASRDiagnosticTool を実行します。
1. 管理者モードでコマンド プロンプトを開きます。
2. 次のコマンドで ASRDiagnosticTool  の配置先に移動します。  
    ※ `<ASRDiagnosticToolのインストール先>` はインストール先のディレクトリに書き換えてください。　  
    ```
    cd "<ASRDiagnosticToolのインストール先>\ASRDiagnosticTool"
    ```
3. 次のコマンドで ASRDiagnosticTool  を実行します。 (完了まで5 ~ 30 分 かかります。また、かかる時間は実行している環境によって異なります)
    ```
    ASRDiagnosticTool.exe
    ``` 

(実行例)
<img src="https://github.com/user-attachments/assets/a0c74364-8566-49a2-b8a7-be6efe9cf247">

#### ステップ 5 :

コマンド プロンプトに下記のようなメッセージが表示されていれば、ログの収集成功となります。
`Please collect the archive at` に圧縮されたログが生成されますので、本ログをご提供いただけますと幸いです。
```
Log collection completed successfully.
Please collect the archive at C:\Users\Administrator\AppData\Roaming\ASRDiagnosticLogs-WIN-C381N1BJK2T-25-07-15-14-57.zip.
```

#### ツール利用時の影響について

当ツールは、単純なログ収集ツールとなっております。これまで「高負荷となった」、「サーバーのリブート」や「特定のサービスが再起動する」といった事例の報告はございません。  

実際に CPU/メモリがどれくらい消費されるか・ログファイル量は、お客様の環境に依存しますので明確な指標をお出しすることは難しくございますが、弊社検証環境 (Azure 仮想マシン (Standard D8as v5 (8 vcpu 数、32 GiB メモリ))) で当該スクリプトを実行した場合、<span style="color: green; ">**ツール実行～終了までのおよそ 3 分 20 秒間**</span>では下記結果となり、「非常に大きな負荷がかかった」等の数値は確認しておりません。  
しかしながら、こちらの結果はあくまでも弊社環境での検証となりますため、必要に応じてお客様ご自身の環境にて検証いただきますようお願い申し上げます。

<details>

<summary>ツール利用時のパフォーマンス検証結果</summary>

下記表は `パフォーマンス モニター` を使ったパフォーマンスの検証結果となります。

|-|CPU|-|-|-|Disk|-|-|-|Memory|-|-|-|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|
|Time|**Processor Time**|**User Time**|**Privileged Time**|**Interrupt Time**|**Disk Time**|**Current Disk Queue Length**|**Avg. Disk sec/Write**|**Avg. Disk sec/Read**|**Available MBytes**|**Pages/sec**|**Committed Bytes In Use**|**Committed Bytes**|
|08/05/2024 19:56:22| | | | | |0 | | |29303 | |8.95 |3533012992|
|08/05/2024 19:56:52|0.05 |0.03 |0.03 |0.00 |0.14 |0 |0.00 |0.01 |29303 |2.80 |8.94 |3528171520|
|08/05/2024 19:57:22|3.95 |2.41 |1.51 |0.01 |0.14 |0 |0.00 |0.01 |29312 |0.73 |8.97 |3538006016|
|08/05/2024 19:57:52|0.60 |0.27 |0.30 |0.01 |0.19 |0 |0.00 |0.01 |29236 |1.20 |9.23 |3641659392|
|08/05/2024 19:58:22|0.13 |0.08 |0.04 |0.00 |0.10 |0 |0.00 |0.00 |29241 |0.13 |9.22 |3636760576|
|08/05/2024 19:58:52|0.90 |0.30 |0.57 |0.00 |32.52 |1 |0.00 |0.01 |28870 |0.13 |10.13 |3995738112|
|08/05/2024 19:59:22|0.96 |0.38 |0.59 |0.03 |33.07 |1 |0.00 |0.01 |28541 |0.13 |10.98 |4331937792|
|08/05/2024 19:59:52|4.94 |3.35 |1.55 |0.00 |29.31 |1 |0.00 |0.01 |29189 |350.56 |9.23 |3644022784|
|08/05/2024 20:00:22|28.85 |24.40 |4.45 |0.04 |39.55 |10 |0.05 |0.00 |29083 |34.47 |9.20 |3631489024|
|08/05/2024 20:00:52|2.01 |1.24 |0.74 |0.00 |55.49 |0 |0.02 |0.00 |29232 |38.91 |8.99 |3547832320|
|08/05/2024 20:01:22|0.04 |0.05 |0.04 |0.00 |0.07 |0 |0.00 |0.00 |29236 |0.13 |8.98 |3544920064|
|08/05/2024 20:01:52|0.12 |0.04 |0.01 |0.00 |0.09 |0 |0.00 |0.00 |29236 |0.13 |8.98 |3542532096|
</details>

### <a id="3-2"></a> 3-2. collect_support_materials の使用方法

ログ収集対象マシンが **Linux マシン** である場合、本ツールを利用して下記シナリオのログを収集できます。
* Azure to Azure
* VMware to Azure
* 物理マシン to Azure

下記の手順にそって本ツールを実行して、ログを収集してください。

#### ステップ 1 :  
対象の VM にサインインします。

#### ステップ 2 :  
スクリプト `/usr/local/ASR/Vx/bin/collect_support_materials.sh` を管理者権限で実行します

#### ステップ 3 : 
以下のように出力されますので、`support store location` の `free space` が十分であることをご確認いただき、`Y` または `y` を入力してください。  

(出力例)
<img src="https://github.com/user-attachments/assets/50ab3587-7945-4d7a-8465-60183c850a4b">

#### ステップ 4 : 
上記 `support store location` に圧縮されたログが生成されますので、本ログをご提供いただけますと幸いです。


#### ツール利用時の影響について
当ツールは、単純なログ収集ツールとなっております。これまで「高負荷となった」、「サーバーのリブート」や「特定のサービスが再起動する」といった事例の報告はございません。   
出力されるログファイルの量は環境毎、およびシナリオ毎で異なりますが、弊社検証環境での動作確認ではログ ファイルのサイズは 700 KB 程度でございました。

実際に CPU/メモリがどれくらい消費されるかは、お客様の環境に依存しますので明確な指標をお出しすることは難しくございますが、弊社検証環境 (Azure 仮想マシン (Standard D8as v5 (8 vcpu 数、32 GiB メモリ))) で当該スクリプトを実行した場合、<span style="color: green; ">**スクリプト実行～終了までのおよそ 20 秒間**</span>では下記結果となり、「非常に大きな負荷がかかった」 等の数値は確認しておりません。  
しかしながら、こちらの結果はあくまでも弊社環境での検証となりますため、必要に応じてお客様ご自身の環境にて検証いただきますようお願い申し上げます。

<details>

<summary>ツール利用時のパフォーマンス検証結果</summary>

下記表は `vmstat` コマンドを使ったパフォーマンスの検証結果となります。
```
vmstat 5 | awk '{ print strftime("%Y/%m/%d %H:%M:%S"), $0 }'
```

|-|procs|-|memory|-|-|-|swap|-|io|-|system|-|cpu|-|-|-|-|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|
|**Time**|**r**|**b**|**swpd**|**free**|**buff**|**cache**|**si**|**so**|**bi**|**bo**|**in**|**cs**|**us**|**sy**|**id**|**wa**|**st**|
|2024/6/3 8:38:04|0|1|0|459724|4184|15316156|0|0|2544|1481|308|811|5|1|72|22|0|
|2024/6/3 8:38:09|0|2|0|524152|4184|15248072|0|0|21636|5809|2451|6335|2|1|79|19|0|
|2024/6/3 8:38:14|0|1|0|511444|4184|15260096|0|0|18309|67|2960|7064|1|1|89|9|0|
|2024/6/3 8:38:19|0|1|0|495660|4184|15271268|0|0|17027|328|2542|6767|2|1|89|9|0|
|2024/6/3 8:38:24|1|1|0|448740|4184|15311520|0|0|29925|115|6789|13947|7|2|79|12|0|
|<span style="color: green; ">2024/6/3 8:38:29|5|3|0|374476|4184|15384444|0|0|36440|73|9115|18576|12|2|76|9|0|
|<span style="color: green; ">2024/6/3 8:38:34|0|1|0|413664|4184|15346216|0|0|29338|588|3365|6832|1|1|88|10|0|
|<span style="color: green; ">2024/6/3 8:38:39|0|1|0|394872|4184|15364684|0|0|25054|3479|3219|6826|2|1|78|19|0|
|<span style="color: green; ">2024/6/3 8:38:44|0|1|0|376320|4184|15383056|0|0|43755|75|4825|7378|2|1|88|9|0|
|<span style="color: green; ">2024/6/3 8:38:49|0|2|0|331164|4184|15416172|0|0|43115|332|4878|7463|3|1|82|13|0|

</details>