---
title: QL4L-5D8 XNV5-HTZ クラシック アラートから Azure Monitor を使用した組み込みのアラートへの移行について
date: 2024-08-16 12:00:00
tags:
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートです。
今回は、2023 年 3 月末より弊社から発行されている、アラート追跡 ID 「QL4L-5D8」、「XNV5-HTZ」について説明いたします。

## 目次
-----------------------------------------------------------
[Q1. 「QL4L-5D8」「XNV5-HTZ」このアラートは何ですか？](#Q1)
[Q2. どの Recovery Services コンテナーが「クラシック アラート設定」になっていますか？](#Q2)
[Q3. クラシック アラートから Azure Monitor を使用した組み込みのアラートへと移行した場合のコストはどうなりますか？](#Q3)
[Q4. クラシック アラートの「通知の構成」をしているかどうかは 1 つ 1 つの Recovery Services コンテナーを確認する必要がありますか？](#Q4)
[Q5. Azure Monitor を使用した組み込みのアラートで、クラシック アラートと同じ重要度のアラート メールを通知するには？](#Q5)
-----------------------------------------------------------

## <a id="Q1"></a>Q1. 「QL4L-5D8」「XNV5-HTZ」このアラートは何ですか？
**A1** クラシック アラートから、Azure Monitor を使用した組み込みのアラートへと移行するよう、お知らせするためのものです。
Recovery Services コンテナーでは、クラシック アラートが<span style="color: red; ">既定</span>で存在しており、かつ、利用可能な状態となっております。
後述 「Q2. どの Recovery Services コンテナーが「クラシック アラート設定」になっていますか？」 をご参照いただき、クラシック アラートを利用した通知の設定有無をまずはご確認くださいますようお願いいたします。

#### ・クラシック アラート機能用いて、現在メールへのアラート通知を構成している場合
クラシック アラートは、2026 年 3 月 31 日をもって廃止する予定です。
監視設定を継続してご利用になられる場合は、お手数ではございますが、「Azure Monitor を使用した組み込みのアラート」への切り替えを事前にご検討くださいますようお願いいたします。

#### ・クラシック アラート機能用いて、現在メールへのアラート通知を構成していないが、今後はバックアップ ジョブ失敗時にメール通知などのアラートをご希望の場合
クラシック アラートから、「Azure Monitor を使用した組み込みのアラート」へと切り替え設定することをご検討ください。

#### ・クラシック アラート機能用いて、現在メールへのアラート通知を構成していない、かつ今後もバックアップ ジョブ失敗時にメール通知などのアラートをご希望でない場合
<span style="color: red; ">特段お客様での追加作業は不要です。</span>

・監視とレポートのシナリオ
　https://learn.microsoft.com/ja-jp/azure/backup/monitoring-and-alerts-overview#monitoring-and-reporting-scenarios

![](https://user-images.githubusercontent.com/96324317/230756428-28f8085a-16bf-49ab-aa50-8659f342b81e.png)

![](https://user-images.githubusercontent.com/96324317/230756444-3a95a6b5-dd4d-47e0-b3d1-ea3ffe54fa49.png)

![](https://user-images.githubusercontent.com/96324317/230756450-5d78ebd9-19e0-455b-9ba6-6f079f9cf65d.png)

## <a id="Q2"></a>Q2.どの Recovery Services コンテナーが「クラシック アラート設定」になっていますか？ 
**A2**
・既定ですべての Recovery Services コンテナーにおいて、「Azure Monitor を使用した組み込みのアラート」へと移行していない Recovery Services コンテナーは、「クラシック アラート」が有効になっており、今回の正常性アラート対象となっております
・実際に「クラシック アラート」を用いてメールへの通知構成をしているかどうかは、お客様環境の設定次第です

#### 【どの Recovery Services コンテナーが「Azure Monitor を使用した組み込みのアラート」へと移行しておらず、クラシック アラートが有効になっているのか　確認方法】
[バックアップ センター] ブレードの [概要] タブより、”アクティブなアラート” 項目に
``[以前のアラート ソリューションであるクラシック アラートを使用しているコンテナーが xx 個あります。]``
 と表示されている場合、クラシック アラートが有効・利用可能となっている Recovery Services コンテナーが存在しています。

この記述がある場合は、後述される [アクションを起こすには、ここをクリック] をクリックします。

![](https://user-images.githubusercontent.com/96324317/230756521-74ec97f7-1147-4799-aa66-59b789ab3f69.png)

Azure Monitor アラートのみの使用をオプトインの [アラートの管理] をクリックします。

![](https://user-images.githubusercontent.com/96324317/230756529-fbb23335-c992-4b39-b4b9-071e280168f8.png)

[Azure Monitor アラートのみの使用をオプトイン] 画面にて、リストされている Recovery Services コンテナーを確認します。

> [!WARNING]
> 項目 ``クラシック アラートのバックアップ`` が「はい」となっている Recovery Services コンテナーが対象となります。

![](https://github.com/user-attachments/assets/319bf6c0-a39a-490a-86ab-a719b2abc0b3)


#### 【どの Recovery Services コンテナーが、クラシック アラートの「通知の構成」を行っているのか　確認方法】

リストされた Recovery Services コンテナーが実際に通知の構成をしているかどうかは、上記でリストされた Recovery Services コンテナー ＞ [バックアップ アラート] ＞ ”通知の構成” ＞ 「メールの通知：オン」 となっているかどうかで確認可能です。
![](https://user-images.githubusercontent.com/96324317/230756566-faba366c-1f68-4034-8f4e-bbc1f9e7bc2f.png)

通知の構成をしている Recovery Services コンテナーがある場合、[Azure Monitor アラートのみの使用をオプトイン] 画面にて、アラートの設定の更新を行います。

> [!NOTE]
> ”通知の構成” ＞「メールの通知：オン」をしている Recovery Services コンテナーが無い場合、かつ、今後バックアップジョブの監視設定をする必要が無い場合は、下記対応は不要です。

まず、対象 Recovery Services コンテナーを選択して、"アラートの設定" 列の "更新" を押下してください。
![](https://github.com/user-attachments/assets/2534b4ea-f20e-4a75-b1c6-1a0c8944c33f)

表示された [監視の設定] 画面にて "Backup 用の Azure Monitor アラートのみを使用" にチェックを入れてください。
また "Backup のジョブ エラーに関する組み込みの Azure Monitor アラート" も有効化してください。
![](https://github.com/user-attachments/assets/f1833b43-a0a2-4a41-9880-1b14d1f742cf)

> [!WARNING]
>  "ジョブ エラーに関する組み込みの Azure Monitor アラート" が無効化されていると、バックアップセンターの下記概要画面上ではクラシック アラートを使用しているコンテナーとしてカウントされたままとなりますのでご注意ください。
![](https://github.com/jpabrs-scem/blog/assets/141192952/9518f95f-bbea-4edb-bb60-4410fa0441db)

最後に画面下部の "更新" ボタンを押下していただければ、クラシック アラートの廃止は完了いたします。

なお、 [監視の設定] 画面に記載されているように、メールなどの通知が必要な場合は、別途設定していただく必要があります。
詳細は下記のドキュメントを参照いただければと存じます。
・クラシック アラートから組み込みのAzure Monitor アラートに移行する
　https://learn.microsoft.com/ja-jp/azure/backup/move-to-azure-monitor-alerts#migrate-from-classic-alerts-to-built-in-azure-monitor-alerts


## <a id="Q3"></a>Q3.クラシック アラートから Azure Monitor を使用した組み込みのアラートへと移行した場合のコストはどうなりますか？ 
**A3** 「Azure Monitor を使用した組み込みのアラートが生成されること」自体に料金は発生しません。
一方、メールなどへアラートを通知させる場合は、少額の料金が発生いたします。
詳細は下記ドキュメントよりご参照ください。
 
・クラシック アラートから組み込みの Azure Monitor アラートに移行する
　 https://learn.microsoft.com/ja-jp/azure/backup/move-to-azure-monitor-alerts#migrate-from-classic-alerts-to-built-in-azure-monitor-alerts

![](https://user-images.githubusercontent.com/96324317/230756632-22b2968e-d899-44f4-8472-c0c5db56f0c9.png)

Free レベル (1 か月あたり 1,000 メール) を超える通知に対しては、下記の料金が発生します。

・価格 - Azure Monitor | Microsoft Azure
https://azure.microsoft.com/ja-jp/pricing/details/monitor/
“メール            1 か月あたりメール 1,000 通         メール 100,000 通につき $2”
![](https://user-images.githubusercontent.com/96324317/234444128-ca0d6690-a6a8-4bcf-9e9e-7e63cf44ce49.png)


## <a id="Q4"></a>Q4.クラシック アラートの「通知の構成」をしているかどうかは 1 つ 1 つの Recovery Services コンテナーを確認する必要がありますか？ 
**A4** 恐縮ながら、現状はクラシック アラートの「通知の構成」部分を照会するような Azure PowerShell / Azure CLI コマンドのご用意が無いため、お客様には Azure ポータル画面の Recovery Services コンテナーを 1 つ 1 つ確認いただく必要がございます。
※　前提としてクラシック アラートの「通知の構成」をされているのであれば、お客様が設定されたメールアドレスの宛先へと、バックアップ ジョブ失敗時などに通知がなされています。

その他確認手段の 1 つとして、以下のような REST API を発行することで確認が可能ですので、参考として紹介いたします。

> [!WARNING]
> 以下 REST API は、本ブログ発行時点で確認可能な手段であり、事前予告なく返却値が変わる可能性がありますこと、ご了承ください。
> さらに、以下 REST API は、あくまで参考としてご連携するサンプル コマンドでございます。
> コマンド実装をされる場合は貴社にて検証のうえ、実施いただきますようご留意ください。
> また、Azure サポートでは主に Post Production の Break & Fix を担当しており、スクリプトのコードレビューのサポートは承っておりませんので、予めご理解をいただけますと幸いでございます。

```
### クラシック アラートのメール通知が有効化されているかを確認する 
### ※ (前提) Connect-AzAccount コマンドにて、 Azure に接続可能な状態で実行すること
# Recovery Services コンテナーのリストを作成
$RSVList = Get-AzRecoveryServicesVault | Select-Object Name, ResourceGroupName, SubscriptionId

# リクエスト ヘッダーを作成
$headers = @{
    'Content-type'  = 'application/json'
    'Authorization' = 'Bearer ' + (Get-AzAccessToken).Token
}

# 結果出力先のオブジェクトを作成
$results = @()

# Recovery Services コンテナーごとに API へリクエストを送り、結果を取得する
foreach ( $rsv in $RSVList ) {
    $uri = "https://management.azure.com/subscriptions/$($rsv.SubscriptionId)/resourceGroups/$($rsv.ResourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$($rsv.Name)/monitoringConfigurations/notificationConfiguration?api-version=2017-07-01-preview"
    $response = (Invoke-RestMethod -Uri $uri -Method Get -Headers $headers).properties
    $results += @([pscustomobject]@{subscriptionID = $rsv.SubscriptionId; resourceGroupName = $rsv.ResourceGroupName; recoveryServicesContainerName = $rsv.Name; isClassicAlertNotificationEnabled = $response.areNotificationsEnabled; mailRecipients = $response.additionalRecipients -join '; ' })
}

# 全ての結果をコンソール出力
$results | Sort-Object isClassicAlertNotificationEnabled -Descending | ForEach-Object { Write-Output $_ | Format-Table }
```
上記 REST API を発行した場合、「isClassicAlertNotificationEnabled：True」となっている Recovery Services コンテナーが「通知の構成：オン」となっているものとなります。
![](https://user-images.githubusercontent.com/96324317/230820217-777e48c3-f704-4e83-9aeb-1a5b107633af.png)

![](https://user-images.githubusercontent.com/96324317/230820265-bcb0a6df-eae6-4946-b0f9-c1f905a539d4.png)

![](https://user-images.githubusercontent.com/96324317/230820287-06940bef-a423-4202-a016-e3ec7bd79489.png)

![](https://user-images.githubusercontent.com/96324317/230820315-3f9dc117-bfac-4e73-b0aa-d37a12503390.png)

## <a id="Q5"></a>Q5. Azure Monitor を使用した組み込みのアラートで、クラシック アラートと同じ重要度のアラート メールを通知するには？
**A5**  
まず、クラシック アラートと Azure Monitor アラートの重要度につきまして、以下にご案内いたします。

> [!NOTE]
> お急ぎの方は、下記各アラートの重要度に関する説明は省略いただいて問題ございません。設定方法をご案内している [【Azure Monitor を使用した組み込みのアラートで、クラシック アラートと同じ重要度のアラート メールを通知する　設定方法】](#Q5.1) をご確認ください。

#### クラシック アラートの重要度について
クラシック アラートでは、「重大」、「警告」の 2 種のアラートが以下のタイミングで発報されます。  
- 「重大」 : バックアップやリストアの失敗、バックアップ データの削除などの破壊的操作が行われたとき  
- 「警告」 : MARS エージェントでのバックアップ操作で警告が発生したとき  

・ Azure Backup で保護されたワークロードの監視 - Azure Backup | Microsoft Learn  
　 https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor?tabs=recovery-services-vaults#alert-types  
　 抜粋 :
> **重大**: 原則として、(スケジュールされたかユーザーがトリガーしたかを問わず) バックアップまたは回復が失敗すると、アラートが生成されて "重大" アラートとして表示されます。 アラートは、バックアップの削除などの破壊的な操作でも生成されます。  
> **警告**: バックアップ操作が成功したもののいくつかの警告を伴う場合、これらは "警告" アラートとして表示されます。 警告アラートは現在、Azure Backup エージェントのバックアップにのみ使用できます。  
> **情報**: 現時点では、Azure Backup サービスで "情報" アラートは生成されません。  

#### Azure Monitor の組み込みアラートの重要度について
Azure Monitor の組み込みアラートでは、主に「セキュリティ アラート」、「ジョブの失敗のアラート」の 2 種のアラートが以下のタイミングで発報されます。  
- 「セキュリティ アラート」(重要度 : 0 - 重大) : バックアップ データの削除や、コンテナーの論理的な削除機能が無効化されたとき  
- 「ジョブの失敗のアラート」(重要度 : 1 - エラー) : バックアップやリストアが失敗したとき  

また、MARS エージェントでのバックアップ操作で警告が発生したときや、SQL Server バックアップでサポートされていないバックアップ タイプが設定されていたときには、警告 (重要度 : 2 - 警告) アラートが発報されます。  

・ Azure Backup で保護されたワークロードの監視 - Azure Backup | Microsoft Learn  
　 https://learn.microsoft.com/ja-jp/azure/backup/backup-azure-monitoring-built-in-monitor?tabs=recovery-services-vaults#azure-monitor-alerts-for-azure-backup  
　 抜粋 :  
> **セキュリティ アラート**: バックアップ データの削除や、コンテナーの論理的な削除機能の無効化などのシナリオの場合、セキュリティ アラート (重大度 0) が発生し、Azure portal に表示されるか、他のクライアント (PowerShell、CLI、REST API) で使用されます。  
> **ジョブの失敗のアラート**: バックアップ エラーや復元エラーなどのシナリオの場合、Azure Backup は、Azure Monitor 経由で組み込みアラート (重大度 1) を提供します。  

・ SQL Server のデータベース バックアップに関するトラブルシューティング - Azure Backup | Microsoft Learn  
　 https://learn.microsoft.com/ja-jp/azure/backup/backup-sql-server-azure-troubleshoot#backup-type-unsupported  

#### クラシック アラートと Azure Monitor を利用した組み込みのアラートの重要度の関係性について
クラシック アラートと Azure Monitor を利用した組み込みのアラートの重要度は、おおよそ以下の関係性がございます。
- クラシック アラートの 「重大」 ≒  Azure Monitor を利用した組み込みのアラートの 「重大」 + 「エラー」  
- クラシック アラートの 「警告」 ≒  Azure Monitor を利用した組み込みのアラートの 「警告」  

### <a id="Q5.1"></a>【Azure Monitor を使用した組み込みのアラートで、クラシック アラートと同じ重要度のアラート メールを通知する　設定方法】
Azure Monitor を使用した組み込みのアラートで、クラシック アラートと同じ重要度のアラート メールを通知する設定方法を、以下にご案内いたします。

> [!WARNING]
> 下記ドキュメントに従って、クラシック アラートから組み込みの Azure Monnitor アラートへ移行する設定が完了していることが前提となります。  
> もし未設定である場合には、事前に下記ドキュメントの手順 1 ~ 7 を実行してください。
> ・ Azure Backup 用の Azure Monitor ベースのアラートに切り替える - Azure Backup | Microsoft Learn  
> 　 https://learn.microsoft.com/ja-jp/azure/backup/move-to-azure-monitor-alerts#migrate-from-classic-alerts-to-built-in-azure-monitor-alerts  


#### クラシック アラートのメール通知設定を確認する
Recovery Services コンテナーの ``監視 > バックアップ アラート > 通知の構成`` を表示し、項目「重要度」の設定内容を確認します。  

![](https://github.com/user-attachments/assets/1f6da508-4c61-4639-b9d7-d9432c3089ef)

#### Azure Backup 用のアラート処理ルールの設定を変更する
バックアップ センターの ``監視とレポート > アラート > アラート処理ルール`` を表示し、Azure Monitor アラートへ切り替えるときに作成したアラート処理ルールを編集します。  

![](https://github.com/user-attachments/assets/f4dddc70-d2ec-47cc-ba55-60400d1e1d32)
![](https://github.com/user-attachments/assets/cdb94c4e-0192-4e46-a749-57930e2b3003)

項目 フィルター に、「重要度」フィルターを追加し、値として "0 - 重大", "1 - エラー", "2 - 警告" のいずれかを選択し、設定を保存します。  
(下記例においては、クラシック アラートの重要度設定が "クリティカル, 警告" となっていたため、"0 - 重大", "1 - エラー", "2 - 警告" の 3 点を選択しております。)  
![](https://github.com/user-attachments/assets/f0161061-6b96-494a-93be-eff08d556e17)

以上で設定は完了です。  

### <a id="Q5.2"></a>クラシック アラートと Azure Monitor を使用した組み込みのアラートの通知メールのサンプル
クラシック アラートと Azure Monitor を使用した組み込みのアラートの通知メールのサンプルを、以下のとおりご案内いたします。

> [!WARNING]
> こちらのサンプル メールは 2024/8 頃に受信したものとなりますので、あくまで参考程度に留めてくださいますようお願い申し上げます。
> より正確な内容をご確認いただくためにも、お客様ご自身で、アラート メールの受信検証を行っていただき、内容をご確認ください。

- バックアップ ジョブ失敗に関するアラート メール  
  - クラシック アラート  
    ![](https://github.com/user-attachments/assets/3b3ec1a7-578b-4315-b62a-e322f853505b)  
  - Azure Monitor を使用した組み込みのアラート  
    ![](https://github.com/user-attachments/assets/2cb3f7df-5f3a-4199-b1cf-fc20ade47279)  

- セキュリティ アラート メール  
  - クラシック アラート  
    ![](https://github.com/user-attachments/assets/a47cf52e-e42a-4030-9081-ff0c6e5c95e8)  
  - Azure Monitor を使用した組み込みのアラート  
    ![](https://github.com/user-attachments/assets/4dfd68e9-ce9c-46a0-8fae-c8c94e8645f6)  
