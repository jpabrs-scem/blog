---
title: Azure VM Backup のジョブ前後で任意の処理を行いたい
date: 2023-01-11 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートです。
今回は、よくお問い合わせをいただく、下記 2 種類をお客様要件で実現されたい場合について、ご説明します。
１．何らかの処理 (ジョブ・サービス) が終了したあとに ⇒ Azure VM Backup を開始させたいが、Azure Backup としてそのような機能の用意があるか？
２．Azure VM Backup のジョブが成功したあとに ⇒ 何らかの処理 (ジョブ・サービス) を開始させたいが、Azure Backup としてそのような機能の用意があるか？

結論から申し上げますと、上記１．２．どちらも実現できるようなものは、残念ながら Azure VM Backup としては特定の機能のご用意がございません。
考えられる案や考慮事項がありますので、詳しく説明します。

## 目次
-----------------------------------------------------------
[1. 何らかの処理 (ジョブ・サービス) が終了したあとに ⇒ Azure VM Backup を開始させたいが、Azure Backup としてそのような機能の用意があるか？](#1)
[2. バックアップ ポリシーに従って取得済の復元ポイントの中の、特定の復元ポイントのみの保持期間を延長して保持しておくことは可能か](#2)
-----------------------------------------------------------

## 1. 何らかの処理 (ジョブ・サービス) が終了したあとに ⇒ Azure VM Backup を開始させたいが、Azure Backup としてそのような機能の用意があるか？<a id="1"></a>

### 〈バックアップ対象が Linux OS の Azure 仮想マシンの場合〉
対象 Azure 仮想マシン内に、事前スクリプト・事後スクリプトを貴社にて構築させることによって可能です。
事前・事後スクリプトは、元々 Linux OS の仮想マシンを、アプリケーション整合性にて取得したい場合に組み込むものでございます。

#### (処理概要)
（０）事前準備として、事前/事後スクリプトを構成しておく
（１）バックアップ ポリシーに従ってAzure VM Backup (スケジュール バックアップ) を開始させる
（２）Azure VM Backup 処理内で事前スクリプトが起動 
（３）事前スクリプト内にて、【★ご要件の何らかの処理 (ジョブ・サービス) 】が正常終了しているかどうかを確認する
（４）★が正常終了している場合は、事前スクリプトを終了させ、Azure VM Backup の処理 (スナップショット取得) を続ける
（５）スナップショット取得処理終了後、事後スクリプト開始・終了
（６）Azure VM Backup のジョブ自体がすべて終了

事前/事後スクリプト構成詳細は以下公開ドキュメントをご参考ください。
・Linux VM のアプリケーション整合性バックアップ - Azure Backup | Microsoft Docs
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-linux-app-consistent#steps-to-configure-pre-script-and-post-script

### 〈バックアップ対象が Windows OS の Azure 仮想マシンの場合〉
Azure Backup としては、残念ながら機能のご用意がございません。

### 〈そのほかの案〉
Linux / Winodws OS に関わらず、その他考えられる案としては下記が挙げられます。

#### 〈案 1 〉
お客様にてスクリプトを構成し、スクリプト内部にて【★ご要件の何らかの処理 (ジョブ・サービス) 】が終了したことを確認後、Azure VM Backup をトリガーする。
(処理概要)
（１）【★ご要件の何らかの処理 (ジョブ・サービス) 】を開始・正常終了させる
（２）お客様にてスクリプトを構成し、スクリプト内にて、★が正常終了していることを確認する
（３）スクリプト内から Azure VM Backup を「オンデマンド バックアップ」としてトリガーさせる
　＋　バックアップ ポリシーにて、週に 1 回スケジュール バックアップを実行させるよう構成する。(※)
　＋　週に 1 度はスケジュール バックアップを実行させる。

コマンドラインからバックアップを実行する場合は必ず「オンデマンド バックアップ (今すぐバックアップ) 」というバックアップの種類となります。
Azure VM Backup では、Azure CLI ・Azure PowerShell コマンドなどを用いてオンデマンド バックアップをトリガーすることが可能です。

・クイックスタート - PowerShell で VM をバックアップする - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/quick-backup-vm-powershell#start-a-backup-job

・クイックスタート - Azure CLI で VM をバックアップする - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/quick-backup-vm-cli#start-a-backup-job

(※) 以下ブログに記載の通り、スケジュールされたバックアップを週に 1 度は実行いただきたい理由がございますので、ブログ説明もご参照いただけますと幸いです。
・Azure VM バックアップを任意のタイミングのみで取得したい | Japan CSS ABRS & SCEM Support Blog (jpabrs-scem.github.io)
　https://jpabrs-scem.github.io/blog/AzureVMBackup/invalid_schedule/
 
また、〈案 1 〉のスクリプト構成は、Azure Automation にて展開している Runbook の機能を使って構成することも可能です。
下記に、Runbook のスケジュール説明も含めた Azure Automation の参考ドキュメントがございますので、ご参考いただけますと幸いです。
・Azure Automation で Runbook を管理する | Microsoft Docs
　https://learn.microsoft.com/ja-jp/azure/automation/manage-runbooks

なお、 Azure Automation ならびに Runbook に関するご質問がございます場合には、弊社サポート サービスまでお問合せいただけますと幸いです。

#### 〈案 2 〉
★が確実に終了している時間帯に、バックアップポリシーに従って、Azure VM Backup （スケジュール バックアップ）を 開始させるよう、バックアップ ポリシーの開始時間を設定しておく。
この場合、〈案 1 〉のブログに記載している「Garbage Collection」の問題は (必ずスケジュール バックアップを実行させているため) 回避できますが、★の成功・失敗に関わらず、バックアップ ポリシーに従って必ず Azure VM Backup が開始される、という懸念点がございます。

## 2. Azure VM Backup のジョブが成功したあとに ⇒ 何らかの処理 (ジョブ・サービス) を開始させたいが、Azure Backup としてそのような機能の用意があるか？<a id="2"></a>
残念ながら、Azure Backup サービスの単体としては機能のご用意がございませんこと、お伝えいたします。
そのうえで、考えられる案としては下記がございます。

### 〈案 3 〉
Azure VM Backup のバックアップ ジョブ ステータスを確認するコマンドにてバックアップ ジョブのステータスを確認後、【★ご要件の何らかの処理 (ジョブ・サービス) 】を開始させるるようなスクリプトをお客様にて構成する。
#### (処理概要)
（１）Azure VM Backup のスケジュール バックアップが開始
（２）お客様にて別途実装されたスクリプトを起動する
（３）スクリプト内で、バックアップ ジョブのステータスを確認するコマンドを実行し「Take Snapshot」フェーズが「Completed」となっているかどうか確認する
（４）スクリプト内で、「Take Snapshot : Completed」となっていることを確認したら、★を開始させる

Azure VM Backup のバックアップ ジョブには「Take Snapshot」フェーズと、「Transfer data to vault」フェーズという、2 つのフェーズで構成されています。
1 つ目の「Take Snapshot」フェーズが「完了 Completed」となれば、Azure 仮想マシンの再起動含めた その他★の作業を実施いただいて構いません。

・Azure VM Backup における Take Snapshot フェーズの確認方法 | Japan CSS ABRS Support Blog !! (jpabrs-scem.github.io)
　https://jpabrs-scem.github.io/blog/AzureVMBackup/How_to_check_VM_backup_Subtask/

### Azure VM Backup はバックアップ ポリシー通りの時間に開始されるのか？
通常、バックアップ ポリシーにて設定した時間のおよそ 5 分～ 20 分以内程でバックアップ ジョブが開始いたしますが、最大では 2 時間以内にバックアップ ジョブを開始するしくみとなっております。
 
・自分の VM バックアップ ポリシーで設定した、スケジュールされたバックアップ時刻からバックアップ開始時刻までの最大遅延時間はどれぐらいですか。
　https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vm-backup-faq#----vm-----------------------------------------------------------------
　“スケジュールされたバックアップは、スケジュールされたバックアップ時刻から 2 時間以内にトリガーされます。”

### Azure VM Backup は通常どれくらいの時間でバックアップ ジョブが終了するのか？

初回バックアップ以降の、毎回のバックアップ ジョブが完了するまでの時間は最大 24 時間以内となっております。
リストアやバックアップにかかる時間については、恐縮ながら弊社としては指標を出しておりません。
Azure サービスはマルチテナント サービスであるため、バックアップ アイテム (VM) のデータサイズのみではなく、他のリソース、他のユーザー様の稼働状況、帯域の状況などにも処理時間は左右されるためでございます。
一方、「Take Snapshot」フェーズのみについて言及しますと、こちらも「必ず〇分に終わる」というベンチマークなどは公開いたしておりませんが、基本的には 5 – 15 分程度で「Take Snapshot」フェーズは完了することが多くございます。

・初回バックアップの完了に時間がかかるのはなぜですか?
　https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vm-backup-faq#-------------------------
　“増分バックアップの合計バックアップ時間は 24 時間未満ですが、初回バックアップではそうはならないことがあります。”

・Azure Backup での自動化 - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/automation-backup

・Azure Backup の バックアップ / リストア 所要時間について
　https://jpabrs-scem.github.io/blog/AzureBackupGeneral/Backup_RecoveryTIme/

### 〈注意事項〉
Linux OS に対する事前/事後スクリプトの実装や、スクリプトの構成についてはお客様の責任のもと、お客様に検証のうえ、実装いただきますようご留意くださいませ。
Azure サポートでは主に Post Production の Break & Fix を担当しており、スクリプトのコードレビューのサポートは承っておりませんので、ご理解をいただけますと幸いです。
