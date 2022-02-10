---
title: Azure VM Backupにおける整合性について
date: 2022-02-11 12:00:00
tags:
  - Azure VM Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは。Azure Backup サポートの山本です。
今回は Azure VM Backup における整合性について関して具体例をも踏まえつつご説明させていただきます。

まず、Azure VM Backup における整合性は下記の３種類ございます。
・アプリケーション整合性 (Application-consistent)
![](https://user-images.githubusercontent.com/71251920/137937912-912a42c1-f750-4c8b-a157-6a3db50f11c7.png)


・ファイルシステム整合性 (File-system consistent)
![](https://user-images.githubusercontent.com/71251920/137937882-bb5ea0da-be8a-451c-bd3a-a24c4a8070c4.png)


・クラッシュ整合性 (Crash-consistent)
![](https://user-images.githubusercontent.com/71251920/137937936-0d85b5e6-7bb8-4131-9553-ec7c9e0e0d58.png)

なお、公開情報は下記にございますのでまず一度ご一読ください。
その前提で説明させていただきます。

- 参考
・Azure VM バックアップの概要 スナップショットの整合性
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-consistency



## 目次
-----------------------------------------------------------
[1. アプリケーション整合性](#1)
[  1.1 VSS 観点での調査について](#1-1)
[  1.2  SQL サーバーのインストールされた Windows OS のバックアップについて](#1-2)
[  1.3  Oracle DB for Windows VM の Azure VM Backup について](#1-1)
[  1.4  事前事後スクリプトについて](#1-4)
[2. ファイルシステム整合性](#2)
[3. クラッシュ整合性](#3)

-----------------------------------------------------------

## 1. アプリケーション整合性<a id="1"></a>
こちらAzure VM Backupにおける最も上位の整合性でございます。
Windows OS のバックアップを取得した場合や事前事後スクリプトを設定した Linux OS でオンライン バックアップを取得した場合にアプリケーション整合性となります。
なお、Windows OS の場合は VSS (ボリューム シャドウ コピー サービス) との連携によりアプリケーション整合性を取得するのみであり、Linux OS のような事前事後スクリプトの準備はございません。

Azure Portal 上の表示では、Windows OS の場合は VSS (VSS ライター) が正常に稼働すればアプリケーション整合性となり、Linux VM の場合は事前事後スクリプトが正常に完了すればアプリケーション整合性となります。
つまり、VSS に対応していないアプリケーションをご利用の場合は該当アプリケーションに対する整合性はないですが、 Azure Portal では対象のアプリケーションを検知することが出来ないため Azure Portal 上の表示はアプリケーション整合性となります。

また、**ご利用のアプリケーション整合性が VSS に対応しているかは各アプリケーションの提供元ベンダーまでお問い合わせいただきますようお願いします。**

- 参考
・ボリューム シャドウ コピー サービスの仕組み
https://docs.microsoft.com/ja-jp/windows-server/storage/file-server/volume-shadow-copy-service#how-volume-shadow-copy-service-work
 >Microsoft 以外の VSS ライターは、バックアップ中のデータの整合性を保証する必要がある Windows 用の多くのアプリケーションに含まれています。

### 1.1 VSS 観点での調査について<a id="1-1"></a>
よくあるお問い合わせとして、以下のようなものがございます。
まず、Azure Backup チームでは VSS 関連の障害調査に関しては  VSS および 特定の VSS ライターに不調があるというころまでが調査可能です。
なぜ "VSS および 特定の VSS ライターに不調が起きたのか" に関する根本原因についてはお客様の契約次第では、 オンプレミス チームでの有償対応が必要となることがございます。
また切り分けの結果、他社製品のアプリケーションの VSS ライターの不具合であった場合には弊社ではサポート出来かねますので、ご利用のアプリケーション提供ベンダーまでお問い合わせいただくようお願い申し上げます。

つぎに、それぞれについて下記の通りお伝えさせていただきます。

#### ・VSS の不調 (bad state)によりAzure VM Backupが失敗する
こちら根本原因の特定には VSS 観点での調査が必要となります。
 Azure Backup チームでは 根本原因の特定については可能な範囲での調査をさせていただきます。

ご参考にまでに、下記のようなエラーが出ることがございます。
>Error Code ：Snapshot operation failed due to VSS Writers in bad state.
>Error Message ：ExtensionFailedVssWriterInBadState

 VSS 観点での調査のためには下記のログの採取をお願いします。
 **可能な限り "[A]"が望ましいですが、”[B]” でもある程度調査が可能です。**
・VSS エラーが発生している事象の調査
https://jpwinsup.github.io/mslog/storage/vss/vss-error.html


#### ・VSS ライターのエラーにより警告付き完了となる / アプリケーション整合性ではなくファイルシステム整合性となって復旧ポイントが取得されている
　調査の結果、VSS ライターのエラーを出しているアプリケーションが 弊社 SQL Server 等弊社製品の場合、は担当 チームで対応が可能でございますが、お客様の契約次第では有償対応が必要となることがございます。
　一方、VSS ライターのエラーを出しているアプリケーションが他社製品の場合、ご利用のアプリケーション提供ベンダーまでお問い合わせいただくようお願い申し上げます。

###　1.2  SQL サーバーのインストールされた Windows OS のバックアップについて<a id="1-2"></a>
こちらよくいただくお問い合わせとして次の通りお伝えします。
>・SQL サーバーのインストールされた Windows OS をAzure VM Backup でバックアップすることは可能か、また何か考慮点があるか？

こちら結論から申し上げますと、可能でございます。
SQL ライターがございますので、SQL データベースの整合性を保った VM 全体のバックアップを取得することが可能です。

考慮点としましては下記 URL をご覧ください。
- 参考
・Azure VM バックアップの概要 - スナップショットの作成
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-creation
> 既定の Azure Backup では、VSS の完全バックアップが作成されます (アプリケーション レベルで整合性のあるバックアップを取得するため、バックアップ時に、SQL Server などのアプリケーションのログは切り捨てられます)。 Azure VM バックアップで SQL Server データベースを使用している場合は、(ログを保持するため) VSS コピー バックアップを作成するように設定を変更できます。 詳細については、 こちらの記事を参照してください。

・Azure 仮想マシンでのバックアップ エラーのトラブルシューティング - VM スナップショットに関する問題のトラブルシューティング
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-vms-troubleshoot#troubleshoot-vm-snapshot-issues
> 既定では、VM バックアップによって Windows VM 上に VSS フル バックアップが作成されます。 SQL Server を実行していて SQL Server のバックアップを構成されている VM では、スナップショットの遅延が発生する可能性がありますナップショットの遅延が原因でバックアップが失敗する場合は、次のレジストリ キーを設定します。
[HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\BCDRAGENT]
"USEVSSCOPYBACKUP"="TRUE"



また、下記は弊社外のブログではございますが、本件に関する参考になればと存じ、ご案内させていただきます。
※社外の情報のため内容につきましては当社は、下記外部のリンク先ウェブサイトの内容に関していかなる責任も負うものではありません。
・Azure Backup で SQL Server がインストールされている仮想マシンをバックアップする際に意識しておきたいこと
https://blog.engineer-memo.com/2018/03/17/azure-backup-%E3%81%A7-sql-server-%E3%81%8C%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E4%BB%AE%E6%83%B3%E3%83%9E%E3%82%B7%E3%83%B3%E3%82%92/

### 1.3  Oracle DB for Windows VM の Azure VM Backup について<a id="1-3"></a>
よくお問い合わせをいただく例としましては Oracle DB が搭載された Windows OS に関してお問い合わせをいただくことがございます。
弊社では Windows OS 向けの Oracle  DB がすべて VSS 対応しているかわかりかねますが、実績はございます。
ご利用の Oracle DB が VSS に対応しているかが不明な場合は別途 Oracle 社にお問い合わせいただければと存じます。

* 下記情報は弊社外のサイトでございますが、ご参考になれば幸いです。弊社情報ではございませんのでその点ご留意ください。
・Oracleがインストールされているシステムで Exit Code -311が発生する
https://jpkb.actiphy.com/?epkb_post_type_1=old-kb-Oracle%E3%81%8C%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%81%A7-Exit-Code-311%E3%81%8C%E7%99%BA%E7%94%9F%E3%81%99%E3%82%8B
 
・(Oracle社) VSSを使用したデータベースのバックアップおよびリカバリの目的
  ※Oracle DB すべてが対応しているかわかりかねます
https://docs.oracle.com/cd/F19136_01/ntqrf/purpose-of-database-backup-and-recovery-with-vss.html#GUID-6A44D80C-0427-4DB8-AD3C-BD5426AECC2B

### 1.4 事前事後スクリプトについて<a id="1-4"></a>
Linux VM 事前事後スクリプトに関しましては、お客様自身で対象のアプリケーション (DBなど) の IO を停止 / 再開する処理を記載いただく必要がございます。
そのため、対象のアプリケーションに対してそのようなコマンド制御ができない場合は、残念ながら事前事後スクリプトを用いることはできません。そのようなコマンド制御が可能かはアプリケーション提供ベンダーまでお問い合わせをいただきますようお願いします。

- 参考
・Azure Linux VM のアプリケーション整合性バックアップ
https://docs.microsoft.com/ja-jp/azure/backup/backup-azure-linux-app-consistent
・git hub 上のサンプル事前事後スクリプト (Oracle や MySQLがございます。)
https://github.com/MicrosoftAzureBackup



## 2.ファイルシステム整合性<a id="2"></a>
Windows OS のオンライン バックアップを取得した際に一部の VSSライターが失敗した場合や Linux OS でオンライン バックアップを取得した場合 (または 事前事後スクリプトが失敗した場合) にファイルシステム整合性となります。
こちらは OS の起動を保証した整合性ですが、アプリケーションレベルでの整合性は担保されておりません。


## 3.クラッシュ整合性<a id="3"></a>
スナップショット作成実行時のディスクのデータのみを保存します。
アプリケーション整合性やファイルシステム整合性とは異なり、OS 内部とは連携せずスナップショットを取得します。
そのため、オフライン状態の VM をバックアップした際にはクラッシュ整合性となります。
OS の起動を保証しない整合性ではございますが、**正常に電源が落とされた状態の VM であればメモリ上の情報や I/O の発生はなく、ディスクにしか情報はないため整合性の懸念は全くございません。**

- 参考 (関連するブログ記事です。)
・Azure VM Backup では オフライン バックアップができるのか
https://jpabrs-scem.github.io/blog/AzureVMBackup/Azure_VM_Offline_backup/

一方、Azure Disk Backup やマネージドディスクのスナップショットなどは、起動中の VM にアタッチされているディスクのスナップショットを取得することが可能ですが、この際のオンライン状態でのスナップショットの整合性は Azure VM Backupとは異なり、クラッシュ整合性となります。
整合性は劣るものの、後述の通り DB のない VM であればクラッシュ整合性でも基本的には問題ございません。

- 参考
・Azure ディスク バックアップの概要
https://docs.microsoft.com/ja-jp/azure/backup/disk-backup-overview
・仮想ハード ディスクのスナップショットを作成する
https://docs.microsoft.com/ja-jp/azure/virtual-machines/snapshot-copy-managed-disk?tabs=portal

クラッシュ整合性に関しましては次の公開情報にございますようなイメージをしていただけるとわかりやすいかと存じます。
 (Azure Site Recovery のドキュメントではございますが、考え方は同じです。)
・Azure Site Recovery に関する一般的な質問 - クラッシュ整合性復旧ポイントとは何ですか?
https://docs.microsoft.com/ja-jp/azure/site-recovery/site-recovery-faq#---------------------

>クラッシュ整合性復旧ポイントには、スナップショットの作成中にサーバーから電源コードが引き抜かれたときのディスク上のデータが含まれます。 クラッシュ整合性復旧ポイントには、スナップショットの作成時にメモリに入っていたものは一切含まれません。
>クラッシュ整合性復旧ポイントは通常、データベースのないオペレーティング システムや、ファイル サーバー、DHCP サーバー、プリント サーバーなどのアプリケーションにとっては十分です。

