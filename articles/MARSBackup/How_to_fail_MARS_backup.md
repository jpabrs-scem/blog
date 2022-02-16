---
title: MARS バックアップ を意図的に失敗させる方法
date: 2022-02-17 12:00:00
tags:
  - MARS Backup 
  - howto
disableDisclaimer: false
---

<!-- more -->
皆様こんにちは、Azure Backup サポートの 山本 です。
アラートのテスト等のため " Azure MARS Backup エージェントを利用したバックアップ (以下MARSバックアップ) を失敗させたい" というお問い合わせをよくいただきます。
今回は、**MARS バックアップ を意図的に失敗させる方法**について、ご案内いたします。

なお、下記では Azure VM Backup を失敗させる方法について紹介しておます。
・Azure VM Backup を意図的に失敗させる方法 | Japan CSS ABRS & SCEM Support Blog (jpabrs-scem.github.io)
https://jpabrs-scem.github.io/blog/AzureVMBackup/How_to_fail_VM_backup/


### 意図的に MARS バックアップ エラーを発生させる仕組み
バックアップ対象にフォルダを指定し、ポリシーを設定した後、対象のフォルダ名を変更します。そうすることでバックアップ対象のフォルダがない為にバックアップが失敗します。

### MARS バックアップ を失敗させる方法(手順)
* 以下は MARS エージェントがインストールされているリソース内での作業となります。

#### 1. MARSエージェントのスケジュールバックアップ設定よりテスト用のフォルダをバックアップ対象として選択し、設定します。その他の設定は任意の設定で問題ございません。
(画像ではデスクトップ上の test フォルダを対象として選択しています)
 ![](https://user-images.githubusercontent.com/71251920/154327014-9a8eb2b3-13e5-48f3-905c-031ae5e7126a.jpg)

#### 2. 上記でバックアップ対象としたフォルダ名を変更します。
(画像ではtestフォルダをtest_changeフォルダと変更しました)
 ![](https://user-images.githubusercontent.com/71251920/154327016-1281d20b-feb2-4524-8ea5-fa50cecf8359.jpg)

#### 3. 今すぐバックアップを実行します。
　バックアップ期間は任意の期間で問題ありません。
 ![](https://user-images.githubusercontent.com/71251920/154327019-106c84e8-9bc7-4df5-9aa3-854e399666ac.jpg)

#### 4. 確認画面にて、1で設定した名前変更前のフォルダが指定されてることを確認し、バックアップを実施してください。
 ![](https://user-images.githubusercontent.com/71251920/154327020-f8d375b6-033a-45fb-a5f0-d6c4aafbfe01.jpg)

#### 5. バックアップの失敗のメッセージが現れることを確認してください。
下記画像では Status Details に　Job failed と表示されています。
 ![](https://user-images.githubusercontent.com/71251920/154327021-05c22aec-45ec-4adf-b615-04dc7424662d.jpg)

###　アラート例
下記のような Azure Backup の組み込みアラートを設定している場合アラートがメールで通知されます。
![組み込みアラート](https://user-images.githubusercontent.com/71251920/154327023-c5e4526e-9e9f-4c25-b2b3-faa4bb6f9705.jpg)

![アラート通知メール](https://user-images.githubusercontent.com/71251920/154327010-0a5c3e60-a3f3-4919-860d-98a8ae1530d3.jpg)

><原文>Description: Backup failed as none of the items specified as part of the backup policy exist.
>><抄訳>説明：バックアップポリシーの一部として指定された項目が存在しないため、バックアップが失敗しました。