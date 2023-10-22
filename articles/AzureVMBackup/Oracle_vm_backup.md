---
title: Oracle DB の Azure VM Backup について
date: 2023-10-26 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Backup サポートです。
今回は、「Oracle DB を導入している Azure 仮想マシンを Azure VM Backup でバックアップ/リストアすることは可能か」という点について説明します。

## 目次
-----------------------------------------------------------
[1. Oracle DB を導入している Azure 仮想マシンを Azure VM Backup でバックアップ/リストアすることは可能か](#1)
[1-1. Oracle DB が搭載される Azure 仮想マシンが Windows OS の場合](#1-1)
[1-2. Oracle DB が搭載される Azure 仮想マシンが Linux OS の場合](#1-2)
-----------------------------------------------------------

### <a id="1"></a>1. Oracle DB を導入している Azure 仮想マシンを Azure VM Backup でバックアップ/リストアすることは可能か
「Azure VM Backup」は、Azure 仮想マシン単位でバックアップできるサービスです。
Azure 仮想マシン自体のバックアップ、リストアという観点では可能でございます。
ただし、対象 Azure 仮想マシン の OS が Windows か Linux かによって、取得されるスナップショットの整合性や、お客様にて参照いただきたい公開ドキュメントが異なってまいります。

・スナップショットの整合性
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-vms-introduction#snapshot-consistency

Azure VM Backup をご利用いただくにあたって、前提となるサポート マトリックスや、一般的なバックアップ/リストア手順は下記をご参照ください。

・Azure VM バックアップのサポート マトリックス - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas

・Recovery Services コンテナーに Azure VM をバックアップする - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-vms-prepare

・Azure portal を使用して VM を復元する - Azure Backup | Microsoft Learn
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-arm-restore-vms


#### <a id="1-1"></a>1-1. Oracle DB が搭載される Azure 仮想マシンが Windows OS の場合
Windows OS の Azure VM Backup を取得する際、仕様として OS 内部の VSS (ボリューム シャドウ コピー サービス) と呼ばれるサービスと連携してバックアップ データ (=スナップショット) を取得します。
VSS に対応したアプリケーションにおいては、アプリケーションレベルの整合性を担保したスナップショットを取得することが可能ですので、Oracle DB 側で VSS に対応していれば、「アプリケーション整合性」にてバックアップが取得可能です。
ご利用の Oracle DB が VSS に対応しているかが不明な場合は別途 Oracle 社にお問い合わせいただけますと幸いです。
もし、ご利用いただく予定の Oracle DB が VSS に対応していない場合、Oracle DB のアプリケーションの整合性は担保いたしませんが、Azure VM Backup 自体のバックアップ取得は可能でございます。

下記情報は弊社外のサイトでございますが、ご参考になれば幸いです。
弊社情報ではございませんのでその点ご留意ください。

・(Oracle社) VSSを使用したデータベースのバックアップおよびリカバリの目的
  ※Oracle DB すべてが VSS に対応しているかはわかりかねますので、Oracle 社へとお問い合わせください。
　https://docs.oracle.com/cd/F19136_01/ntqrf/purpose-of-database-backup-and-recovery-with-vss.html#GUID-6A44D80C-0427-4DB8-AD3C-BD5426AECC2B

なおこの点は下記ブログにも同様の内容を説明しております。

・1.3 Oracle DB for Windows VM の Azure VM Backup について
　https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#1-3


#### <a id="1-2"></a>1-2. Oracle DB が搭載される Azure 仮想マシンが Linux OS の場合
以下二種類の方法いずれかで Oracle DB の「アプリケーション整合性」を担保したバックアップを取得することが可能となります。
 （一種類目）Oracle データベースの バージョンが <font color="DeepPink">12 未満</font>の場合、貴社にて事前/事後スクリプトをご準備いただくことで、Azure VM Backup にて「アプリケーション整合性」のバックアップが可能となります。
 （二種類目）Oracle データベースの バージョンが <font color="DeepPink">12.1 以上</font>の場合、貴社にて事前/事後スクリプトをご準備する<span style="color: red; ">必要なく</span>、Azure VM Backup にて「アプリケーション整合性」のバックアップが可能となります。
 
 必要な事前作業と DB 復元時の作業詳細については、以下ドキュメントをご参照ください。

・（一種類目 参考）Linux VM のアプリケーション整合性バックアップ - Azure Backup | Microsoft Docs
　https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-linux-app-consistent
 
・（二種類目 参考）Linux データベースのマネージド事前/事後スクリプトのサポート マトリックス
　https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#support-matrix-for-managed-pre-and-post-scripts-for-linux-databases

・（二種類目 参考）Azure Backup を使用して Azure Linux VM で Oracle Database をバックアップおよび復旧する（作業詳細記載あり） - Azure Virtual Machines | Microsoft Docs
　https://learn.microsoft.com/ja-jp/azure/virtual-machines/workloads/oracle/oracle-database-backup-azure-backup?msclkid=f5e49016bd1811ec9d618313a2d3bc55&tabs=azure-portal
　“現在のところ、拡張フレームワークでサポートされているアプリケーションは Oracle 12.x 以降と MySQL です。”


説明は以上となります。