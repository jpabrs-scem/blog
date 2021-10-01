---
title: スケジュールされたバックアップを無効化したい
date: 2021-10-01 12:00:00
tags:
  - Azure Backup 
disableDisclaimer: false
---

<!-- more -->
#### スケジュールされたバックアップを無効化したい
皆様こんにちは。Azure Backup サポートの谷脇です。
今回はお問い合わせをいただくことが多い、 任意のタイミングのみでバックアップの取得をしたい、というご要望について解説します。

まず、Azure Backup はバックアップ ポリシーを利用したスケジュールされたバックアップを取得する運用を想定した製品仕様となっております。そのため、弊社としては、任意のタイミングのみでバックアップを取得していただく運用を推奨しておりません。
一方、上記のように任意のタイミングのみでバックアップを行いたいというご要望は多く寄せられております。
任意のタイミングのみでバックアップを取得する運用を行う際の懸念点がございますので以下にてご紹介します。
懸念点を踏まえ、任意のタイミングのみでバックアップを取得する運用方法について解説させていただきます。


以下の文章では、任意のタイミングで取得していただくバックアップを [アドホック バックアップ] 、スケジュールされ取得していただくバックアップを [スケジュール バックアップ] としています。

[アドホック バックアップのみを取得する運用を行う際の懸念点]
通常時、バックアップ ポリシーを無効化 (バックアップの停止) し、必要なときだけバックアップを有効化しアドホック バックアップを取得する場合、下記のような懸念点が考えられます。

Azure Poretal からバックアップ アイテムを選択し、[バックアップの停止] を行うことが出来ます。

![Stop Azure VM Backup](https://user-images.githubusercontent.com/71251920/135618848-76248e66-8013-452e-a471-c4f7c8c37281.png)


バックアップ ポリシーを無効化すると Garbage Collection と呼ばれる、クリーンアップが実行されず、期限切れ復旧ポイントや復旧ポイントのメタデータがクリーンアップされません。
メタデータがたまることによって最短で 18 個以上復旧ポイントがたまった場合に、それ以降のバックアップが取得できなくなる可能性があります。
 
バックアップが有効化されている場合、Garbage Collection が一日 (24 時間) のうちどこかで行われる仕様ですので、上記エラーは通常は発生いたしません。


上記の懸念点を踏まえ、アドホック バックアップのみでの運用方法をご紹介します。

[アドホック バックアップのみを取得する運用を行う方法]
あくまで一例ですが、週に一度 48 時間程度バックアップを有効化していただくことでGarbage Collection を実行する方法がございます。
(バックアップを有効化した状態で、24 時間のうちどこかで Garbage Collection が実行されますので、目安として 48 時間としています。)
こちらの方法で定期的に Garbage Collection を行うことが出来ます。
 
[具体的な運用方法の例]
週１回 水曜日にバックアップを実行するスケジュールを組んだバックアップ ポリシーを作成し、適用します。
平日は [バックアップの停止] をし、週末の土曜日、日曜日だけ [バックアップの再開] をします。

上記の運用でしたら、アドホック バックアップを取得せず、週末に Garbage Collection を実行させる運用が可能です。

また、スケジュール バックアップが不要で、バックアップの頻度が低く、オフライン バックアップ (VM が停止した状態で取得するバックアップ) の取得をされる場合、Azure Backup 以外のサービスを用いていただく、以下のようなディスクのスナップショットを用いる代替案もございます。

[代替案]
ディスクのスナップショットを用いる代替案です。
保持期限などはなく、任意のタイミングで削除できます。
スナップショットからディスクを作成することができ、そこから VM に対してディスクのスワップや新規 VM の作成を行うことができます。
 
ディスクのスナップショットに関しましては下記ドキュメントに記載がございます。
・ VM を停止 (割り当て解除) し、OS ディスクの [スナップショット] を取得
https://jpaztech.github.io/blog/vm/vm-replica-3/#2-VM-%E3%82%92%E5%81%9C%E6%AD%A2-%E5%89%B2%E3%82%8A%E5%BD%93%E3%81%A6%E8%A7%A3%E9%99%A4-%E3%81%97%E3%80%81OS-%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%81%AE-%E3%82%B9%E3%83%8A%E3%83%83%E3%83%97%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88-%E3%82%92%E5%8F%96%E5%BE%97
 
・ポータルまたは PowerShell を使用してスナップショットを作成する
https://docs.microsoft.com/ja-jp/azure/virtual-machines/snapshot-copy-managed-disk?tabs=portal