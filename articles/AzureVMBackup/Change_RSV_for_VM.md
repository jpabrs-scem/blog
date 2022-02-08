---
title: Azure VM BackupにおけるRecovery Services コンテナーの変更について
date: 2022-02-09 12:00:00
tags:
  - Azure VM Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回はお問い合わせをいただくことが多い、**Azure VM Backup を取得している Recovery Services コンテナーを変更することは可能か？**について説明させていただきます。

結論から申し上げますと**可能**です。

なお、本件に関連した公式ドキュメントは下記でございます。
・Recovery Services コンテナーを作成して構成する
https://docs.microsoft.com/ja-jp/azure/backup/backup-create-rs-vault#modify-default-settings

すでにバックアップを構成している　VM に対して Recovery Services コンテナー を変更するには、VM と 既存のRecovery Services コンテナーとの紐づけを解除する必要がございます。
紐づけを解除することで、新たに別の Recovery Services コンテナーに紐づけることが可能です。

紐づけを解除する方法としては 後述の通り２ 種類ございます。

## 目次
1.既存のバックアップデータを維持する方法
2.既存のバックアップデータを削除する方法


### 1.既存のバックアップデータを維持する方法
 Recovery Services コンテナーと VM の紐づけはVMのリソースグループ名と VM名によってを行っています。
この方法ではその仕組みを利用、つまり対象の VM のリソースグループを変更することにより、既存の Recovery Services コンテナーとの紐づけを解除します。 
なお、リソースグループを変更し新しい Recovery Services コンテナーにてバックアップを構成した場合でも、VM のリソースグループ名を 元のリソースグループに戻した場合、既存の Recovery Services コンテナーと紐づいている状態になります。

## 注意事項
こちらの方法では対象の VM のリソースグループの変更が必要です。
・Recovery Services コンテナーを作成して構成する - Azure Backup | Microsoft Docs
	https://docs.microsoft.com/ja-jp/azure/backup/backup-create-rs-vault#must-preserve-previous-backed-up-data
"Azure VM の場合は、GRS コンテナー内の VM に対して保護を停止してデータを保持し、VM を別のリソース グループに移動してから、LRS コンテナー内の VM を保護することができます。"

## 変更手順概要
1. 古いRecovery Service コンテナーでのバックアップ停止する
2. バックアップ対象の VM のリソースグループを変更する
3. 新しいRecovery Service コンテナーにてバックアップを構成する


## 手順
0-1. Recovery Service コンテナー変更対象の VM の状態を確認 (リソースグループ : rg-1 )


 
0-2. Recovery Service コンテナー: rsv-1 にてバックアップ有効化、復旧ポイント作成済み


 
1-1. VM のバックアップを停止


 
1-2. 停止の際、バックアップデータ (復旧ポイント) の保持を選択し、理由を記入してバックアップの停止をクリック


 
1-3. バックアップの無効化完了を確認


 
(1-4) この状態では別のRecovery Service コンテナーではバックアップを有効化できません。
	(別のRecovery Service コンテナーでバックアップを有効化しようとしても対象に表示されません)


 
2-1. VM > 概要 > リソースグループ 横の移動をクリック


 
2-2. 移動させたいリソースグループを選択し、次へ
2-3. 検証が完了するのを待ち、次へ
2-4. 内容を確認し、下部チェックを選択して、移動をクリック


 
2-5. リソースグループの移動完了を確認


 
3-1. 新たにバックアップを取得したい別の Recovery Service コンテナーにて該当の VM のバックアップを有効化
	(この時点で別の Recovery Service コンテナーのバックアップ構成の仮想マシン選択欄に該当の VM が表示されるようになります)


 
3-2. 今すぐバックアップにてバックアップ完了。
新たなRecovery Service コンテナーにて問題なくバックアップできることを確認


 
(3-3) 古いRecovery Service コンテナーには過去の復旧ポイントは残存したままで、この復旧ポイントからも VM を復元することが可能です。


 
 


### 2.既存のバックアップデータを削除する方法
 既存のRecovery Services コンテナーに保存された対象 VM のバックアップデータを削除することによって、既存の Recovery Services コンテナーと対象の VM との紐づけを解除します。 


## 注意事項
こちらの方法では対象VMの 既存のバックアップデータの削除が必要です。
・Recovery Services コンテナーを作成して構成する - Azure Backup | Microsoft Docs
	https://docs.microsoft.com/ja-jp/azure/backup/backup-create-rs-vault#dont-need-to-preserve-previous-backed-up-data
"新しい LRS コンテナーのワークロードを保護するには、GRS コンテナー内の現在の保護とデータを削除し、バックアップを再構成する必要があります。"

また本作業を行う際、バックアップアラートを設定していない場合でも発砲されます。
詳細につきましては下記をご確認ください。
バックアップ アラートの通知
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor#notification-for-backup-alerts
"破壊的な操作 (データを削除して保護を停止など) が実行されると、アラートが生成され、Recovery Services コンテナー用に通知が構成されていない場合でも、サブスクリプションの所有者、管理者、共同管理者にメールが送信されます。"

## 変更手順概要
1. 古いRecovery Service コンテナーでのバックアップを停止し、バックアップデータを削除する
2. 新しいRecovery Service コンテナーにてバックアップを構成する


(手順)
0-1. Recovery Service コンテナー変更対象の VM の状態を確認 (リソースグループ : rg-1 )


 
0-2. Recovery Service コンテナー: rsv-1 にてバックアップ有効化、復旧ポイント作成済み


 
1-1. VM のバックアップを停止


 
1-2. 停止の際、バックアップデータ (復旧ポイント) の削除を選択し、理由を記入してバックアップの停止をクリック


 
1-3. この時、設定 – プロパティ > セキュリティ設定 更新 > 論理削除 が 無効 に設定されていることを確認してください。
	バックアップデータは完全に削除される必要があります。



* 論理削除状態について
論理削除状態(論理削除が有効な状態で削除した状態)では完全にバックアップデータが消えず、対象 VM と  Recovery Services コンテナーの紐づけが解除されません。その際は下記 URL を参考にして論理削除状態のバックアップアイテムを完全に削除してください。
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-security-feature-cloud#permanently-deleting-soft-deleted-backup-items 

1-4. バックアップデータの削除完了を"  Azure Portal  → 対象のRecovery Services コンテナー → バックアップアイテム → Azure Virtual Machines" から、対象のVMが表示されないことを確認します。


2-1. 新たにバックアップを取得したい別の Recovery Service コンテナーにて該当の VM のバックアップを有効化
	(この時点で別の Recovery Service コンテナーのバックアップ構成の仮想マシン選択欄に該当の VM が表示されるようになります)


 
2-2. 今すぐバックアップにてバックアップ完了。
新たなRecovery Service コンテナーにて問題なくバックアップできることを確認



-----------------------------------------------------------

まず、はじめに前提知識として Azure VM Backup ではバックアップを取得する際に下記 2 つのサブタスクがございます。
1.Take Snapshot (スナップショットの取得)
2.Transfer data to vault (Recovery Services コンテナーへの転送)
![Azure VM Backupの 2 つのサブタスク](https://user-images.githubusercontent.com/71251920/142253918-138343ac-b7dc-4a35-9e6e-180b4b5542f8.png)

## 目次
-----------------------------------------------------------
[1. サブタスク (Take Snapshot フェーズ) 確認方法](#1)
 [1-1. Azure Portal を用いたサブタスク (Take Snapshot フェーズ) 確認方法](#1-1)
 [1-2. Azure CLI を用いたサブタスク (Take Snapshot フェーズ) 確認方法](#1-2)
 [1-3. Azure PowerShell を用いたサブタスク (Take Snapshot フェーズ) 確認方法](#1-3)
[2. サブタスク (Take Snapshot フェーズ) にかかった時間を確認する方法](#2)
 [ フィードバックご協力のお願い](#2-1)
-----------------------------------------------------------

## 1. サブタスク (Take Snapshot フェーズ) 確認方法<a id="1"></a>
サブタスク確認方法は **Azure Portal で確認する方法**、および、 **Azure CLI や Azure PowerShell といった CLI を用いた方法**がございます。
今回弊社検証環境で確認結果も添えてお伝えさせていただきます。
また Recovery Services コンテナーのことを RSV と略して表記している部分がございます。

- 検証環境情報
まず、はじめに今回の検証環境の情報です。
>VM名：VM-Win10
>リソースグループ：RG-alwaysONVM
>Recovery Services コンテナー：RSV-JPE-LRS
>リソースグループ：RG-NormalTest

###  1-1. Azure Portal を用いたサブタスク (Take Snapshot フェーズ) 確認方法<a id="1-1"></a>
[対象の Recovery Services コンテナー] → 左ペインの [バックアップ ジョブ] → 対象のバックアップ ジョブの [View details] → [Sub Tasks] の手順で確認いただくことが可能です。

![Check_Subtask](https://user-images.githubusercontent.com/71251920/142235689-8f2a6b5d-44b9-47f4-80fe-571407e09e47.png)

### 1-2. Azure CLI を用いたサブタスク (Take Snapshot フェーズ) 確認方法<a id="1-2"></a>
今回は Windows の PowerShell を用いて Azure CLI を実行します。

#### 0.事前準備
　 Azure へログインします。ログインしている環境であれば不要です。
  >コマンド：` ` `az login` ` `

#### 1.バックアップ ジョブのステータス確認 (.Name 値 の取得)
  >コマンド：` ` `az backup job list --resource-group < RSV リソースグループ名> --vault-name < RSV 名> --status inprogress​ -o table` ` `
  >コマンド例：` ` `az backup job list --resource-group RG-NormalTest --vault-name RSV-JPE-LRS --status inprogress​ -o table` ` `

上記コマンドを実行いただくと実行中のバックアップ ジョブの name 値が取得できます。
 出力結果を Azure VM Backup の実行中のバックアップ ジョブに限定する場合は下記のオプションを付けることで可能です。
  >コマンド： ` ` `--backup-management-type AzureIaasVM` ` ` 


　下記例 "name" : "2a8c96f8-c282-4f62-9286-fda08088047e"
![Check_name_value](https://user-images.githubusercontent.com/71251920/142236195-c47b1fe8-73b0-401e-a050-43be7c4a35d6.png)

#### 2.サブタスク (Take Snapshot フェーズ) のステータス確認
name 値 を用いて下記のコマンドを実行することでサブタスクのステータスが確認できます。
下記例では Take Snapshot のステータスが Completed 、Transfer data to vault のステータスが InProgress 、となっており、スナップショットの取得が終わり、 Recovery Services コンテナーへの転送中であることが分かります。

>コマンド：` ` `az backup job show --name <name値> --resource-group  < RSV リソースグループ名> --vault-name  < RSV 名> --query properties.extendedInfo.tasksList -o table` ` `

>コマンド例 :` ` `az backup job show --name 2a8c96f8-c282-4f62-9286-fda08088047e --resource-group  RG-NormalTest --vault-name RSV-JPE-LRS --query properties.extendedInfo.tasksList -o table` ` `

![Check_Subtask_Azure_CLI_1](https://user-images.githubusercontent.com/71251920/142236727-60dfeae5-4960-4f91-a96e-c9d223acaff2.png)

--query オプションを付けない場合は下記の部分から確認できます。
>コマンド：` ` `az backup job show --name < name 値> --resource-group  < RSV リソースグループ名> --vault-name  < RSV 名>` ` `
>コマンド例：` ` `az backup job show --name 2a8c96f8-c282-4f62-9286-fda08088047e --resource-group  RG-NormalTest --vault-name RSV-JPE-LRS` ` `

![Check_Subtask_Azure_CLI_2](https://user-images.githubusercontent.com/71251920/142236740-9817d4cf-13a9-480b-816c-ba09e252aea6.png)

- 参考：
・Azure CLI を使用した Azure での仮想マシンのバックアップ - バックアップ ジョブを監視する
https://docs.microsoft.com/ja-jp/azure/backup/quick-backup-vm-cli#monitor-the-backup-job
・az backup job - az backup job list
https://docs.microsoft.com/ja-jp/cli/azure/backup/job?view=azure-cli-latest#az_backup_job_list
・JMESPath クエリを使用して Azure CLI コマンドの出力に対してクエリを実行する方法 - 辞書のプロパティを取得する(--query オプションに関する参考情報)
https://docs.microsoft.com/ja-jp/cli/azure/query-azure-cli#get-properties-in-a-dictionary

### 1-3. Azure PowerShell を用いたサブタスク (Take Snapshot フェーズ) 確認方法<a id="1-3"></a>
今回は Windows の PowerShell を用いて Azure PowerShell を実行します。

#### 0.事前準備
　 Azure へログインします。ログインしている環境であれば不要です。
  >コマンド：` ` `Connect-AzAccount` ` `　　

#### 1.定数を設定します。
>コマンド：` ` `$Vault = Get-AzRecoveryServicesVault -Name "< RSV 名>"` ` `
>コマンド例：` ` `$Vault = Get-AzRecoveryServicesVault -Name "RSV-JPE-LRS"` ` `

>コマンド：` ` `$VMName = "< VM 名>"` ` `
>コマンド例：` ` `$VMName = "VM-Win10"` ` `

![configure_const](https://user-images.githubusercontent.com/71251920/142237893-8c25f4e9-4db1-4da5-b27b-7f33160e893a.png)

#### 2.バックアップ ジョブのステータス確認<a id="a"></a>　
下記コマンドを実行することで、指定した VM の実行中のバックアップ ジョブの一覧が確認できます。
下記例では1つしかないため、$Jobs[0] に実行中のバックアップ ジョブの情報が格納されます。
複数ある場合は直近に実行されたものから若い番号に格納されます。

>コマンド：
>` ` `$Jobs = (Get-AzRecoveryservicesBackupJob -Status "InProgress" -VaultId $Vault.id | ? {$_.WorkloadName -eq $vmName})` ` `
>` ` `$Jobs` ` `

![Check_job_status_ps_1](https://user-images.githubusercontent.com/71251920/142238480-a33273d9-7e95-43e0-b23a-451b947fd4f3.png)

>コマンド：` ` `$Jobs[0]` ` `

![Check_job_status_ps_2](https://user-images.githubusercontent.com/71251920/142238471-c9927a38-86e5-4a5d-9140-dee620472a93.png)

#### 3．実行中のバックアップ ジョブのサブタスクを取得・表示
下記コマンドを実行することでサブタスクのステータスが確認できます。
下記例では、Take Snapshot は Completed、Transfer data to vault は InProgress 、となっており、スナップショットの取得が終わり、 Recovery Services コンテナーへの転送中であることが分かります。

>コマンド：
>` ` `$SubTasks = Get-AzRecoveryServicesBackupJobDetail -Job $Jobs[0]  -VaultId $Vault.id` ` `
>` ` `$SubTasks.subtasks` ` `

![Check_sub_task_ps_1](https://user-images.githubusercontent.com/71251920/142249583-ef423e62-9bef-4352-bc34-6a87edf18b4a.png)

上記警告については、現在使用可能な ”Get-AzRecoveryServicesBackupJobDetail” のエイリアス ”Get-AzRecoveryServicesBackupJobDetails” が将来的に廃止されていることを示しますが、上記のコマンドであれば使用していないので無視していただいて構いません。

また下記コマンドを実行していただくことで警告を表示させないことが可能です。
>コマンド：` ` `Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"` ` `

上記のコマンドを実行したところ警告が出ていないことが分かります。

![Check_sub_task_ps_2](https://user-images.githubusercontent.com/71251920/142249588-14b3aca1-3e4d-4948-81a9-b874ec1b5dc1.png)

・How do I get rid of the warnings? (警告の非表示について)
https://github.com/Azure/azure-powershell/blob/main/documentation/breaking-changes/breaking-changes-messages-help.md#how-do-i-get-rid-of-the-warnings

#### 補足
なお、[2.バックアップ ジョブのステータス確認](#a) で下記のように　VM 名を指定しない場合、その他の実行中のバックアップ ジョブも表示されます。(実行中のその他の VM がある場合)
>コマンド：
>` ` `$Jobs = Get-AzRecoveryservicesBackupJob -Status "InProgress" -VaultId $Vault.id` ` `
>` ` `$Jobs` ` `

その際の $Jobs[0]、$Jobs[1] の値は次のようになります。
![Check_job_status_ps_3](https://user-images.githubusercontent.com/71251920/142242086-55eda1c2-5509-4bac-9c5c-c7d1b64c3401.png)

- 参考：
・APowerShell を使用して Azure VM をバックアップおよび復元する - バックアップ ジョブの監視
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-automation#monitoring-a-backup-job
・Get-AzRecoveryServicesBackupJob
https://docs.microsoft.com/ja-jp/powershell/module/az.recoveryservices/get-azrecoveryservicesbackupjob?view=azps-6.6.0


## 2. サブタスク (Take Snapshot フェーズ) にかかった時間を確認する方法 <a id="2"></a>
お客様では Azure Portal、およびコマンド (Azure CLI 、Azure PowerShell) を用いても残念ながらサブタスク (Take Snapshot フェーズ) にかかった時間を確認できません。
しかし、お問い合わせいただくことで弊社にてお客様環境の実績値をお調べしお伝えすることが可能です。
その際には下記情報を添えてお問い合わせいただきますようお願いいたします。
　・サブスクリプション ID 
　・VM 名およびそのリソースグループ名
　・Recovery Services コンテナー 名およびそのリソースグループ名

また、今後のバックアップ ジョブであれば、[1. サブタスク (Take Snapshot フェーズ) 確認方法](#1)を参考にしていただくことでおおよそ可能かと存じます。
具体的には、実行中のバックアップ ジョブを検知し、ループを回して定期的に対象のサブタスク (Take Snapshot フェーズ等) のステータスを確認し、Inprogress である間の時間を計測していただくことでおおよその時間を測定いただければと存じます。
なお、具体的な実装につきましては、恐縮ながら Azure サポートサービスの範囲外であるためお客様ご自身でご実装いただきますようお願いいたします。

#### フィードバックご協力のお願い<a id="2-1"></a>
現在、Azure Portal から Take Snapshot にかかった時間を表示できるように弊社開発部門へのフィードバックが行われております。
お客様側では以下のサイトを通じてステータスを確認することが可能です。
 
・Visualize what time "Take snapshot" is completed in Azure portal
https://feedback.azure.com/d365community/idea/ff50fa2f-785d-ec11-a819-0022484e8090
 
上記サイトは機能改善のリクエストを行うサイトであり、リクエストの中で Vote (改善要望) が多いものや影響度の大きいものを判断して優先して修正に取り組みます。
そのため、もし、Azure Portal から Take Snapshot にかかった時間を表示できるようご要望の場合には、お手数ではございますが可能であれば上記の URL より機能改善リクエストに Vote いただけますと幸いです。
Vote の際にはメールアドレスを入力することができ、本投稿が Completed した際に指定のメールアドレスに通知される仕組みとなっております。