---
title: Azure VM Backup の クロスリージョン リストア をした際に Error Code ”UserErrorVmProvisioningFailedDueToLackOfResources” で失敗する。
date: 2021-10-22 12:00:00
tags:
  - Azure VM Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回はお問い合わせをいただくことが多い、 **"クロスリージョン リストア を実施した際にセカンダリ リージョン (ペアリージョン) へリストアできない、Error Code : serErrorVmProvisioningFailedDueToLackOfResources で失敗する"** といったお問い合わせについて解説させていただきます。
*プライマリリージョンが東日本リージョンの場合、セカンダリリージョンは西日本リージョンとなります。
結論から申し上げますと、**対象の VM が東日本リージョンでは 対応しているが、西日本リージョンでは対応していない VM Size であること**が原因でございます。
*また、セカンダリリージョンの CPU クオーター制限には抵触していないことが前提でございます。

ペアリージョンの関係は下記をご確認いただければ幸いです。
・ビジネス継続性とディザスター リカバリー (BCDR):Azure のペアになっているリージョン - Azure リージョン ペア
https://docs.microsoft.com/ja-jp/azure/best-practices-availability-paired-regions#azure-regional-pairs


### 本事象の場合に発生する Error Code 

-----------------------------------------------------------
**[Error code]**
UserErrorVmProvisioningFailedDueToLackOfResources
**[Warning message]**
Failed in provisioning the restored VM due to insufficient capacity for the requested VM size in this region.
**[Recommended action]**
Read more about improving likelihood of provisioning success at http://aka.ms/allocation-guidance. Alternatively try restoring disks to a storage account and then create a VM
-----------------------------------------------------------

### 具体的な問題が起こるシナリオ
例えば、東日本リージョンで Standard E4as_v4 の VM のバックアップを取得しており、クロスリージョン リストアにて西日本リージョンで新規 VM の作成を行う場合に発生いたします。

### 原因
原因としましては、**対象の VM が東日本リージョンでは 対応しているが、西日本リージョンでは対応していない VM Size であること**が原因でございます。 

下記 URL からリージョンごとにおける VM の対応状況が分かります。
今回の Standard E4as_v4の場合、東日本リージョン (Japan East) ではサポートされているが 、西日本リージョン (Japan West) ではサポートされていないことが分かります。
下記の URL の通り、東日本リージョン (Japan East) ではサポートされているが 、西日本リージョン (Japan West) ではサポートされていない VM Size が複数ございます。
・Products available by region( Virtual Machines)
https://azure.microsoft.com/en-us/global-infrastructure/services/?products=virtual-machines&regions=non-regional,us-east,us-east-2,us-central,us-north-central,us-south-central,us-west-central,us-west,us-west-2,japan-east,japan-west
 
![VM Size_Region_Compatibility](https://user-images.githubusercontent.com/71251920/138295057-8819eb23-3029-403d-9d87-f764ce7b026c.jpg)




### 回避策
上記の原因の場合、以下の 2 通りの対応策が考えられます。
1.ペアリージョンの両方でサポートされている VM Size を利用する。
2.一度 クロスリージョン リストア にて ”ディスクの復元” (VMの作成ではなく) をしていただき、ディスクから VM を作成し、その際に VM Size を変更する。
データディスクがある場合は復元したディスクを選択しアタッチする。(LUN 番号が入れ替わらないようにご注意ください)

下記弊社検証環境での画面ショットです。
ディスクから作成することで、下記のように VM Size を変更することが可能です。
また、ＶＭ Size に加えて NIC なども設定することが可能です。

![DIskからのVM作成(VM Size Change)](https://user-images.githubusercontent.com/71251920/138295033-694d40b5-8e4e-4366-8f01-b91db652a38e.png)

 
### <リストアされたディスク命名規則について>
ディスクの復元が完了しますとリソース グループに OS ディスクとデータ ディスク (ある場合) が以下の命名規則で作成されます。

>    <VM名> - osdisk - yyyymmdd - hhmmss
>    <VM名> - datadisk - <lun 番号> - yyyymmdd – hhmmss


なお、VM 名に - が入っている場合には省略されます。
例えば、Windows2019-Disk-Test という VM 名の場合は下記のディスク名で復元されます。
　　　
>windows2019disktest-osdisk–20210414-125726

### 参考情報
ディスクからの VM 作成に関して下記、弊社が公開している技術情報に手順がございます。
・ディスクからの VM の作成
https://docs.microsoft.com/ja-jp/azure/virtual-machines/windows/create-vm-specialized-portal#create-a-vm-from-a-disk

