---
title: QL4L-5D8 クラシック アラートから Azure Monitor を使用した組み込みのアラートへの移行について
date: 2023-04-10 12:00:00
tags:
  - Azure Backup General
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは、Azure Backup サポートです。
今回は、2023 年 3 月末より弊社から発行されている、アラート追跡 ID 「QL4L-5D8」について説明いたします。

## 目次
-----------------------------------------------------------
[Q1. 「QL4L-5D8」このアラートは何ですか？](#Q1)
[Q2. どのRecovery Services コンテナーが「クラシック アラート設定」になっていますか？](#Q2)
[Q3. クラシック アラートから Azure Monitor を使用した組み込みのアラートへと移行した場合のコストはどうなりますか？](#Q3)
[Q4. クラシック アラートの「通知の構成」をしているかどうかは 1 つ 1 つの Recovery Services コンテナーを確認する必要がありますか？](#Q4)
-----------------------------------------------------------

## <a id="Q1"></a>Q1. 「QL4L-5D8」このアラートは何ですか？
**A1** クラシック アラートから、Azure Monitor を使用した組み込みのアラートへと移行するよう、お知らせするためのものです。
Recovery Services コンテナーでは、クラシック アラートが<span style="color: red; ">既定</span>で存在しており、かつ、利用可能な状態となっております。
後述 「Q2. どのRecovery Services コンテナーが「クラシック アラート設定」になっていますか？」 をご参照いただき、クラシック アラートを利用した通知の設定有無をまずはご確認くださいますようお願いいたします。

#### ・クラシック アラート機能用いて、現在メールへのアラート通知を構成している場合
クラシック アラートは、2026 年 3 月 31 日をもって廃止する予定です。
監視設定を継続してご利用になられる場合は、お手数ではございますが、「Azure Monitor を使用した組み込みのアラート」への切り替えを事前にご検討くださいますようお願いいたします。

#### ・クラシック アラート機能用いて、現在メールへのアラート通知を構成していないが、今後はバックアップ ジョブ失敗時にメール通知などのアラートをご希望の場合
クラシック アラートから、「Azure Monitor を使用した組み込みのアラート」へと切り替え設定することをご検討ください。

#### ・クラシック アラート機能用いて、現在メールへのアラート通知を構成していない、かつ今後もバックアップ ジョブ失敗時にメール通知などのアラートをご希望でない場合
<span style="color: red; ">特段ユーザー様にて追加作業は不要です。</span>

・監視とレポートのシナリオ
　https://learn.microsoft.com/ja-jp/azure/backup/monitoring-and-alerts-overview#monitoring-and-reporting-scenarios

![image01](https://user-images.githubusercontent.com/96324317/230756428-28f8085a-16bf-49ab-aa50-8659f342b81e.png)

![image02](https://user-images.githubusercontent.com/96324317/230756444-3a95a6b5-dd4d-47e0-b3d1-ea3ffe54fa49.png)

![image03](https://user-images.githubusercontent.com/96324317/230756450-5d78ebd9-19e0-455b-9ba6-6f079f9cf65d.png)

## <a id="Q2"></a>Q2.どの Recovery Services コンテナーが「クラシック アラート設定」になっていますか？ 
**A2**
・既定ですべての Recovery Services コンテナーにおいて、「Azure Monitor を使用した組み込みのアラート」へと移行していない Recovery Services コンテナーは、「クラシック アラート」が有効になっており、今回の正常性アラート対象となっております
・実際に「クラシック アラート」を用いてメールへの通知構成をしているかどうかは、ユーザー様の設定次第です

#### 【どの Recovery Services コンテナーが「Azure Monitor を使用した組み込みのアラート」へと移行しておらず、クラシック アラートが有効になっているのか　確認方法】
 [バックアップ センター] ブレードの[概要] タブより、”アクティブなアラート” 項目に[以前のアラート ソリューションであるクラシック アラートを使用しているコンテナーがxx 個あります。] 
と表示されている場合、クラシック アラートが有効・利用可能となっているRecovery Services コンテナーが存在しています。

この記述がある場合は、後述される [アクションを起こすには、ここをクリック] をクリックします。

![image04](https://user-images.githubusercontent.com/96324317/230756521-74ec97f7-1147-4799-aa66-59b789ab3f69.png)

![image05](https://user-images.githubusercontent.com/96324317/230756529-fbb23335-c992-4b39-b4b9-071e280168f8.png)

[Azure Monitor アラートのみの使用をオプトイン] 画面にて、リストされているRecovery Services コンテナーを確認します。
![image06](https://user-images.githubusercontent.com/96324317/230756537-0108ce69-1a21-4052-8984-cb5833ee69f6.png)

#### 【どの Recovery Services コンテナーが、クラシック アラートの「通知の構成」を行っているのか　確認方法】

リストされた Recovery Services コンテナーが実際に通知の構成をしているかどうかは、上記でリストされたRecovery Services コンテナー＞[バックアップ アラート] ＞ ”通知の構成” ＞「メールの通知：オン」となっているかどうかで確認可能です。
![image07](https://user-images.githubusercontent.com/96324317/230756566-faba366c-1f68-4034-8f4e-bbc1f9e7bc2f.png)

通知の構成をしている Recovery Services コンテナーがある場合、[Azure Monitor アラートのみの使用をオプトイン] 画面にて、アラートの設定の更新を行います。
”通知の構成” ＞「メールの通知：オン」をしている Recovery Services コンテナーが無い場合、かつ、今後バックアップジョブの監視設定をする必要が無い場合は、下記対応は不要です。
![image08](https://user-images.githubusercontent.com/96324317/230756596-d48ec392-d5c3-4a6b-9b84-73a7e7db4b49.png)

なお、[Azure Monitor アラートのみの使用をオプトイン] 画面より、アラート設定の更新をする場合、下記の赤枠に記載されているように、メールなどの通知が必要な場合は、別途設定していただく必要があります。

詳細は下記のドキュメントを参照いただければと存じます。
・クラシック アラートから組み込みのAzure Monitor アラートに移行する
　https://learn.microsoft.com/ja-jp/azure/backup/move-to-azure-monitor-alerts#migrate-from-classic-alerts-to-built-in-azure-monitor-alerts

![image09](https://user-images.githubusercontent.com/96324317/230756610-2254377b-37ea-4205-a6e2-f6b04e959ced.png)

## <a id="Q3"></a>Q3.クラシック アラートから Azure Monitor を使用した組み込みのアラートへと移行した場合のコストはどうなりますか？ 
**A3** 「Azure Monitor を使用した組み込みのアラートが生成されること」自体に料金は発生しません。
　　一方、メールなどへアラートを通知させる場合は、少額の料金が発生いたします。
　　詳細は下記ドキュメントよりご参照ください。
 
・クラシック アラートから組み込みの Azure Monitor アラートに移行する
　 https://learn.microsoft.com/ja-jp/azure/backup/move-to-azure-monitor-alerts#migrate-from-classic-alerts-to-built-in-azure-monitor-alerts

![image10](https://user-images.githubusercontent.com/96324317/230756632-22b2968e-d899-44f4-8472-c0c5db56f0c9.png)

## <a id="Q4"></a>Q4.クラシック アラートの「通知の構成」をしているかどうかは 1 つ 1 つの Recovery Services コンテナーを確認する必要がありますか？ 
**A4** 恐縮ながら、現状はクラシック アラートの「通知の構成」部分を照会するような Azure PowerShell ・Azure CLI コマンドのご用意が無いため、ユーザー様には Azure ポータル画面の Recovery Services コンテナーを 1 つ 1 つ確認いただく必要がございます。
※　前提としてクラシック アラートの「通知の構成」をされているのであれば、ユーザー様が設定されたメールアドレスの宛先へと、バックアップ ジョブ失敗時などに通知がなされています。

その他確認手段の 1 つとして、以下のような REST API を発行することで確認が可能ですので、参考として紹介いたします。
※　以下 REST API は、本ブログ発行時点で確認可能な手段であり、事前予告なく返却値が変わる可能性がありますこと、ご了承ください。
　　以下 REST API は、あくまで参考としてご連携するサンプル コマンドでございます。
　　コマンド実装をされる場合は貴社にて検証のうえ、実施いただきますようご留意ください。
　　また、Azure サポートでは主に Post Production の Break & Fix を担当しており、スクリプトのコードレビューのサポートは承っておりませんので、ご理解をいただけますと幸いです。

```
### クラシックアラートのメール通知が有効化されているかを確認する 
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

# Recovery Services コンテナーごとに API へリクエストを送り、結果を取得する ※1
foreach ( $rsv in $RSVList ) {
    $uri = "https://management.azure.com/subscriptions/$($rsv.SubscriptionId)/resourceGroups/$($rsv.ResourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$($rsv.Name)/monitoringConfigurations/notificationConfiguration?api-version=2017-07-01-preview"
    $response = (Invoke-RestMethod -Uri $uri -Method Get -Headers $headers).properties
    $results += @([pscustomobject]@{subscriptionID = $rsv.SubscriptionId; resourceGroupName = $rsv.ResourceGroupName; recoveryServicesContainerName = $rsv.Name; isClassicAlertNotificationEnabled = $response.areNotificationsEnabled; mailRecipients = $response.additionalRecipients -join '; ' })
}

# 全ての結果をコンソール出力
$results | Sort-Object isClassicAlertNotificationEnabled -Descending | ForEach-Object { Write-Output $_ | Format-Table }
```
上記 REST API を発行した場合、「isClassicAlertNotificationEnabled：True」となっている Recovery Services コンテナーが「通知の構成：オン」となっているものとなります。
![image11](https://user-images.githubusercontent.com/96324317/230820217-777e48c3-f704-4e83-9aeb-1a5b107633af.png)

![image12](https://user-images.githubusercontent.com/96324317/230820265-bcb0a6df-eae6-4946-b0f9-c1f905a539d4.png)

![image13](https://user-images.githubusercontent.com/96324317/230820287-06940bef-a423-4202-a016-e3ec7bd79489.png)

![image14](https://user-images.githubusercontent.com/96324317/230820315-3f9dc117-bfac-4e73-b0aa-d37a12503390.png)





























