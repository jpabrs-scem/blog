---
title: Azure VM のリストアの際 NIC の設定が消えてしまう
date: 2021-10-20 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回はお問い合わせをいただくことが多い、Azure VM のリストアの際 NIC の設定が消えてしまうというお問い合わせについて解説させていただきます。

こちら結論から申し上げますと、**Azure VM Backupのリストアメニューにて、[新規VMの作成] を選んだ際、デフォルトで NIC が新たに作成され (設定できない) アタッチされるため、復元時に NIC の情報が消えてしまうのは仕様**となっております。
Azure VM Backup ではディスクの情報をバックアップしますが、NIC の情報はバックアップいたしません。
なお、リストアメニューにて [既存の置き換え] を選択された場合は VM のディスクのみを入れ替え (スワップ) 、NIC はそのまま利用されるため、NIC の設定が消えるようなことは起こりません。
以下の代替案をお伝えさせいただきます。


## 代替案
-----------------------------------------------------------
[1. 既存のパブリック IP を設定する場合](#1)
[2. 既存の NIC を設定する場合](#2)
-----------------------------------------------------------

### <a id="1"></a> 1. 既存のパブリック IP を設定する場合
既存のパブリック IP を設定する場合には次のような代替案がございます。
(手順1) Azure VM バックアップのリストア メニューからディスクとして一旦復元する。
(手順2) ディスクから VM を作成する。
	  その際に既存のパブリック IP を選択する。
	　データディスクがある場合は復元したディスクを選択しアタッチする。(LUN 番号が入れ替わらないようにご注意ください)

(手順2) に関しましては、 Azure Portal からの操作の場合、下記のような手順で可能でございます。
NIC を指定できることが分かります。
![DiskからのVM作成](./VMRestoring_NIC_Configuration/VMRestoring_NIC_Configuration_01.png)


### <a id="2"></a> 2. 既存の NIC を設定する場合
(手順1) Azure VM バックアップのリストア メニューからディスクとして一旦復元する。
(手順2) Azure PowerShellを用いてディスクからの VM 作成時に利用する既存の NIC を指定して作成する。
・既存の "ディスク" リソースを使用し、仮想マシンを作成する。
https://docs.microsoft.com/ja-jp/archive/blogs/jpaztech/convertvhdtomanageddiskdeployvm#2

※上記リンクのコマンドは **AzureRm** で記載されてますが、Azモジュールをご利用の場合は 以下の例のように **Az** に変換して実行ください。
※また可用性セット(VMSS) の設定もAzure VM Backupのリストアメニューでは設定できないので、この場合も本手順を参考に一度ディスクとして復元していただき、 VM を作成する際に可用性セットの設定をしていただければと思います。
　　　
>#ログインとサブスクリプション指定
Login-**AzureRm**Account →　Login-**Az**Account
Select-**AzureRm**Subscription -SubscriptionId $SubscriptionId　→　Select-**Az**Subscription -SubscriptionId $SubscriptionId

上記の URL 先の $NIC = New-AzNetworkInterface ($NIC = New-AzureRmNetworkInterface) にて新規 VM を作成する際の NIC を指定することができます。
既存の NIC を追加するには下記コマンドをご利用ください。

>#既存の NIC を追加
$Nic = Get-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Name $NicName
$Vm = Add-AzVMNetworkInterface -VM $Vm -NetworkInterface $Nic

*リストアされるディスクの命名規則については参考情報のリンク先をご覧ください。

### 参考情報
・Azure VM Backupでリストアされるディスク名に関して
https://jpabrs-scem.github.io/blog/AzureVMBackup/About_Restored_Disk/
・Azure portal で Azure VM データを復元する方法 - ディスクを復元する
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-disks


