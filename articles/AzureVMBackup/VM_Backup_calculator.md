---
title: 料金計算ツールを用いた Azure VM Backup の料金見積もりついて
date: 2021-12-16 12:00:00
tags:
  - Azure VM Backup
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートです。
今回は、料金計算ツールを用いた Azure VM Backup の料金見積もりついて、ご案内いたします。


Azure VM Backup ではバックアップ ジョブのスケジュールを日時、週次にて計画することができます。
一方、現状の料金計算ツールでは週次のバックアップ スケジュールのシナリオに対応しておらず日次のシナリオのみの見積もりが可能となっております。
そのため、現時点では週次の見積もりに計算ツールを利用していただくことが叶いません。
・料金計算ツール
https://azure.microsoft.com/ja-jp/pricing/calculator/

下記の赤枠部分が必須となっております。
![vm_backup_calculator](https://user-images.githubusercontent.com/71251920/146237377-08217f47-4afa-45d5-a112-7c572e5187cc.png)

現在、週次シナリオも課金ツールにて見積もりができるよう弊社開発部門へのフィードバックが複数行われております。
お客様側では以下のサイトを通じてステータスを確認することが可能です。
 
・The scenario in Pricing Calculator to run only weekly backup.
https://feedback.azure.com/d365community/idea/7aa7fd4a-0925-ec11-b6e6-000d3a4f0858
 
上記サイトは機能改善のリクエストを行うサイトであり、リクエストの中で Vote (改善要望) が多いものや影響度の大きいものを判断して優先して修正に取り組みます。
そのため、もし週次のスケジュール見積もりを今後ご要望の場合には、お手数ではございますが可能であれば上記の URL より機能改善リクエストに Vote いただけますと幸いです。
Vote の際にはメールアドレスを入力することができ、本投稿が Completed した際に指定のメールアドレスに通知される仕組みとなっております。



