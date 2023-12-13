---
title: Migrate 移行後の Recovery Services コンテナー削除のチェックポイント
date: 2023-12-10 12:00:00
tags:
  - Azure Site Recovery
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは! ABRS チームです。
今回は Azure Migrate の利用完了後、不要な Recovery Services コンテナー削除時に必要なチェック ポイントいついて説明させて頂きます。

## 目次
[1. Azure Migrate 移行後、Recovery Services コンテナー削除時のチェックポイントについて](#1)

[2. Recovery Services コンテナー削除時の注意点](#2)

[3. Azure Migrate 移行後、Recovery Services コンテナー削除方法について](#3)

## <a id="1"></a> 1. Azure Migrate 移行後、Recovery Services コンテナー削除時のチェックポイントについて

Azure Migrate 移行後、Recovery Services コンテナー削除するためには、**事前に Recovery Services コンテナーと関連したリソース全てを削除する必要がございます。**
例えば、Recovery Services コンテナーに登録されている Hyper-V サイト、Hyper-V ホスト ・ Recovery Services コンテナーに登録されているバックアップ ポリシー ・ レプリケーション ポリシー、Recovery Services コンテナーのプライベート エンドポイント等を削除する必要がございます。

![image](https://github.com/jpabrs-scem/blog/assets/141316175/d2071ac3-4ffd-4980-b5d8-6b7dc6735f5e)

![image](https://github.com/jpabrs-scem/blog/assets/141316175/844dca44-0071-4d7e-b506-9d8448635017)


詳細は、以下の公開情報をご参照ください。

公開情報) [サーバーの削除と保護の無効化 - Azure Site Recovery | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/site-recovery/site-recovery-manage-registration-and-protection)

また、Recovery Services コンテナーおよび関連したリソースに対し、削除のロックがかかっている場合、ロックを解除してから削除する必要がございます。
ロックについては、ご利用の Azure Migrate プロジェクトのリソース グループ > ロックからロックされているリソースが確認できます。

**以下は弊社検証環境の画面でございますので、ご参照ください。**

![image](https://github.com/jpabrs-scem/blog/assets/141316175/89cfbce9-bdbe-4f8f-a1c5-6ee0fd329131)


公開情報) [Azure Site Recovery コンテナーを削除する - Azure Site Recovery | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/site-recovery/delete-vault)

## <a id="2"></a> 2. Recovery Services コンテナー削除時の注意点について

Azure Migrate 観点では、移行が完了しており、かつ対象の Recovery Services コンテナーが現在レプリケーション等で使用されていない場合、<span style="color: red; ">対象の Recovery Services コンテナーの削除を行っても VM やネットワークには影響致しません。</span>
対象の Recovery Services コンテナーが使用されているかどうかの確認 (現在バックアップもしくはレプリケーションが行われているかどうかの確認) は、お客様ご自身の判断となります為、ご確認の上、削除の判断をお願いいたします。

## <a id="3"></a> 3. Azure Migrate 移行後、Recovery Services コンテナー削除方法について

Azure Migrate 移行後、Recovery Services コンテナー削除方法は、公開情報にて案内する Azure Migrate プロジェクトの削除方法と同様でございます。

Azure Migrate 移行後、Recovery Services コンテナー削除方法 :

1. Azure Portal にサインインします。
(※ Azure Portal にサインインしたユーザー アカウントが、リソース グループに対し所有者または共同作成者のアクセス許可を持つ必要がございます。)
2. Azure Migrate プロジェクトのリソース グループをクリックします。
3. リソース グループ >  [非表示の型の表示] をクリックします。
4. 右側の ・・・ ボタンをクリックし、Recovery Services コンテナーを削除します。

Recovery Services コンテナーはどの Azure Migrate のシナリオでも利用されますが、**一部のりソースにつきましては、ご利用のシナリオ (V2A エージェント ベース ・ V2A エージェントレス、H2A, P2A)、プライベート エンドポイントの利用有無) ごとに異なります。**
そのため、以下公開情報から削除が必要なリソースを事前にご確認の上、削除の作業のご実行をお願い致します。

公開情報) [Azure Migrate プロジェクトの削除 - Azure Migrate | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/migrate/how-to-delete-project)

![image](https://github.com/jpabrs-scem/blog/assets/141316175/a781d68c-a650-4566-b042-f2978e08a855)

本記事の内容は以上となります。
