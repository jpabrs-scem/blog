---
title: Azure VM BackupにおけるRecovery Services コンテナーの変更について
date: 2023-06-08 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートです。
今回はお問い合わせをいただくことが多い、**Azure VM Backup を取得している Recovery Services コンテナーを変更することは可能か？**について説明させていただきます。

なんらかのバックアップ構成を行ったあとは、Recovery Services コンテナー上の冗長性の変更をいただくことが出来ないため、 Recovery Services コンテナー自体を変更いただく必要がございます。
ただし、CRR の「無効化」→「有効化」への切り替えのみは、バックアップ アイテムを保護した後でも変更が可能です。

・ストレージ冗長性の設定
　https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#set-storage-redundancy
>コンテナーでバックアップを構成する前に、必ず Recovery Services コンテナーのストレージ レプリケーションの種類を変更してください。 バックアップを構成した後、変更するオプションは無効になります。


結論から申し上げますと **Recovery Services コンテナーを変更することは可能**です。


なお、本件に関連した公式ドキュメントは下記でございます。
・Recovery Services コンテナーを作成して構成する - 既定の設定を変更する
  https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#modify-default-settings

すでにバックアップを構成している　VM に対して Recovery Services コンテナー を変更するには、VM と 既存のRecovery Services コンテナーとの紐づけを解除する必要がございます。
紐づけを解除することで、新たに別の Recovery Services コンテナーに紐づけることが可能です。

紐づけを解除する方法としては 後述の通り ２ 種類ございます。

## 目次
-----------------------------------------------------------
[1. 既存のバックアップデータを [維持] する方法](#1)
 [ 1.1 注意事項](#1-1)
 [ 1.2 変更手順概要](#1-2)
 [ 1.3 手順](#1-3)
[2. 既存のバックアップデータを [削除] する方法](#2)
 [ 2.1 注意事項](#2-1)
 [ 2.2 変更手順概要](#2-2)
 [ 2.3 手順](#2-3)
 [ 2.3.1 論理削除状態について](#2-3-1)
[3. (補足) バックアップデータを残しつつリソースグループを変更しない方法](#3)
 [ 3.1 手順](#3-1)
-----------------------------------------------------------

## 1. 既存のバックアップデータを [維持] する方法<a id="1"></a>
 Recovery Services コンテナーと VM の紐づけは VM のリソースグループ名と VM 名によって行っています。
この方法では対象の VM のリソースグループを変更することにより、既存の Recovery Services コンテナーとの紐づけを解除します。 
なお、リソースグループを変更し新しい Recovery Services コンテナーにてバックアップを構成した場合でも、VM のリソースグループ名を 元のリソースグループに戻した場合、既存の Recovery Services コンテナーと紐づいている状態になります。

### 1.1 注意事項<a id="1-1"></a>
こちらの方法では対象の VM のリソースグループの変更が必要です。
・Recovery Services コンテナーを作成して構成する
	https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#must-preserve-previous-backed-up-data
> Azure VM の場合は、GRS コンテナー内の VM に対して保護を停止してデータを保持し、VM を別のリソース グループに移動してから、LRS コンテナー内の VM を保護することができます。

Recovery Services コンテナー変更のために、リソース グループの変更が必要なものは、「Azure VM」リソースのみで、VM にアタッチされているディスクや NIC のリソース グループを変更する必要はございません。
お客様の管理上、VM にアタッチされているディスクも含めてリソース グループを変更されたい場合、Azure VM Backup にて取得した復元ポイント コレクションが存在している状態では、アタッチされているディスクのリソース グループの変更がかないません。
もし、Azure VM Backup にてバックアップ構成している VM にアタッチされているディスクのリソース グループを変更されたい場合は、Azure ポータル画面 ＞ 復元ポイント コレクションへ移動し、対象 VM の復元ポイント コレクションを削除すれば、ディスクのリソース グループを変更することができます。
ただし、復元ポイント コレクションを削除した場合は、スナップショット層に格納されている復元ポイントを削除することになりますので、削除した復元ポイントについては、インスタント リストア機能による「復元」ができなくなります。（Recovery Services コンテナー層からの復元のみとなります。）
また、回復の種類が "スナップショット" のみの復元ポイントがある場合に復元ポイント コレクションを削除した場合には、該当の復元ポイントより復元ができなくなりますのでご留意ください。（回復の種類が "スナップショットと標準コンテナー"、"標準コンテナー" となっている復元ポイントに関しては、Recovery Services コンテナー層からの復元は可能でございます）

### 1.2 変更手順概要<a id="1-2"></a>
1. 古いRecovery Services コンテナーでのバックアップ停止する
2. バックアップ対象の VM のリソースグループを変更する
3. 新しいRecovery Services コンテナーにてバックアップを構成する


### 1.3 手順<a id="1-3"></a>
0-1. Recovery Services コンテナー変更対象の VM の状態を確認 (リソースグループ : rg-1 )
![Change_RSV_for_VM_01](./Change_RSV_for_VM/Change_RSV_for_VM_01.png)

 
0-2. Recovery Services コンテナー: rsv-1 にてバックアップ有効化、復元ポイント作成済み
![Change_RSV_for_VM_02](./Change_RSV_for_VM/Change_RSV_for_VM_02.png)

 
1-1. VM のバックアップを停止
![Change_RSV_for_VM_03](./Change_RSV_for_VM/Change_RSV_for_VM_03.png)

 
1-2. 停止の際、バックアップデータ (復元ポイント) の保持を選択し、理由を記入してバックアップの停止をクリック
![Change_RSV_for_VM_04](./Change_RSV_for_VM/Change_RSV_for_VM_04.png)

 
1-3. バックアップの無効化完了を確認

1-4. この状態ではまだ別のRecovery Services コンテナーにて「バックアップの有効化」を試みても、VM が対象として表示されません
![Change_RSV_for_VM_06](./Change_RSV_for_VM/Change_RSV_for_VM_05.png)

 
2-1. VM > 概要 > リソースグループ 横の移動をクリック
![Change_RSV_for_VM_07](./Change_RSV_for_VM/Change_RSV_for_VM_06.png)

 
2-2. 移動させたいリソースグループを選択し、次へ
2-3. 検証が完了するのを待ち、次へ
2-4. 内容を確認し、下部チェックを選択して、移動をクリック
![Change_RSV_for_VM_08](./Change_RSV_for_VM/Change_RSV_for_VM_07.png)

 
2-5. リソースグループの移動完了を確認
![Change_RSV_for_VM_09](./Change_RSV_for_VM/Change_RSV_for_VM_08.png)

 
3-1. 新たにバックアップを取得したい別の Recovery Services コンテナーにて該当の VM のバックアップを有効化
	(この時点で別の Recovery Services コンテナーのバックアップ構成の仮想マシン選択欄に該当の VM が表示されるようになります)
![Change_RSV_for_VM_10](./Change_RSV_for_VM/Change_RSV_for_VM_09.png)

 
3-2. 今すぐバックアップにてバックアップ完了。
新たなRecovery Services コンテナーにて問題なくバックアップできることを確認

![Change_RSV_for_VM_11](./Change_RSV_for_VM/Change_RSV_for_VM_10.png)
 
3-3. 古いRecovery Services コンテナーには過去の復元ポイントは残存したままで、この復元ポイントからも VM を復元することが可能です。
![Change_RSV_for_VM_12](./Change_RSV_for_VM/Change_RSV_for_VM_11.png)


## 2. 既存のバックアップデータを [削除] する方法<a id="2"></a>
 既存の Recovery Services コンテナーに保存された対象 VM のバックアップデータを削除することによって、既存の Recovery Services コンテナーと対象の VM との紐づけを解除します。 

### 2.1 注意事項<a id="2-1"></a>
こちらの方法では対象 VMの 既存のバックアップデータの削除が必要です。
・Recovery Services コンテナーを作成して構成する
　https://learn.microsoft.com/ja-jp/azure/backup/backup-create-recovery-services-vault#dont-need-to-preserve-previous-backed-up-data
> 新しい LRS コンテナーのワークロードを保護するには、GRS コンテナー内の現在の保護とデータを削除し、バックアップを再構成する必要があります。

また本作業を行う際、バックアップアラートを設定していない場合でも発砲されます。
詳細につきましては下記をご確認ください。
・バックアップ アラートの通知
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor?tabs=recovery-services-vaults#notification-for-backup-alerts
> "破壊的な操作 (データを削除して保護を停止など) が実行されると、アラートが生成され、Recovery Services コンテナー用に通知が構成されていない場合でも、サブスクリプションの所有者、管理者、共同管理者にメールが送信されます。

### 2.2 変更手順概要<a id="2-2"></a>
1. 古いRecovery Services コンテナーでのバックアップを停止し、バックアップ データを削除する
2. 新しいRecovery Services コンテナーにてバックアップを構成する

### 2.3 手順<a id="2-3"></a>
0-1. Recovery Services コンテナー変更対象の VM の状態を確認 (リソースグループ : rg-1 )
![Change_RSV_for_VM_13](./Change_RSV_for_VM/Change_RSV_for_VM_12.png)

0-2. Recovery Services コンテナー: rsv-1 にてバックアップ有効化、復元ポイント作成済み
![Change_RSV_for_VM_14](./Change_RSV_for_VM/Change_RSV_for_VM_13.png)

1-1. 復元ポイントを即時に削除するために、一時的に「論理削除」設定を無効化します。
Recovery Services コンテナー > プロパティ > セキュリティ設定 更新 へと移動し
下記チェックボックスを一時的に「チェック OFF」へと変更しておきます。

・クラウド ワークロードの論理的な削除を有効にする

![Change_RSV_for_VM_17](./Change_RSV_for_VM/Change_RSV_for_VM_14.png)

* 注意事項： 論理削除状態について<a id="2-3-1"></a>
論理削除状態 (論理削除が有効な状態で削除した状態) では完全にバックアップデータが消えず、対象 VM と  Recovery Services コンテナーの紐づけが解除されません。その際は下記 URL を参考にして論理削除状態のバックアップアイテムを完全に削除してください。

・論理的に削除されたバックアップ項目を完全に削除する
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-security-feature-cloud#permanently-deleting-soft-deleted-backup-items

1-2. VM のバックアップを停止
![Change_RSV_for_VM_15](./Change_RSV_for_VM/Change_RSV_for_VM_15.png)
 
1-3. 停止の際、バックアップデータ (復元ポイント) の削除を選択し、理由を記入してバックアップの停止をクリック
![Change_RSV_for_VM_16](./Change_RSV_for_VM/Change_RSV_for_VM_16.png)

1-5. バックアップデータの削除完了を"  Azure Portal > 対象のRecovery Services コンテナー > バックアップアイテム > Azure Virtual Machines" から、対象のVMが表示されないことを確認します。


2-1. 新たにバックアップを取得したい別の Recovery Servics コンテナーにて該当の VM のバックアップを有効化
	(この時点で別の Recovery Services コンテナーのバックアップ構成の仮想マシン選択欄に該当の VM が表示されるようになります)
![Change_RSV_for_VM_18](./Change_RSV_for_VM/Change_RSV_for_VM_17.png)
 
2-2. 今すぐバックアップにてバックアップ完了。
新たなRecovery Services コンテナーにて問題なくバックアップできることを確認
![Change_RSV_for_VM_19](./Change_RSV_for_VM/Change_RSV_for_VM_18.png)

2-3. 古い Recovery Services コンテナー上で「チェック OFF」としていた、下記項目をもとの設定値に戻します。
Recovery Services コンテナー > プロパティ > セキュリティ設定 更新 > 「クラウド ワークロードの論理的な削除を有効にする」


## 3. (補足) バックアップデータを残しつつリソースグループを変更しない方法<a id="3"></a>
**バックアップ データは残したまま＋ VM のリソースグループを変更しない ＋ 新しい Recovery Services コンテナーに紐づける　ということはこれまで説明した通りかないません**
[1. 既存のバックアップデータを [維持] する方法](#1) によって変更後、リソース グループを戻してしまうと、古い Recovery Services コンテナーが残っている場合には、古い Recovery Services コンテナー側にて再度紐づいてしまいます。
また、もとの Recovery Services コンテナーが削除された場合には新しい Recovery Services コンテナーとの紐づけが切れ、 Azure VM のバックアップメニューからはバックアップが構成されていない状態になります。

そのため方法としては、**既存のバックアップデータを一度ディスクとして復元して保存いただくことで可能です**。
特定の復元ポイントだけを保存しておけばよいという場合はこちらの方法をご検討ください。
もちろん、すべての復元ポイントからディスクとして復元いただければ、すべての バックアップデータを保存することは可能です。

具体的な手順としては下記です。
#### 手順<a id="3-1"></a>
1. 保存したい復元ポイントからディスクとしてリストアする。
詳細は下記をご覧ください
・代替案 - Azure VM Backup で取得した復旧ポイントの保持期間の延長について
　https://jpabrs-scem.github.io/blog/AzureVMBackup/HowToExtendVMRetentionPeriod/#4


2. その後 上述の[2. 既存のバックアップデータを [削除] する方法](#2)によって Recovery Services コンテナーを変更する。
-----------------------------------------------------------
