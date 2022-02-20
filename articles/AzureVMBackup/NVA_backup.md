---
title: NVA のバックアップについて
date: 2022-02-22 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさこんにちは、Azure Backup サポートです。
今回は、**「Azure VM Backup にてネットワーク仮想アプライアンス (NVA) をバックアップ可能か？」**というお問い合わせについて回答します。

## 目次
-----------------------------------------------------------
[1. 仮想アプライアンスはバックアップできない可能性がある](#1)
[1. 1-1. VM エージェント の状態の確認](#1-1)
[2. 代替案 - Azure Disk Backup を利用する](#2)
-----------------------------------------------------------

### <a id="1"></a>1. 仮想アプライアンスはバックアップできない可能性が高い

結論から申し上げますと、残念ながら NVA として機能する仮想マシンについては、Azure VM Backup サポート対象外の カスタム OS となる可能性が高いです。
*NVA 以外の仮想アプライアンス、カスタム OS などにおいても同様です。

Azure Marketplace より、NVA として機能する仮想マシンを作成した場合も同様に、Azure VM Backup サポート対象外の OS であることが多くございます。
Azure VM Backup では、オンライン バックアップを実施する際、VM エージェントの拡張機能を利用しますが、NVA に用いられる OS に対しては一般的に、VM エージェントが対応しておりません。

#### <a id="1-1"></a>1-1. VM エージェント の状態の確認
Azure VM Backup をオンラインでご利用いただくには対象の VM を起動しエージェントの状態を確認いただき、Ready となっていることが大前提 (必要条件) となります。
お客様で確認するには下記 **"エージェントの状態"** をご確認ください。
サポート外の OS の場合、**Ready** ではなく **Not Ready** となることが多いです。
![エージェントの状態 の確認](https://user-images.githubusercontent.com/71251920/154855287-696dca76-4bdc-4e8b-ac40-1108515edca8.png)

また、サポート対象の OS で **Not Ready** となっていた場合にはエージェントが正しく動いていないと見受けられます。
その際には agent の再起動や 対象マシンの再起動を行っていただき、それでも事象が改善しない場合には Azure VM agent イシューとしてお問い合わせいただければと存じます。



正確にご確認いただくには、後述のドキュメントを参照の上、**まず VM エージェントが対応しているかをお客様ご自身、および OS 発行ベンダーにご確認いただく必要** がございます。

事例ベースのご案内では、**Zscaler 社の NVA や Palo Alto 社の NVA が対応していない事例がございました。また同様に NVA 以外のカスタム OS に関しましても VM エージェントが対応していないために Azure VM Backup がご利用いただけない事例がございました。**

 
・Azure Linux VM エージェントの概要 - Azure Virtual Machines | Microsoft Docs
　https://docs.microsoft.com/ja-jp/azure/virtual-machines/extensions/agent-linux#requirements
 
下記 に Azure VM Backup の OSサポート対象範囲について記載がございますので、ご参考ください。
・Azure VM バックアップのサポート マトリックス - オペレーティング システムのサポート (Windows)
　https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#operating-system-support-windows
・Azure VM バックアップのサポート マトリックス - オペレーティング システムのサポート (Linux)
　https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#operating-system-support-linux
・Azure で動作保証済みの Linux ディストリビューション
　https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/endorsed-distros
 
NVA として機能する仮想マシンをバックアップする方法の代替案としては、以下が挙げられます。

### <a id="2">代替案 - Azure Disk Backup を利用する</a> 
Azure VM Backup にて仮想マシン全体をバックアップするのではなく、仮想マシンのディスクを Azure Disk Backup にてバックアップする
Azure Disk Backup にてディスクをバックアップする場合は、VM エージェントを利用いたしませんので、対象仮想マシンの ディスクをバックアップする手段として挙げられます。
・Azure ディスク バックアップの概要 - Azure Backup | Microsoft Docs
　https://docs.microsoft.com/ja-jp/azure/backup/disk-backup-overview#key-benefits-of-disk-backup
	

どの種類のディスクがAzure Disk Backup のサポート対象であるかは、下記ドキュメントをご参考ください。
・Azure ディスク バックアップのサポート マトリックス - Azure Backup | Microsoft Docs
　https://docs.microsoft.com/ja-jp/azure/backup/disk-backup-support-matrix
 
 
Azure Disk Backup はクラッシュ整合性となりますのでその点もご留意いただければと思います。詳細につきましては下記 URL の幣ブログ記事をご覧ください。
・Azure VM Backupにおける整合性について - クラッシュ整合性
https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/#3


「Azure VM Backup にてネットワーク仮想アプライアンス（ NVA ）をバックアップ可能か？」に関する説明は以上となります。


