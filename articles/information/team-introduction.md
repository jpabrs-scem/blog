---
title: 【作成中】ABRS & SCEM チームについて
date: 2021-09-16 12:00:00
tags:
  - Information
disableDisclaimer: false
---

<!-- more -->
#### ABRS & SCEM チームについて
ABRS (Azure Backup and Recovery Service) として Azure Backup 、DPM/MABS、 Azure Site Recovery 、Azure Migrate 、System Center の各製品の技術サポートをしているチームです。
現在は完全にフルリモートで各自家から仕事 (WfH, work from home と呼んでいます) しています。

• Azure Backup
https://docs.microsoft.com/ja-jp/azure/backup/
• DPM/MABS
https://docs.microsoft.com/ja-jp/system-center/dpm/dpm-overview
https://docs.microsoft.com/ja-jp/azure/backup/backup-support-matrix-mabs-dpm
• Azure Site Recovery
https://docs.microsoft.com/ja-jp/azure/site-recovery/
• Azure Migrate
https://docs.microsoft.com/ja-jp/azure/migrate/
• SCOM
https://docs.microsoft.com/ja-jp/system-center/scom/


#### Azure Backup  ってどんな製品？
Azure Backup はデータをバックアップし、それを Microsoft Azure クラウド から回復するための製品です。 
例えば、Azure VM, Azure Files, Azure Managed Disks, Azure BLOB などのバックアップを行うことが出来ます。
Azure VM のバックアップでは、ディスクのスナップショットを取得し、取得したスナップショットを Recovery Services コンテナーにデータ転送することで実現しています。
また、取得したスナップショットから復元を行うこともできます。
![azure_backup](https://user-images.githubusercontent.com/71251920/133543826-a5d8ab99-b617-47be-aff9-3db6ff30e445.png)

#### SCOM ってどんな製品？
Microsoft System Center の 1 つのコンポーネントである Operations Manager は、1 つのコンソールから多数のコンピューターのサービス、デバイス、および操作を監視できるソフトウェアです。
Windows Server や Linux コンピューターなどのエージェント側の死活監視からログ情報/イベント情報の監視、アラート発砲まで一元的に機能をご提供します。
![SCOM](https://user-images.githubusercontent.com/71251920/133543828-aa1bc2cc-ae05-4b80-b53f-1a87b1ddce2f.png)

#### DPM/MABS ってどんな製品？
DPM (System Center Data Protection Manager)とMABS（Microsoft Azure Backup Server）は、多様な保護対象をバックアップと回復するための製品です。
バックアップされたデータはローカル・ディスクだけではなく、Microsoft Azure クラウドにも保存できます。
主に下記のワークロードを保護する機能を提供しています。
・Microsoft ワークロードのアプリケーション（SQL Server、Exchange、SharePoint など）
・Windows オペレーティング システムを実行するコンピューターのファイル、フォルダー、ボリューム
・Windows オペレーティング システムを実行するコンピューターのシステム状態のバックアップまたは完全なベア メタル バックアップ
・Windows または Linux を実行する Hyper-V 仮想マシンとVMWare仮想マシン
![DPM](https://user-images.githubusercontent.com/71251920/133694113-89f8a5a1-0261-48aa-8005-7b5dd33f4eca.png)


#### Azure Site Recovery ってどんな製品？
Azure Site Recovery (ASR)　は、データの保護を行うことで、メンテナンスや災害などによるシステム停止の際に、お客様のビジネス継続性の確保とディザスター リカバリー (BCDR) を可能とするための製品です。システム停止時には、プライマリ サイトからセカンダリ サイト へフェール オーバーすることで、ビジネス継続性を確保することができます。
主に以下の環境のデータの保護を行うことができます。
・Azure プライマリ リージョン から Azure セカンダリ リージョン への保護
・オンプレミス VM / 物理サーバー サイト から Azure サイト への保護

オンプレミス VM / 物理サーバー サイト から Azure サイト への保護の図：
![ASR_P2A](https://user-images.githubusercontent.com/71251920/133694495-87f3774d-656f-4ee4-8728-206be247a534.png)


※本情報の内容（添付文書、リンク先などを含む）は、作成日時点でのものであり、予告なく変更される場合があります。