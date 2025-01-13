---
title: Migrate 移行後の Recovery Services コンテナー削除のチェックポイント
date: 2023-08-11 12:00:00
tags:
  - Azure Migrate
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Migrate サポートです。

今回は Azure Migrate の利用完了後、不要な Recovery Services コンテナー削除時に必要なチェック ポイントいついて説明させて頂きます。


## 目次
[1.オンプレミス環境から Azue へフェールオーバーを行う際、引き継がれるリソースと引き継がれないリソースの一覧について](#1)

[2. Recovery Services コンテナー削除時の注意点](#2)

[3.  Azure Migrate のプロジェクト削除について](#3)

## <a id="1"></a> 1. Azure Migrate 移行後、Recovery Services コンテナー削除について

Azure Migrate 移行後、Recovery Services コンテナー削除するためには、**事前に Recovery Services コンテナーと関連したリソース全てを削除する必要がございます。**
例えば、Recovery Services コンテナーに登録されている Hyper-V サイトの削除 ・ Recovery Services コンテナーに登録されているバックアップ ポリシーの削除、Recovery Services コンテナーのプライベート エンドポイントの削除が必要となっております。

例えば、Recovery Services コンテナーに登録されている Hyper-V サイトの削除 ・ Recovery Services コンテナーに登録されているバックアップ ポリシーの削除、Recovery Services コンテナーのプライベート エンドポイントの削除が必要となっております。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/3567fc52-6be4-4805-87fc-90ade3fe44be)


また、Recovery Services コンテナーおよび関連したリソースに対し、削除のロックがかかっている場合、ロックを解除してから削除する必要がございます。
ロックについては、ご利用の Azure Migrate プロジェクトのリソース グループ > ロックからロックされているリソースが確認できます。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/2a489497-b6c3-4d47-846f-525a5a0f202d)


## <a id="2"></a> 2. Recovery Services コンテナー削除時の注意点について

Azure Migrate 観点では、移行が完了しており、かつ対象の Recovery Services コンテナーが現在レプリケーション等で使用されていない場合、対象の Recovery Services コンテナーの削除を行っても **VM やネットワークには影響致しません。**
対象の Recovery Services コンテナーが使用されているかどうかの確認 (現在バックアップもしくはレプリケーションが行われているかどうかの確認) は、お客様ご自身の判断となります為、ご確認の上、削除の判断をお願いいたします。

## <a id="3"></a> 3. Azure Migrate のプロジェクト削除について

ご利用のシナリオ (V2A エージェント ベース ・ V2A エージェントレス、H2A, P2A)、プライベート エンドポイントの利用有無について削除が必要なリソースが異なります。
そのため、以下公開情報から削除が必要なリソースを事前にご確認の上、削除の作業のご実行をお願い致します。

例えば、Azure Migrate V2A エージェントレスのシナリオにてプライベート エンドポイントをご利用の場合、Azure Migrate プロジェクトのリソース グループ > [非表示の型の表示] をクリックし、以下のりソースを削除する必要がございます。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/0bf24f51-ec30-4711-b3f5-0350c6b83129)

公開情報) [Azure Migrate プロジェクトの削除](https://learn.microsoft.com/ja-jp/azure/migrate/how-to-delete-project)

本記事の内容は以上となります。
