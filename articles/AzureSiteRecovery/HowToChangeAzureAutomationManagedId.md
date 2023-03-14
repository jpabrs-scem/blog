---
title: ASR 自動更新に利用する Automation アカウントの Managed ID への移行方法について
date: 2023-03-14 12:00:00
tags:
  - Azure Site Recovery
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Site Recovery サポートです。
今回は、Azure Site Recovery ( 以下、ASR ) にて使用される、マネージド ID の設定についてのご案内です。

ASR 自動更新には Azure Automation の実行アカウントが利用されますが、Azure Automation 実行アカウントは 2023 年 9 月 30 日に廃止されることが決まっており、マネージド ID へ移行する必要がございます。
2023/3/14 時点では ASR の自動更新に利用する Azure Automation を手動でマネージド ID へ移行する必要がございますので、その移行手順についてご案内いたします。

なお、今後は ASR 有効化時に自動でマネージド ID の Azure Automation が作成されるように開発部門と対応を継続しておりますので、進展がありましたら本ブログにて Update をお知らせいたします。

・マネージド ID への移行に関する公開情報
　https://learn.microsoft.com/ja-jp/azure/automation/migrate-run-as-accounts-managed-identity?tabs=sa-managed-identity


### 作業手順
1. Azure Portal から Recovery Services コンテナーに移動し、[概要] の JSON ビューをクリックし、ID の行に表示される /subscriptions/ から始まるリソース ID をメモします。
※ 手順 8 で利用します。

![image1](https://user-images.githubusercontent.com/96324317/224874128-5a6427e3-6899-4cf8-bfbd-024334f58aaf.png)

![image2](https://user-images.githubusercontent.com/96324317/224874595-4ed973c2-4611-4548-8591-da9a1cb087e6.png)

2. Recovery Services コンテナーの [Site Recovery インフラストラクチャ] - [拡張機能の更新の設定] 画面ご利用の Automation アカウント名をご確認ください。

![image3](https://user-images.githubusercontent.com/96324317/224874725-db03352c-829b-449a-ba34-88303a551f6d.png)

3. 手順 2 で確認した Automation アカウントに移動し、  JSON ビューをクリックし、ID の行に表示される /subscriptions/ から始まるリソース ID をメモします。
※ 手順 9 で利用します。

![image4](https://user-images.githubusercontent.com/96324317/224874882-b6ccc582-13c4-4553-9d1f-9b9e4425b6db.png)

![image5](https://user-images.githubusercontent.com/96324317/224874916-5df9c1cb-92c0-4263-9f9c-16ece1912dd9.png)

4. Automation アカウントの [ID] - [システム割り当て済み] 画面から状態が [オン] に選択されていない場合には、[オン] を選択し、[保存] をクリックします。

![image6](https://user-images.githubusercontent.com/96324317/224874986-a883cb50-8fe5-4f05-b0c4-4c72cdc8d2f4.png)

5. Recovery Services コンテナーに戻り、[アクセス制御 (IAM)] から、Automation アカウントのマネージド ID に対して共同作成者ロールを付与します。

・ロール : 共同作成者
・アクセスの割り当て先 : マネージド ID
・メンバー :Automation アカウント

![image7](https://user-images.githubusercontent.com/96324317/224875166-74a13c8e-d825-4bf7-97a5-18dd1855a576.png)

![image8](https://user-images.githubusercontent.com/96324317/224875187-021d493c-8ef9-4370-af8d-3aaedb04b611.png)

![image9](https://user-images.githubusercontent.com/96324317/224875252-a24fbdc4-2e71-4c89-9890-7b75530eb754.png)

![image10](https://user-images.githubusercontent.com/96324317/224875281-150ab88d-36b1-4b95-a9a2-c4a17cbc116b.png)

6. Automation アカウントに戻り、[Runbook] - [Runbook の作成] から新しい Runbook を作成します。

![image11](https://user-images.githubusercontent.com/96324317/224875348-6f138351-c0af-43ac-bd3c-8ef25d3372f0.png)

・Runbook 名 : <任意>
・Runbook の種類 : PowerShell
・ランタイムのバージョン : 5.1

![image12](https://user-images.githubusercontent.com/96324317/224875466-44010fb0-2420-4753-b804-7130434a902a.png)

7. 作成された Runbook に、下記 Github に公開されている UpdateAutomationAccount.ps1 の PowerShell スクリプトをコピーして貼り付け [保存] します。

・PowerShell スクリプト 
　https://github.com/AsrOneSdk/published-scripts/blob/master/automationAccount/UpdateAutomationAccount.ps1

![image13](https://user-images.githubusercontent.com/96324317/224875619-9e10064b-923a-4fdc-a6d9-5d641a04f188.png)

8. 上部 [テスト ウィンドウ] からテスト画面に移動し、パラメーターを入力し [開始] をクリックします。

![image14](https://user-images.githubusercontent.com/96324317/224875673-cd3d487c-21bf-448c-9536-3cfecf19f2cb.png)

・VAULTRESOURCEID : 手順 1 で確認した Recovery Services コンテナーのリソース ID
・AUTOUPDATEACTION : Disabled
・AUTOMATIONACCOUNTARMID : 入力なし

![image15](https://user-images.githubusercontent.com/96324317/224875714-04847fc0-45fc-4aae-9d61-584fbe1a9768.png)

完了と表示されるとテスト成功です。

![image16](https://user-images.githubusercontent.com/96324317/224875759-fb94ba3e-061d-4ffe-b2b3-1407ad881b8d.png)

9. パラメータ AUTOUPDATEACTION を Enabled に変更し、AUTOMATIONACCOUNTARMID にリソース ID を入力し、再度 [開始] をクリックします。

・VAULTRESOURCEID : 手順 1 で確認した Recovery Services コンテナーのリソース ID
・AUTOUPDATEACTION : Enabled
・AUTOMATIONACCOUNTARMID : 手順 3 で確認した Automation アカウントのリソース ID

![image17](https://user-images.githubusercontent.com/96324317/224875812-93a0ec82-db28-4b82-b5c5-dc930d084dde.png)

完了と表示されるとテスト成功です。

![image](https://user-images.githubusercontent.com/96324317/224875967-f561d126-42e6-4c70-9889-39f4e94793f8.png)

10. 画面右上の [X] から画面を一度閉じ、Runbook に戻り [公開] をクリックします。

![image](https://user-images.githubusercontent.com/96324317/224876010-8b07de47-3926-4233-8e3f-c188552281bc.png)

11. Runbook のステータスが "発行済み" になっていることを確認し、[スケジュールへのリンク] をクリックし、スケジュールを設定します。

![image](https://user-images.githubusercontent.com/96324317/224876087-d5649f14-4b30-441b-8bb6-6e2b73c4b1cd.png)

12. [スケジュール] をクリックし、既存のスケジュールを利用するか新規スケジュールを作成します。
※ 既定では 0:00 に毎日ジョブが実行され、最新バージョンでない保護されたアイテムがある場合に ASR モビリティ サービス エージェントを更新する処理がトリガーされます。

![image](https://user-images.githubusercontent.com/96324317/224876152-99f45670-ee44-4220-8127-a976ab9fe546.png)


新規スケジュールを作成する場合には、任意のスケジュールを設定します。
例えば、日本時刻 0:00 に毎日ジョブを実行する場合、下記のように入力します。

![image](https://user-images.githubusercontent.com/96324317/224876230-77381459-a13e-45d2-a89f-16d85f54d8b8.png)

13. [パラメーターと実行設定] をクリックし、手順 9 で入力したパラメータを以下の通り再度入力し [OK] をクリックします。

・VAULTRESOURCEID : 手順 1 で確認した Recovery Services コンテナーのリソース ID
・AUTOUPDATEACTION : Enabled
・AUTOMATIONACCOUNTARMID : 手順 3 で確認した Automation アカウントのリソース ID

![image](https://user-images.githubusercontent.com/96324317/224876291-5fab5687-0573-484c-b369-d26907b94b0d.png)

![image](https://user-images.githubusercontent.com/96324317/224876315-d42595ed-2813-4fd4-99c0-163c6b9d4705.png)

上記作業が完了したら、次のスケジュール日時からマネージド ID を使用した Runbook にて更新ジョブが実行されます。

ASR にて使用される、マネージド ID 設定の案内は、以上となります。