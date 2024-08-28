title: Azure VM Backup における CSV のサポートについて
date: 2024-08-30 12:00:00
tags:
  - Azure VM Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートです。  
今回は、Azure VM Backup での、クラスターの共有ボリューム (Cluster Shared Volume : CSV) を利用している VM のサポート状況、および Azure Backup でのバックアップ方法についてご案内いたします。  

## 目次  
-----------------------------------------------------------
[1. CSV のサポートについて](#1)  
[2. CSV ライターの動作状況を確認する方法](#2)
[3. CSV を利用しているときの Azure Backup について](#3)  
[4. WSFC を利用している場合について](#4)  
-----------------------------------------------------------

## <a id="1"></a> 1. CSV のサポートについて  
Azure VM Backup では、CSV を利用している VM のバックアップはサポートされていません。  
CSV を利用している VM で Azure VM Backup が実行されると、CSV ライターが失敗し、バックアップ データの整合性が **「ファイル システム整合性」** となる可能性がございます。  

> [!NOTE]  
> Windows OS の Azure VM Backup では、Windows ボリューム シャドウ コピー サービス (VSS) と連携し、スナップショットを取得します。  
> すべての VSS ライターが正常に動作した場合には、取得されるバックアップ データの整合性は「アプリケーション整合性」となります。  
> 詳細につきまして、下記ブログ記事をご確認ください。  
> ・ Azure VM Backupにおける整合性について | Japan CSS ABRS Support Blog !!  
> 　 https://jpabrs-scem.github.io/blog/AzureVMBackup/Consistencies/  

・ VM ストレージのサポート / Azure VM バックアップのサポート マトリックス - Azure Backup | Microsoft Learn  
　 https://learn.microsoft.com/ja-jp/azure/backup/backup-support-matrix-iaas#vm-storage-support  
　 抜粋 :  
  > 共有ストレージ :  
  > クラスターの共有ボリューム (CSV) またはスケールアウト ファイル サーバーを使用した VM のバックアップはサポートされていません。  
  > バックアップ中に CSV ライターが失敗する可能性があります。  
  > また、復元時に CSV ボリュームを含むディスクが起動しない可能性があります。  


## <a id="2"></a> 2. CSV ライターの動作状況を確認する方法  
CSV ライターの動作状況を確認するには、管理者として実行した PowerShell コンソールで、下記コマンドを実行してください。  
コマンド実行結果に、``Cluster Shared Volume VSS Writer`` という名前の VSS ライターが含まれていた場合には、コマンドを実行しているマシンに CSV ライターがインストールされており、有効な状態であると判断することが可能でございます。  

#### コマンド  
```PowerShell  
vssadmin list writers
```  
#### 実行結果例  
![](https://github.com/user-attachments/assets/227b1082-ec2c-4ff0-b68c-3478fd8ef274)  


## <a id="3"></a> 3. CSV を利用しているときの Azure Backup について  
> [!IMPORTANT]  
> 前提として、CSV は Azure 共有ディスクを利用して構成していることを想定しております。  
> 共有ディスクを利用していない場合には、下記方法は適用されない可能性がございますので、予めご了承ください。  

CSV を利用している VM で Azure Backup を構成する一例といたしましては、CSV として利用している共有ディスクを含め、VM にアタッチされているすべてのディスクに Azure Disk Backup を構成する方法がございます。  
もし、Azure Disk Backup を利用する場合には、すべてのディスクに対して同じ静止点でバックアップを取得するために、下記の点を考慮してバックアップを構成してください。  
- ディスクそれぞれで構成する Azure Disk Backup は、同じバックアップ スケジュールを設定する  
- Azure Disk Backup が動作する前に VM を事前に停止する  
  (※ 恐縮ながら、Azure Disk Backup では、バックアップ前後に VM を起動 / 停止させるような機能はございません。)  

尚、Azure Disk バックアップの詳細につきましては、下記ドキュメントをご確認ください。  
・ Azure ディスク バックアップの概要 - Azure Backup | Microsoft Learn  
　 https://learn.microsoft.com/ja-jp/azure/backup/disk-backup-overview  
　 抜粋 :  
  > Azure ディスク バックアップ ソリューションは、次のようなシナリオで役立ちます。  
  > クラスター シナリオで実行されているアプリ: Windows Server フェールオーバー クラスターと Linux クラスターの両方で共有ディスクへの書き込みが行われている。  


## <a id="4"></a> 4. WSFC を利用している場合について  
Windows Server フェールオーバー クラスター (Windows Server Failover Cluster : WSFC) を構成している場合には、**クラスタをセットアップした段階で CSV ライターがインストール**されます。  
そのため、**CSV を利用していない場合でも**、WSFC を構成している VM で Azure VM Backup が実行されると、CSV ライターが失敗し、バックアップ データの整合性が 「ファイル システム整合性」 となる可能性がございます。  

### <a id="4.1"></a> 対処方法  
- CSV を利用しているとき  
WSFC を構成している、且つ CSV を利用している場合には、上記 [3. CSV を利用しているときの Azure Backup について](#3) をご確認ください。  

- CSV を利用していないとき  
WSFC を構成している、且つ CSV を利用していない場合には、CSV ライターを無効化することで、Azure VM Backup で 「アプリケーション整合性」 のバックアップ データが取得可能となります。  
CSV ライターの無効化手順の詳細をご確認なさりたい場合には、Windows OS 観点で弊サポートまでお問い合わせください。  

> [!WARNING]
> **CSV を利用していないことを、事前にご確認いただいたうえで**、CSV ライターを無効化してください。  