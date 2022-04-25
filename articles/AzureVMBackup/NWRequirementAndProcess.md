---
title: Azure VM Backup の通信要件や処理の流れについて
date: 2022-02-16 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure VM Backup における通信要件や処理の流れに関して、具体的なお問い合わせ例を交えて公式ドキュメントを補足する形でご説明させていただきます。

## 目次
-----------------------------------------------------------
[1. Azure VM Backup の 通信要件について](#1)
 [1-1.参考 URL](#1-1)
[2. Azure VM Backup の処理の流れ](#2)
 [2-1. Take Snapshot フェーズ](#2-1)
 [2-2. Transfer data to vault フェーズ](#2-2)
 [2-3. 参考 URL](#2-3)
[3. よくいただくお問い合わせ](#3)
-----------------------------------------------------------

## <a id="1"></a>1. Azure VM Backup の 通信要件について
Azure VM Backup の通信要件は VM Agent が正常に動作するために必要な通信要件と同じでございます。
VM Agent の通信要件は下記の通り、Wire Server と呼ばれる各ノードごとにある 仮想パブリック IP 168.63.129.16 に対して通信ができることでございます。
つまり、**Azure VM Backup の通信要件は 168.63.129.16 に対して通信ができること**です。

・Azure Linux エージェントの理解と使用 - 必要条件 [Linux]
https://docs.microsoft.com/ja-jp/azure/virtual-machines/extensions/agent-linux#requirements
>VM が IP アドレス168.63.129.16 にアクセスできることを確認します。

・Azure 仮想マシン エージェントの概要 - 前提条件 [Windows]
https://docs.microsoft.com/ja-jp/azure/virtual-machines/extensions/agent-windows#prerequisites
>VM が IP アドレス168.63.129.16 にアクセスできることを確認します。

**当該仮想パブリック IP 168.63.129.16 (Wire Server) は Azure VM Backupはじめ、DNS 機能など Azure 内の様々な用途で使用されているため、Azure 内部で優先的にルーティングされる様になっており NSG や Azure Firewall の影響は受けず、かつ、ロンゲストマッチにより、0/0 強制ルーティング (強制トンネリング) ではオンプレに引き込まれずに Azure 側にルーティングされるようになっています。ただし、VM 内部でのファイアーウォール ではブロックすることは可能です。**
下記公式ドキュメントが参考になるかと存じます。
・IP アドレス 168.63.129.16 とは
 https://docs.microsoft.com/ja-jp/azure/virtual-network/what-is-ip-address-168-63-129-16
>VM エージェントでは、ポート 80/tcp と 32526/tcp を介した WireServer (168.63.129.16) とのアウトバウンド通信が必要です。 これらは、VM 上のローカル ファイアウォールでは開いている必要があります。 これらのポート上での 168.63.129.16 との通信は、構成されたネットワーク セキュリティ グループの対象ではありません。

####  1.1 参考 URL<a id="1-1"></a>
合わせて下記の公式ドキュメントもご覧ください。
Azure VM Backup ではオンラインバックアップの場合、初回オンラインバックアップ時に VM agent の拡張機能がインストールされること、および VM agent が正常に動作することが必要であることが分かります。

・Azure VM バックアップの概要 - バックアップ プロセス
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#backup-process
>最初のバックアップ時に、バックアップ拡張機能が VM にインストールされます (VM が実行されている場合)

・Azure VM バックアップのサポート マトリックス - サポートされるシナリオ
https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#supported-scenarios
>Azure VM では、追加のエージェントは必要ありません。 Azure Backup によって、VM 上で実行している Azure VM エージェントに対して拡張機能がインストールされ、使用されます。

・Azure VM バックアップのサポート マトリックス - オペレーティング システムのサポート (Windows)
https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#operating-system-support-windows
>Azure VM エージェント拡張機能を使用したバックアップ

・Azure VM バックアップのサポート マトリックス - オペレーティング システムのサポート (Linux)
https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#support-for-linux-backup
>***VM 上で Linux 用の Azure VM エージェントが動作し***かつ Python がサポートされていれば使用できます。

・Azure Backup のアーキテクチャとコンポーネント - Azure Backup のしくみ
https://docs.microsoft.com/ja-jp/azure/backup/backup-architecture#how-does-azure-backup-work
>Azure VM をバックアップする:Azure VM を直接バックアップすることができます。 Azure Backup によって、VM 上で実行されている Azure VM エージェントに、バックアップ拡張機能がインストールされます。 この拡張機能は、VM 全体をバックアップします。

## <a id="2"></a>2. Azure VM Backup の処理の流れ
まず、下記の公式ドキュメントをご覧ください。
・Azure VM バックアップの概要 - バックアップ プロセス
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#backup-process

**上記公式ドキュメントをご覧いただいた前提で記載させていただきます。**
オンライン (VM 起動中) の Azure VM Backup では VM agent の機能の拡張機能としてバックアップ拡張機能を利用します。
オフラインの場合は VM 内部と連携しないため、VM agent が対応していないような VM でもバックアップをクラッシュ整合性で取得することが可能です。
なお、オフライン状態 とは VM が **"状態 : 停止済み (割り当て解除)"** である状態を指します。

ご参考にまでに下記も併せてご覧ください。
参考ブログ記事
・Azure VM Backup では オフライン バックアップができるのか
https://jpabrs-scem.github.io/blog/AzureVMBackup/Azure_VM_Offline_backup/
・クラッシュ整合性 - Azure VM Backupにおける整合性について
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#3


Azure VM Backupでは バックアップ ジョブの画面で確認できるように、順番に Take Snapshot と Transfer data to vault の 2 つの大きなフェーズ  (Sub Task) がございます。これら 2 つのフェーズが完了して初めてバックアップ ジョブとして完了となります。
![](https://user-images.githubusercontent.com/71251920/154117538-c4961564-fd9e-4e77-91ee-bff235da3704.png)


### <a id="2-1"></a>2.1 Take Snapshot フェーズ
まず、オンライン バックアップの場合、バックアップ拡張機能によって OS 内部と連携し静止点をとり、スナップショット データを取得します。その際のスナップショット データはユーザーからは見えない (マネージドな) ローカル物理ホスト上で取得します。
次に、オフライン バックアップの場合 は OS 内部と連携せずスナップショットを取得します。
Azure VM Backup において VM と連携する処理は Take Snapshot フェーズのみでございます。
そのため、Take Snapshot フェーズが完了すれば VM の再起動や運用によってはアップデートや DB の再開などを行っていただいてもかまいません。
Azure VM Backup はオンラインでもオフラインでもバックアップすることが可能ですが、**Take Snapshot フェーズ** に電源操作をされた場合には対象のバックアップが失敗する可能性がございます。
Take Snapshot フェーズが終わっていれば有事の際にはインスタントリストア機能を用いてリストアすることも可能です。
・Azure Backup のインスタント リストア機能を使用してバックアップと復元のパフォーマンスを改善する
https://docs.microsoft.com/ja-jp/azure/backup/backup-instant-restore-capability

なお、前回のバックアップ ジョブが Take Snapshot フェーズの場合、後続のバックアップ ジョブは失敗する仕様となっております。


その他 以下参考になれば幸いです。
・Azure Backup は、アプリケーションのパフォーマンスに影響を与えますか?
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vm-backup-faq#azure-backup----------------------------
抜粋 : “VM スナップショットの作成には数分かかります。この段階では、アプリケーションのパフォーマンスに対する影響はほとんどありません。”

・ VM スナップショットに関する問題のトラブルシューティング
 https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-troubleshoot#troubleshoot-vm-snapshot-issues
抜粋 : “VM の CPU またはメモリが高くなっています。 仮想マシンのメモリまたは CPU の使用率が高くなり、90% を超えてると、スナップショット タスクがキューに格納されて遅延します。 最終的にはタイムアウトになります。”


### <a id="2-2"></a>2.2 Transfer data to vault フェーズ
つぎに、ローカル物理ホスト上から Recovery Services コンテナー(バックアップデータ専用ストレージコンテナー) へ転送いたします。そのため**バックアップデータは VM の 仮想 NIC を通って Recovery Services コンテナーへ転送されるのではなく、バックエンドで (ローカル物理ホスト上から物理的に離れた同一リージョン内にある) Recovery Services コンテナーへ転送されます。**

なお、前回のバックアップ ジョブが Transfer data to vault フェーズの場合、後続のバックアップ ジョブの Transfer data to vault フェーズは Skip される仕様となっており、リトライなどは実施されません。

#### <a id="2-3"></a>2.3 参考 URL
・Azure VM バックアップの概要 - バックアップ プロセス
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#backup-process

・Azure VM Backup では オフライン バックアップができるのか
https://jpabrs-scem.github.io/blog/AzureVMBackup/Azure_VM_Offline_backup/

・クラッシュ整合性 - Azure VM Backupにおける整合性について
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#3

・よく寄せられる質問 - Azure VM のバックアップ - スナップショットをストレージ アカウントからコンテナーに移動した場合、転送中の暗号化はどのように管理されますか?
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vm-backup-faq#-------------------------------------------------------

>Azure VM バックアップでは、転送中の暗号化に HTTPS 通信を使用します。 **データ転送では、VM のバックアップにインターネット アクセスを必要としない Azure ファブリック (パブリック エンドポイントではなく) を使用します**。



## <a id="3"></a>3. よくいただくお問い合わせ
これらに関連してよくいただくお問い合わせと回答を記載させていただきます。


>Q. 強制トンネリングを実施しているが、Azure VM Backup の通信を強制トンネリング対象から除外したいが、どのような設定をすればよいか。UDR を用いて可能か？
>>A. Azure VM Backupに必要な通信は強制トンネリングや NSG の影響を受けないためローカル (OS内部) FW でブロックしていない限り通信要件は満たされます。
そのため強制トンネリング環境であっても特別な考慮は不要です。
また、UDR を用いて該当通信をルーティングすることはできません。
参考
・Azure VM Backup の 通信要件について - Azure VM Backup の 通信要件(本ページ)
https://jpabrs-scem.github.io/blog/AzureVMBackup/NWRequirementAndProcess/#1

>Q. バックアップはまだ完了していないが、 Take Snapshot が終わっていれば VM の再起動などを行ってもよいか？またTake Snapshot が終わっていればリストアすることは可能か？
>>A. Take Snapshot フェーズが完了していれば VM 内部と連携するフェーズは完了しているため、VM (OS内部) に対する変更、 VM の再起動などを行っていただいてもかまいません。
また Take Snapshot が完了していればインスタント リストア機能を用いてローカル物理ホスト上に保存されたスナップショットデータからリストアを行うことが可能です。
参考
・Take Snapshot フェーズ - Azure VM Backup の 通信要件(本ページ)
https://jpabrs-scem.github.io/blog/AzureVMBackup/NWRequirementAndProcess/#2-1


>Q. Azure VM Backup のバックアップデータ転送トラフィックが VM に与える影響を懸念しているがベストプラクティスはあるか？
>>A. Azure Backup のデータ転送は Azure のバックアップエンド側で行われ VM の 仮想 NIC を経由しないためバックアップデータ転送トラフィックが VM に与える影響はございません。
参考
・Transfer data to vaultフェーズ Azure VM Backup の 通信要件(本ページ)
https://jpabrs-scem.github.io/blog/AzureVMBackup/NWRequirementAndProcess/#2-2