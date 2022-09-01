---
title: MARS エージェントの再インストール手順
date: 2022-08-11 12:00:00
tags:
  - MARS Backup 
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートの 山本 です。
今回は MARS エージェントの再インストール手順をお伝えさせていただきます。

なお、なんらかの不具合が発生している場合の MARS エージェントの再インストールは **上書きインストールではなく、必ず 一度アンインストールした上**で実施いただくようお願いいたします。
例えば、ネットワーク構成などを変えていないのに、MARS コンソールが立ち上がらなくなった (正常に動作しなくなった) 場合やバックアップ が失敗するようになった等の場合は再インストールが有効な対処策であることが多くございます。

特に証明書関連のエラーの場合再インストールの前後で証明書に変化があったかご確認いただけますと幸いです。
その際は下記記事を参考にして作業前後で証明書をご確認ください。
 ・4.4 各種証明書の確認証跡 - 4. MARS Backup エージェントを利用したバックアップ の障害調査に必要なログ
https://jpabrs-scem.github.io/blog/RecoveryServicesVaults/RequestForInvestigating/#4-4

>【注意】MARS エージェントの再インストール後も以前のスケジュールバックアップ設定や復元ポイントを利用可能ですが、その際には以前 MARS エージェントのサーバー登録時に利用したパスフレーズが必要となりますので、再インストール時は **パスフレーズがお手元にあることを確認の上**、作業を実行してください。

# 目次
-----------------------------------------------------------
[1. MARS エージェントのアンインストール](#1)
[2. MARS エージェントの(再)インストール](#2)
[3. サーバーの登録](#3)
[4. 関連公開情報](#4)
-----------------------------------------------------------


## <a id="1"></a> 1.MARS エージェントのアンインストール
### <a id="1-1"></a> 1-1. MARSバックアップ対象のマシンにログインします
 下記のフォルダーをコピーして任意の別の場所に退避しておきます。
 正常に再インストールが完了した際にはこの退避したフォルダは不要です。

>（対象パス）C:\Program Files\
>（コピーする対象のフォルダー）Microsoft Azure Recovery Services Agent

### <a id="1-2"></a> 1-2. windows ボタン + r を押し、”appwiz.cpl” と入力し、「OK」＞「プログラムのアンインストールまたは変更」画面を開きます
![](https://user-images.githubusercontent.com/71251920/183884809-a24326c5-9e6c-4650-98df-f354c90bb8e6.gif)

 
### <a id="1-3"></a> 1-3.「Microsoft Azure Recovery Services Agent」を右クリックし、「アンインストールと変更」をクリックします

![](https://user-images.githubusercontent.com/71251920/183884818-da800c52-0679-4bcd-9c28-ccce17395789.gif)
 
### <a id="1-4"></a> 1-4. MARSアプリケーション のアンインストール ウィザードが開くため、「アンインストール」をクリックします
![](https://user-images.githubusercontent.com/71251920/183884819-28da14c8-ab0b-40c3-834a-904022cc5b29.gif)

 
### <a id="1-5"></a> 1-5. アンインストールされたことを確認してください。
![](https://user-images.githubusercontent.com/71251920/183884823-5425bdb1-c90c-462e-b0a3-00d6c4501677.gif)



## <a id="2"></a> 2. MARS エージェントの(再)インストール
### <a id="2-1"></a> 2-1. Azure Portal > 該当のRecovery Services コンテナー > 設定 – バックアップ より以下を選択し、”インフラストラクチャの準備” をクリックしてください。
> ワークロードはどこで実行されていますか？：オンプレミス
> 何をバックアップしますか？：ファイルとフォルダー

![](https://user-images.githubusercontent.com/71251920/183884826-21eb4c46-5e1e-411f-897b-40d044239f08.png)


### <a id="2-2"></a> 2-2. “Windows Server または Windows クライアント用エージェントのダウンロード” をクリックしてください。
  *最新版のMARS エージェントインストーラーがダウンロードされます。

![](https://user-images.githubusercontent.com/71251920/183884831-69713e5d-6082-447b-8538-5a19a93f2b8c.png)


### <a id="2-3"></a> 2-3. ダウンロードしたインストーラーを該当のサーバーにて実行してください。
![](https://user-images.githubusercontent.com/71251920/183884834-9ed43c8f-220e-4d78-97f0-cb35513ffa7b.png)



### <a id="2-4"></a> 2-4. セットアップ ウィザードが開きますので、ウィザードの案内に従い、MARS エージェントをインストールしてください。
![](https://user-images.githubusercontent.com/71251920/183884835-58440b1a-3878-417c-8d96-9549f16569ed.png)



### <a id="2-5"></a> 2-5. インストール完了後、”登録処理を続行” をクリックしてください。
![](https://user-images.githubusercontent.com/71251920/183884838-494e0293-35f4-4a8d-b3e8-00397d7fcb07.png)



### <a id="2-6"></a> 2-6. サーバーの登録ウィザードが開きますので、次の手順に進んでください。
![](https://user-images.githubusercontent.com/71251920/183884839-22e5fb59-1277-489d-8562-d8a44f44806b.png)




## <a id="3"></a> 3. サーバーの登録
### <a id="3-1"></a> 3-1. 手順 2-2 の画面にて ”最新のRecovery Services Agent を既にダウンロードしたか、使用している” にチェックし、ダウンロードをクリックしてください。
*Recovery Services コンテナーの資格情報がダウンロードされます。

![](https://user-images.githubusercontent.com/71251920/183884840-b8b63d4d-a62c-46fc-8540-f1b6d74175ad.png)


### <a id="3-2"></a>3-2. ダウンロードした資格情報を該当のサーバーに配置してください。
![](https://user-images.githubusercontent.com/71251920/183884842-e0613cd2-97fa-4fc9-85fe-02c9077d400e.png)



### <a id="3-3"></a>3-3. 手順2-6の画面にて手順3-2でダウンロードした資格情報を選択し、”次へ” をクリックしてください。
![](https://user-images.githubusercontent.com/71251920/183884843-f63375af-7ca7-48d7-a69b-3f63078a5882.png)



### <a id="3-4"></a>3-4. 以前登録したパスフレーズを入力し、パスフレーズを保存する任意の場所を選択して、”登録” をクリックして登録を完了してください。
![](https://user-images.githubusercontent.com/71251920/183884846-073e873b-b194-4efa-9ab0-7cbbcd6a33a9.png)


## <a id="4"></a>4. 関連公開情報
・MARS エージェントのダウンロード
https://docs.microsoft.com/ja-jp/azure/backup/install-mars-agent#download-the-mars-agent

・サーバーにインストールされている MARS エージェントの更新
https://docs.microsoft.com/ja-jp/azure/backup/upgrade-mars-agent#update-the-mars-agent-installation-on-the-server
・パスフレーズを忘れた場合、復旧できますか?
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-file-folder-backup-faq#%E5%BE%A9%E5%85%83

本記事の内容は以上となります。