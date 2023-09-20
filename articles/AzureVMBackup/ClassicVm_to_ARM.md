---
title: バックアップしているクラシック VM を ARM VM へ移行する際の注意点
date: 2023-09-27 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Backup サポートです。
今回は、Azure VM Backup にて、もともとクラシック VM ( = Azure Service Manager (ASM) を介した IaaS 仮想マシン) をバックアップしている場合に、ARM (Azure Resource Manager) VM へと移行する場合の注意点をお伝えします。

## 目次
-----------------------------------------------------------
[1. はじめに : Azure のクラシック VM は 2023 年 9 月 6 日を持ちまして廃止となりました](#1)
[2. バックアップしているクラシック VM を ARM VM へ移行する際の注意点](#2)
-----------------------------------------------------------

### <a id="1"></a>1. はじめに : Azure のクラシック VM は 2023 年 9 月 6 日を持ちまして廃止となりました
Azure のクラシック VM は 2023 年 9 月 6 日を持ちまして廃止となりました。
そのためこれ以降サポートされる VM は ARM の Azure VM となります。
クラシック VM の ARM VM への移行詳細については以下の通りドキュメント等がございます。

・(参考 公開ドキュメント) 2023 年 9 月 6 日までに IaaS リソースを Azure Resource Manager に移行する
　https://learn.microsoft.com/ja-jp/azure/virtual-machines/classic-vm-deprecation

・(参考 弊社ブログ) Classic VM から ARM への移行についての注意事項 (VM、ストレージ編) | Japan Azure IaaS Core Support Blog (jpaztech.github.io)
　https://jpaztech.github.io/blog/vm/migrate_classic_vm_and_storage/

・(参考 弊社ブログ) クラシック VM で使用していた VHD から ARM VM を作成する手順 | Japan Azure IaaS Core Support Blog (jpaztech.github.io)
　https://jpaztech.github.io/blog/vm/classic-vhd-to-arm-vm/


### <a id="2"></a>2. バックアップしているクラシック VM を ARM VM へ移行する際の注意点
### ポイント
- ARM 移行作業を行う前に、一度「バックアップ データの保持」「バックアップの停止」を行ってください
- ARM 移行後、再度「バックアップの有効化」を行ってください
- クラシック VM にこれまで対応していたストレージとネットワークの情報も ARM へと移行ください

下記ドキュメントの説明もご一読ください。

・クラシック VM をコンテナーにバックアップしてあります。 クラシック モードから Resource Manager モードに VM を移行して、Recovery Services コンテナーで保護することはできますか。
　https://learn.microsoft.com/ja-jp/azure/virtual-machines/migration-classic-resource-manager-faq#------vm----------------------------------resource-manager------vm-------recovery-services--------------------

・クラシック VM とクラシック ストレージ アカウントが廃止されたら、クラシック VM のバックアップはどのように復元できますか?
　https://learn.microsoft.com/ja-jp/azure/virtual-machines/migration-classic-resource-manager-faq#------vm---------------------------------vm----------------------


#### (事例) Azure VM 自体は ARM へ移行したが、VM にアタッチされているディスクのストレージ アカウントがクラシック ストレージ アカウントのままである
このような場合、Azure VM を再度「バックアップの有効化」しようとしても、失敗します。

(「バックアップの有効化」デプロイ エラー メッセージ例)
'The resource write operation failed to complete successfully, because it reached terminal provisioning state 'Failed'.'

Azure VM Backup では、クラシック デプロイ モデルのストレージ アカウントで構成された ARM Azure VM のバックアップをサポートしておりませんので、ストレージ アカウントを ARM へ移行ください。
・ストレージ アカウントの移行
　https://learn.microsoft.com/ja-jp/azure/virtual-machines/migration-classic-resource-manager-overview#migration-of-storage-accounts


バックアップしているクラシック VM を ARM VM へ移行する際の注意点について、ご案内は以上となります。