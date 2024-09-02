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
[2. CSV の利用有無 および CSV ライターの動作状況を確認する方法](#2)
[3. CSV を利用しているときの Azure Backup について](#3)  
[4. WSFC を利用している場合について](#4)  
[5. CSV ライターを無効化する方法](#5)
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

### <a id="1.1"></a> (補足)  
CSV を利用している、もしくは CSV ライターが有効である状態で VM バックアップを実行すると、イベント ログに下記警告レベルのログが記録されます。  

- アプリケーション ログ  
  > ログの名前: Application  
  > ソース: VSS  
  > 日付: yyyy/mm/dd HH:mm:ss  
  > イベント ID: 8229  
  > タスクのカテゴリ: なし  
  > レベル: 警告  
  > キーワード: クラシック  
  > ユーザー: N/A  
  > コンピューター: <コンピューター名>  
  > 説明:  
  > エラー 0x00000000, The operation completed successfully.  
  >  により、VSS ライターはイベントを拒否しました。イベントの処理中に VSS ライターがライター コンポーネントに加えた変更は、要求側では利用できません。 VSS ライターをホストしているアプリケーションからの関連イベントについては、イベント ログを参照してください。  
  > 
  > Operation:  
  >    PrepareForSnapshot Event  
  > 
  > Context:  
  >    Execution Context: Writer  
  >    Writer Class Id: {1072ae1c-e5a7-4ea1-9e4a-6f7964656570}  
  >    Writer Name: Cluster Shared Volume VSS Writer  
  >    Writer Instance ID: {a2c1fb45-4c7e-43dc-b4e1-6f4660f40ce4}  
  >    Command Line: C:\Windows\Cluster\clussvc.exe -s  
  >    Process ID: 4004</Data>  
  <img src="https://github.com/user-attachments/assets/4fb89115-7c88-448c-9e43-cc2829623fff" width="700">  
- システム ログ  
  > ログの名前: System  
  > ソース: Microsoft-Windows-FailoverClustering  
  > 日付: yyyy/mm/dd HH:mm:ss   
  > イベント ID: 1544  
  > タスクのカテゴリ: Cluster Backup/Restore  
  > レベル: 警告  
  > キーワード:  
  > ユーザー: SYSTEM  
  > コンピューター: <コンピューター名>  
  > 説明:  
  > クラスター構成データのバックアップ操作が取り消されました。クラスターのボリューム シャドウ コピー サービス (VSS) ライターが中止要求を受信しました。  
  <img src="https://github.com/user-attachments/assets/3b9793c8-7684-4761-877e-cca8dcf5fd06" width="700">  


## <a id="2"></a> 2. CSV の利用有無 および CSV ライターの動作状況を確認する方法  
[CSV の利用有無を確認する方法](#2.1)、および [CSV ライターの動作状況を確認する方法](#2.2) について、以下のとおりご案内いたします。  

> [!TIP]  
> CSV を利用していない、且つ CSV ライターも無効な状態である場合には、追加の作業を行うことなく、Azure VM Backup を構成することが可能でございます。  

### <a id="2.1"></a> 2.1 CSV の利用有無を確認する方法  
CSV の利用有無を確認するには、管理者として実行した PowerShell コンソールで、下記コマンドを実行してください。  
コマンド実行結果に、CSV の情報が出力された場合には、コマンドを実行しているマシン (WSFC) で CSV が利用されていると判断可能です。  

CSV の利用が確認できた場合には、後続の [3. CSV を利用しているときの Azure Backup について](#3) をご確認ください。  

**コマンド**  
```PowerShell  
Get-ClusterSharedVolume
```  

**実行結果例**  
- CSV を利用している場合  
  <img src="https://github.com/user-attachments/assets/e9a620ee-b3e2-4d2a-b5d3-2503428982ed" width="700">  
- CSV を利用していない場合  
  <img src="https://github.com/user-attachments/assets/645149c9-9869-4d22-86ee-b8d96bd18566" width="700">  


### <a id="2.2"></a> 2.2 CSV ライターの動作状況を確認する方法  
CSV ライターの動作状況を確認するには、管理者として実行した PowerShell コンソールで、下記コマンドを実行してください。  
コマンド実行結果に、``Cluster Shared Volume VSS Writer`` という名前の VSS ライターが含まれていた場合には、コマンドを実行しているマシンに CSV ライターがインストールされており、有効な状態であると判断可能です。  

CSV の利用は確認できなかったが、CSV ライターは有効な状態であった場合には、[4. WSFC を利用している場合について](#4) および [5. CSV ライターを無効化する方法](#5) をご確認ください。  

**コマンド**  
```PowerShell  
vssadmin list writers
```  

**実行結果例**  
<img src="https://github.com/user-attachments/assets/227b1082-ec2c-4ff0-b68c-3478fd8ef274" width="900">  


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
CSV ライターを無効化する方法につきましては、[5. CSV ライターを無効化する方法](#5) をご確認ください。  

## <a id="5"></a> 5. CSV ライターを無効化する方法  
CSV ライターを無効化する手順を、以下のとおりご案内いたします。  
> [!WARNING]  
> **CSV を利用していないことを、事前にご確認いただいたうえで**、CSV ライターを無効化してください。  

### <a id="5.1"></a> 5.1 CSV ライターの無効化手順  
- 0. 各クラスター ノードそれぞれで下記手順を実施します  
- 1. 「ファイル名を指定して実行」 に ``regedit`` と入力して実行し、 レジストリ エディターを起動します  
    <img src="https://github.com/user-attachments/assets/de876918-4051-462a-b7bc-f872c48e659c" width="400">  

- 2. 下記のキーを右クリックし、「アクセス許可」 を選択して、「Failover Clusters のアクセス許可」 の画面を開きます  
    ```text  
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Failover Clusters
    ```  
    <img src="https://github.com/user-attachments/assets/a3cf11a7-b6c4-414f-8965-3142fc6ce009" width="700">  

- 3. 「詳細設定」 を押下し、「Failover Clusters のセキュリティの詳細設定」 の画面を開きます  
    <img src="https://github.com/user-attachments/assets/3c2d0f12-e475-48c5-a4c8-313293877729" width="400">  

- 4. 「所有者」 の隣の 「変更」 を選択し、「選択するオブジェクトを入力してください」 に ``Administrator (管理者アカウント)`` と入力して、「名前の確認」 > 「OK」 を選択します  
  ※ 「場所の指定」には、サーバーが参加しているドメインが選択されている状態で問題ございません  
    <img src="https://github.com/user-attachments/assets/691cbdf6-da21-4ed2-a62d-a9871256ad2b" width="700">  
    <img src="https://github.com/user-attachments/assets/0b8769b4-2838-4baf-a80e-5113cef6562e" width="500">  

- 5. 「所有者」 が Administrator (管理者アカウント) に変更されたことを確認し、「OK」 を押下して、「Failover Clusters のセキュリティの詳細設定」 の画面を閉じます  
    <img src="https://github.com/user-attachments/assets/f9e6b493-39f2-4bfe-8b34-49d05efdd88d" width="700">  

- 6. 「Failover Clusters のアクセス許可」 画面で Administrator (管理者アカウント) または Administrators のフル コントロールにチェックを入れ、「OK」 を選択して画面を閉じます  
    <img src="https://github.com/user-attachments/assets/e79ae654-e002-4e06-80a5-a94cd4b9addb" width="400">  

- 7. 再度、レジストリ エディターで Failover Clusters のキーを右クリックし、「新規」 > 「DWORD (32 ビット) 値」 を選択して、下記のレジストリを作成します  
  ```text  
  キー : HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Failover Clusters
  名前 : EnableCsvVssWriter
  種類 : REG_DWORD
  データ : 0
  ```  
    <img src="https://github.com/user-attachments/assets/579af712-e021-4070-989e-f2e3989b90d7" width="700">  
    <img src="https://github.com/user-attachments/assets/880c78b3-e1aa-452a-a1d4-4d9d68f017a4" width="700">  

- 8. OS の再起動を実施します  

以上で CSV ライターの無効化作業は完了です。  

### <a id="5.2"></a> 5.2 CSV ライターの無効化を元に戻す方法  
[5.1 CSV ライターの無効化手順](#5.1) で行った設定を元に戻す手順を、以下のとおりご案内いたします。  

- 0. 各クラスター ノードそれぞれで下記手順を実施します  
- 1. 「ファイル名を指定して実行」 に ``regedit`` と入力して実行し、 レジストリ エディターを起動します  
    <img src="https://github.com/user-attachments/assets/de876918-4051-462a-b7bc-f872c48e659c" width="400">  

- 2. 下記のキーを右クリックし、「アクセス許可」 を選択して、「Failover Clusters のアクセス許可」 の画面を開きます  
    ```text  
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Failover Clusters
    ```  
    <img src="https://github.com/user-attachments/assets/a3cf11a7-b6c4-414f-8965-3142fc6ce009" width="700">  

- 3. 「Failover Clusters のアクセス許可」 画面で Administrator (管理者アカウント) または Administrators のフル コントロールのチェックを外し、「適用」 を選択します  
    <img src="https://github.com/user-attachments/assets/db167b78-1802-4150-9285-0518b840af58" width="400">  

- 4. 「Failover Clusters のアクセス許可」 画面で 「詳細設定」 を押下し、「Failover Clusters のセキュリティの詳細設定」 の画面を開きます  
    <img src="https://github.com/user-attachments/assets/3c2d0f12-e475-48c5-a4c8-313293877729" width="400">  

- 5. 「所有者」 の隣の 「変更」 を選択し、「選択するオブジェクトを入力してください」 に  
  ``NT Service\TrustedInstaller`` と入力して、「名前の確認」 > 「OK」 を選択します  
  ※ 「場所の指定」には、ローカル マシン名を指定してください  
    <img src="https://github.com/user-attachments/assets/73d1251d-fe6d-44de-8d58-ea6e7d2ea5ee" width="700">  
    <img src="https://github.com/user-attachments/assets/7918ce9d-3f4e-4523-904e-4dc0237281d2" width="500">  

- 6. 「所有者」 が TrustedInstaller アカウントに変更されたことを確認し、「OK」 を押下して、「Failover Clusters のセキュリティの詳細設定」 および 「Failover Clusters のアクセス許可」 の画面を閉じます  
    <img src="https://github.com/user-attachments/assets/e8cc43a1-52b8-41c9-954b-fbe5ce4a3599" width="700">  

以上で CSV ライターの無効化の戻し作業は完了です。  