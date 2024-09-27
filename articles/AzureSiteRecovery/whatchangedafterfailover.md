---
title: ASR フェールオーバー時で引き継がれる、引き継がれないリソースについて 
date: 2023-12-10 12:00:00
tags:
  - Azure Site Recovery
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Site Recovery サポートです。

今回は Azure Site Recovery を利用してオンプレミス環境のサーバーを Azure へフェールオーバーする時、引き継がれるリソースと引き継がれないリソースについてご説明させていただきます。


## 目次

[1.オンプレミス環境から Azue へフェールオーバーを行う際、引き継がれるリソースと引き継がれないリソースの一覧について](#1)

[2. IP アドレスについて](#2)

[3. UUID (GUID) について](#3)

[4. MAC アドレスについて](#4)

[5.SID について](#5)

-----------------------------------------------------------

## <a id="1"></a> 1. オンプレミス環境から-Azue-へフェールオーバーを行う際、引き継がれるリソースと引き継がれないリソースの一覧

以下の表にてオンプレミス環境から Azure へフェールオーバーを行う際、引き継がれるリソースと引き継がれないリソースを表にまとめさせていただきました。

|フェールオーバー後、引き継がれないリソース|フェールオーバー後、引き継がれるリソース|
|---------------------------|---------------------------|
|パブリック IP アドレス|プライベート IP アドレス ※条件付き|
|一時ディスクの UUID (GUID) |一時ディスク意外の UUID (GUID) |
|MAC アドレス||
||SID|
||ホスト名|
||Azure VM 名 ※条件付き|

## <a id="2"></a> 2. IP アドレスについて

オンプレミス環境から Azure へ移行する時、パブリック IP アドレスは変更されます。

**その反面、プライベート IP アドレスは、オンプレミス環境と同様なアドレスを Azure 上でも維持することができます。**
ただし、移行先 (= Azure 上) に同じ IP アドレス空間のサブネットを用意いただく必要がございます。

ターゲットの Azure VM がオンプレミスのサイトと同じ IP アドレス/サブネットを使用している場合は、アドレスが重複しているため、サイト間 VPN 接続または ExpressRoute を使用してそれらを接続することはできませんので、ご注意ください。

プライベート IP アドレスを維持する手順は、以下公開情報をご参照ください。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/a9feef31-a01d-4897-b8eb-2fc8912208c9)

公開情報) [Azure Site Recovery を使用したAzureVM オンプレミス フェールオーバーへの接続- Azure Site Recovery | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/site-recovery/concepts-on-premises-to-azure-networking#assign-an-internal-address)

## <a id="3"></a> 3. UUID (GUID) について

Linux/Windows どちらの環境においても、マネージド ディスクのパーティションの UUID (GUID) は変わりません。
しかし、一時ディスクの UUID (GUID) は変化します。

Azure Linux VM の一時ディスクは通常 /dev/sdb です。
Windows VM の一時ディスクは既定で D: です。
一時ディスクは、システムによって用いられるもので、ユーザーが意図して利用するものではないため、基本的に影響はございません。

<Windows 環境での確認結果>
Windows では、mountvol コマンドから GUID を確認することが可能です。

■ フェールオーバー前の Windows VM (Windows Server 2022 Datacenter - x64 - Gen2)

```
PS C:\Users\localadmin> mountvol
...
Possible values for VolumeName along with current mount points are:
\?\Volume{0d7ed59f-ce59-43fd-8da0-5508c9fda535}
*** NO MOUNT POINTS ***
\?\Volume{ddb26a41-ba8f-43a5-a423-435e682e3dba}
C:
\?\Volume{9dfd54ac-0000-0000-0000-100000000000}
D:
\?\Volume{9dbed00d-2dae-4207-b412-33f48ab73c76}
*** NO MOUNT POINTS ***
```

■ フェールオーバー後の Windows VM (Windows Server 2022 Datacenter - x64 - Gen2)

```
PS C:\Users\localadmin> mountvol
…
Possible values for VolumeName along with current mount points are:
\?\Volume{0d7ed59f-ce59-43fd-8da0-5508c9fda535}
*** NO MOUNT POINTS ***
\?\Volume{ddb26a41-ba8f-43a5-a423-435e682e3dba}
C:
\?\Volume{33f73da1-0000-0000-0000-100000000000}
D:
\?\Volume{9dbed00d-2dae-4207-b412-33f48ab73c76}
*** NO MOUNT POINTS ***
```

<Linux環境 (RHEL 8.7) での確認結果>
RHEL では、/dev/disk/by-uuid から UUID を確認できます。

■ フェールオーバー前の Linux VM (RHEL 9.0 (64bit) - Gen2)

```
[root@a2a-asr-rhel90 ~]# ls -l /dev/disk/by-uuid
total 0
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 09972c86-a50d-45be-a074-43077ddb73a0 -> ../../dm-3
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 180d4ab1-2b25-432b-b677-db082459b3f6 -> ../../dm-2
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 3ec0d040-8b48-4cb1-af5a-c630b92ef397 -> ../../dm-1
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 79a5a804-60cf-4ea9-9a71-1eeefc1eac1a -> ../../dm-0
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 9fa04d09-0e78-4058-aaf6-78f58e0d6cbe -> ../../dm-4
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 b17c6103-0db7-4670-9c98-9ee451047ce2 -> ../../sda2
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 e215131b-8a07-4a29-9682-a4819db8c860 -> ../../sdb1
lrwxrwxrwx. 1 root root 10 Jul 26 09:01 EDBC-D1CA -> ../../sda1
[root@a2a-asr-rhel90 ~]#
```

■ フェールオーバー後の Linux VM (RHEL 9.0 (64bit) - Gen2)

```
[root@a2a-asr-rhel90 ~]# ls -l /dev/disk/by-uuid
total 0
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 09972c86-a50d-45be-a074-43077ddb73a0 -> ../../dm-3
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 180d4ab1-2b25-432b-b677-db082459b3f6 -> ../../dm-2
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 343402F63402BB3E -> ../../sdb1
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 3ec0d040-8b48-4cb1-af5a-c630b92ef397 -> ../../dm-1
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 79a5a804-60cf-4ea9-9a71-1eeefc1eac1a -> ../../dm-0
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 9fa04d09-0e78-4058-aaf6-78f58e0d6cbe -> ../../dm-4
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 b17c6103-0db7-4670-9c98-9ee451047ce2 -> ../../sda2
lrwxrwxrwx. 1 root root 10 Jul 26 10:00 EDBC-D1CA -> ../../sda1
[root@a2a-asr-rhel90 ~]#
```

## <a id="4"></a> 4. MAC アドレスについて

オンプレミス環境から Azure へフェールオーバーされるたび、新しい NIC が付与されます。
この NIC の情報には MAC アドレスも含まれているため、MAC アドレスも変わります。

Windows OS の場合、ipconfig/all コマンドから確認ができます。

■ フェールオーバー前の VM の MAC アドレス ：00-0D-3A-15-91-AC

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/31bd5d92-6490-45c5-9a87-b1c21826d7b2)

■ フェールオーバー後の VM の MAC アドレス：00-0D-3A-3A-E5-26

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/f3d66e75-5a84-4083-aab5-6b1aef3e5eac)

## <a id="5"></a> 5. SID について
Azure Site Recovery (= Azure Migrate) の仕様上、移行元サーバーと移行先のサーバーの SID は同様となっております。
そのため、sysprep コマンドを実行し、オペレーティング システムを一般化し、特定のコンピューター固有の情報を削除する必要がございます。
sysprep を利用しない状態で同じネットワーク (Active Directory) 内で SID が重複するマシンが同時に起動している状態は、Windows OS としてサポートされません。

**_<span style="color: red; ">予期せぬ問題を回避するために、Azure Site Recovery (= Azure Migrate)  観点では移行元サーバーをシャットダウンした状態でフェールオーバーを実行するか、ネットワークが分離された VNet へテスト フェールオーバーする形で動作確認、およびフェールオーバー訓練を実施する方針をご検討いただく必要がございます。</span>_**

もし、移行元サーバーと移行先サーバーが同じ Active Directory のネットワーク上で同時に稼働することを想定する場合、異なるマシンとしてドメインに登録をするため、以下手順に従って作業を実施頂く必要がございます。

**・ フェールオーバー (= 移行) > ドメイン離脱 (ワーク グループ) > sysprep > ホスト名変更 > ドメイン再参加**

## <a id="6"></a> 6. ホスト名

オンプレミス環境から Azure へフェールオーバー (= 移行) を行う際、移行元サーバーと同じホスト名を維持致します。

公開情報) [ホスト名を表示および変更する | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/virtual-network/virtual-networks-viewing-and-modifying-hostnames)

※ Azure VM 名とホスト名は異なりますので、混同しないようにご留意ください。
なお、Azure VM 名は移行元サーバーと同名すること、異なる名にすること、両方可能でございます。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/c12deb8a-2cef-48d4-8dba-45af0f4348ba)

本記事の内容は以上となります。
