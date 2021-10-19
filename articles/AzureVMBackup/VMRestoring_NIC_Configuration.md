---
title: Azure VM のリストアの際 NIC の設定が消えてしまう
date: 2021-10-20 12:00:00
tags:
  - Azure VM Backup
disableDisclaimer: false
---

<!-- more -->
####  Azure VM のリストアの際 NIC の設定が消えてしまう
皆様こんにちは。Azure Backup サポートの山本です。
今回はお問い合わせをいただくことが多い、Azure VM のリストアの際 NIC の設定が消えてしまうというお問い合わせについて解説させていただきます。

こちら結論から申し上げますと、Azure VM Backupのリストアメニューにて、[新規VMの作成] を選んだ際、デフォルトで NIC が新たに作成され (設定できない) アタッチされるため、復元時に NIC の情報が消えてしまうのは仕様となっております。
Azure VM Backup ではディスクの情報をバックアップしますが、NIC の情報はバックアップいたしません。
なお、リストアメニューにて [既存の置き換え] を選択された場合は VM のディスクのみを入れ替え (スワップ) 、NIC はそのまま利用されるため、NIC の設定が消えるようなことは起こりません。


### 代替案
次のような代替案がございます。
(手順１) Azure VM バックアップのリストア メニューからディスクとして一旦復元する。
(手順２) ディスクから VM を作成する。
	  その際に既存の任意の設定をいれた NIC を選択する。
	　データディスクがある場合は復元したディスクを選択しアタッチする。(LUN 番号が入れ替わらないようにご注意ください)

(手順２) に関しましては、 Azure Portal からの操作の場合、下記のような手順で可能でございます。
NIC を指定できることが分かります。
![DiskからのVM作成](https://user-images.githubusercontent.com/71251920/137943407-1dad9711-f799-4921-9365-17f1ac006f3b.png)


### <リストアされたディスク命名規則について>
ディスクの復元が完了しますとリソース グループに OS ディスクとデータ ディスク (ある場合) が以下の命名規則で作成されます。
` ` ` 
     <VM名> - osdisk – yyyymmdd - hhmmss
` ` ` 
` ` ` 
     <VM名> - datadisk - <lun 番号> - yyyymmdd – hhmmss
` ` ` 

なお、VM 名に - が入っている場合には省略されます。
例えば、Windows2019-Disk-Test という VM 名の場合は下記のディスク名で復元されます。
` ` `  　　　　
     Windows2019DiskTest-osdisk–20210414-125726
` ` ` 

### 参考情報
・Azure portal で Azure VM データを復元する方法 - ディスクを復元する
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms#restore-disks


