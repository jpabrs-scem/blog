---
title: Migrate 移行後の関連リソース削除時のチェックポイント
date: 2025-01-29 12:00:00
tags:
  - Azure Migrate
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Migrate サポートです。
今回は Azure Migrate 機能を使って Azure へとマシンを移行後、不要となった Recovery Services コンテナーや、関連する Azure リソースを削除するときのポイントを説明します。

## 目次
-----------------------------------------------------------
[ポイント 1 : Recovery Services コンテナー以外にも削除すべきリソースがあります](#1)
[ポイント 2 : Recovery Services コンテナーの削除前に削除が必要なリソースがあります](#2)
-----------------------------------------------------------

## <a id="1"></a> ポイント 1 : Recovery Services コンテナー以外にも削除すべきリソースがあります
Azure Migrate 機能を使って Azure へとマシンを移行後、Azure Migrate 関連のリソースを削除したいという場合には
削除すべき Azure リソースは「Recovery Services コンテナー」リソース以外にも複数あります。
また
- プライベート エンドポイント経由で Azure へと移行したのか
- 物理マシンを Azure へと移行したのか
- VMWare VM をエージェントレス方式で移行したのか

といったシナリオによって、削除対象となる Azure リソースが異なってまいります。
どのシナリオで、どの Azure リソースが削除対象になるのかは下記ドキュメントにまとめておりますので、シナリオ毎に確認ください。

- (参考) Azure Migrate プロジェクトの削除
  https://learn.microsoft.com/ja-jp/azure/migrate/how-to-delete-project


## <a id="2"></a> ポイント 2 : Recovery Services コンテナーの削除前に削除が必要なリソースがあります
Azure Migrate プロジェクトに紐づいている Recovery Services コンテナーを削除する際には
順番として先に削除すべき Azure リソースがあります。
(先に削除しておかなければ、多くの場合 Recovery Services コンテナーの削除を指示してもエラーとなって Recovery Services コンテナーを削除できません。)

例えば
- Recovery Services コンテナーに登録されているレプリケーション ポリシーの削除
- Recovery Services コンテナーに登録されている Hyper-V サイトの削除
- Recovery Services コンテナーに紐づくプライベート エンドポイントの削除

が事前に必要となります。

- (参考) ポリシーを編集する | レプリケーション ポリシーの関連付け解除と削除
  https://learn.microsoft.com/ja-jp/azure/site-recovery/vmware-azure-set-up-replication#edit-a-policy

- (参考) VMM サーバーの登録解除
  https://learn.microsoft.com/ja-jp/azure/site-recovery/site-recovery-manage-registration-and-protection#unregister-a-vmm-server

- (参考) Hyper-V サイト上の Hyper-V ホストの登録解除
  https://learn.microsoft.com/ja-jp/azure/site-recovery/site-recovery-manage-registration-and-protection#unregister-a-hyper-v-host-in-a-hyper-v-site

![](./howtodeleteRSV/001.png)

また、Recovery Services コンテナーと関連するリソースに対し、削除のロックがかかっている場合、ロックを解除してから削除する必要があります。
ロックについては、ご利用の Azure Migrate プロジェクトのリソース グループ > ロックからロックされているリソースが確認できます。
![](./howtodeleteRSV/002.png)

なお、Azure Migrate 関連の Azure リソースを確認する際には、Azure Migrate プロジェクトのリソース グループ > <font color="Red">[非表示の型の表示] </font>をクリックすることで、関連するすべてのリソースが表示されるようになります。
![](./howtodeleteRSV/003.png)

Azure Migrate 観点では、移行が完了しており、かつ対象の Recovery Services コンテナーが現在その他のレプリケーション等で使用されていない場合、対象の Recovery Services コンテナーの削除を行っても **移行元VM ・移行先 Azure VM・ネットワークには影響致しません。**
対象の Recovery Services コンテナーが使用されているかどうかの確認 (現在バックアップもしくはレプリケーションが行われているかどうかの確認) は、お客様にてご確認の上、削除の判断をお願いいたします。

本記事の内容は以上となります。
