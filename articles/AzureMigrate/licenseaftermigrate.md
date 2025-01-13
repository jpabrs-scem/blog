---
title: Azure Migrate を利用した移行後の VM のライセンスについて
date: 2024-02-20 12:00:00
tags:
  - Azure Migrate
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Migrate サポートです。

今回は Azure Migrate を利用してオンプレミス環境のサーバーを Azure へ移行後、移行された Azure VM のライセンスについててご説明させていただきます。


## 目次
[1. Azure VM のライセンスについて](#1)

[2. 従量課金制 (PAYG) について](#2)

[3. サブスクリプション持ち込み (BYOS) ついて](#3)

[4. 移行対象サーバーの OS ごとのライセンスについて](#4)

[5. Azure Migrate のライセンスサポートについて](#5)

[6. ライセンス毎の弊社のサポートについて](#6)

-----------------------------------------------------------

## <a id="1"></a> 1. Azure VM のライセンスについて

Azure には、"従量課金制" (PAYG) と "サブスクリプション持ち込み" (Bring-Your-Own-Subscription 以下、BYOS) の 2 つの主なライセンス価格オプションがあります。

以下は、従量課金制 (PAYG) とサブスクリプション持ち込み (BYOS) を図で表したものでございます。

詳細は、後述致しますが、弊社の公開情報でも同内容を説明しておりますので、ご参照ください。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/645ecafb-258d-4129-b5e1-c307b020bb07)
※ AHB = Azure ハイブリッド特典 (= Azure Hybrid Benefit) を意味致します。


公開情報) [Windows VMs 向け Azure ハイブリッド特典の検索について](https://learn.microsoft.com/ja-jp/azure/virtual-machines/windows/hybrid-use-benefit-licensing)

公開情報) [Red Hat Enterprise Linux (RHEL) および SUSE Linux Enterprise Server (SLES) 仮想マシンの Azure ハイブリッド特典](https://learn.microsoft.com/ja-jp/azure/virtual-machines/linux/azure-hybrid-benefit-linux?tabs=ahbNewPortal%2CahbExistingPortal%2Clicenseazcli%2CrhelAzcliByosConv%2Crhelazclipaygconv%2Crhelpaygconversion%2Crhelcompliance#frequently-asked-questions)


## <a id="2"></a> 2. 従量課金制 (PAYG) について

Azure には、"従量課金制" (PAYG) という価格オプションがあります。 

"PAYG" は、使用するリソースに対して時間単位または月単位で支払う価格オプションです。 
使用した分だけ料金を支払い、必要に応じてスケールアップまたはダウンできます。


## <a id="3"></a> 3. サブスクリプション持ち込み (BYOS) ついて
"BYOS" は、Azure 仮想マシン上の特定のソフトウェア (Windows、RHEL と SLES) に対して既存のライセンスを使用できるライセンス オプションです。 
既存のライセンスを使用でき、Azure で使用するために新しく購入する必要はありません。

つまり、オンプレミスサーバー (OS : Windows) を Azure を用いて移行する場合、Azure ハイブリッド特典を利用頂くことにより、Azure に移行およびフェールオーバーされた VM の OS のライセンス料金は、 Azure 料金に含まれないようになります。

Azure Migrate の場合、Azure Portal > [レプリケート] > ターゲット設定にて Azure ハイブリッド特典を利用することができます。

![Image](https://github.com/jpabrs-scem/blog/assets/141316175/4e94d164-8d43-4487-8947-d9d157544010)


公開情報) [マシンを物理サーバーとして Azure に移行する](https://learn.microsoft.com/ja-jp/azure/migrate/tutorial-migrate-physical-virtual-machines)


## <a id="4"></a> 4. 移行対象サーバーの OS ごとのライセンスについて
**■ オンプレミスサーバーの OS が Windows の場合 :** 

従量課金制 (PAYG) ・ サブスクリプション持ち込み (BYOS) を両方利用することが可能でございます。

**■ オンプレミスサーバーの OS が Linux の場合 :**

<span style="color: red; ">**例えば、SUSE Linux VM の場合、Azure に移行およびフェールオーバーされた VM の OS は BYOS とみなされ、OS のライセンス料金は Azure 料金に含まれず、Azure インフラストラクチャのコストに対してのみ課金がされるようになります。 </span>**


Q: オンプレミス (Azure Migrate、Azure Site Recovery、またはそれ以外の方法で) から Azure に独自の RHEL または SLES イメージをアップロードしました。 Azure ハイブリッド特典の特典を得るために何かを行う必要がありますか。

 
<span style="color: red; ">**A:いいえ、必要ありません。 アップロードした RHEL または SLES イメージは既に BYOS と見なされており、Azure インフラストラクチャのコストに対してのみ課金されます。 オンプレミス環境の場合と同じように、RHEL サブスクリプションのコストについて責任を負います。**</span>

Q: オンプレミス (Azure Migrate、Azure Site Recovery、またはそれ以外の方法で) から Azure に独自の RHEL または SLES イメージをアップロードしました。 これらのイメージの課金を BYOS から従量課金制 (=PAYG) に変換することはできますか?

<span style="color: red; ">**A: はい。BYOS 仮想マシンの Azure ハイブリッド特典を使用することで変換が可能です。 
この詳細については、こちらを参照してください。**</span>


公開情報) [よく寄せられる質問](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/azure-hybrid-benefit-linux#frequently-asked-questions)

## <a id="5"></a> 5. Azure Migrate でのライセンス サポートについて
Azure 技術サポートからライセンスに関する案内をこれ以上差し上げることは叶いません。

もし、各 OS 観点からのサポートが必要な場合、以下 <6. ライセンスに毎の弊社のサポートについて> をご覧の上、弊社の Azure IaaS 担当チームに新しく起票頂ければ幸いです。


## <a id="6"></a> 6. ライセンス毎の弊社のサポートについて

**■ 移行およびフェードオーバーされた Azure VM のライセンスが BYOS 場合のサポートについて**

<span style="color: red; ">**Azure VM のライセンスが BYOS であり、OS が Linux の場合、OS に関する調査は Azure VM の OS を提供している企業に依頼する必要があります。**</span>

<span style="color: red; ">**そのため、弊社では OS 側の観点からの調査が困難です。</span>**

**■ 移行およびフェードオーバーされた Azure VM のライセンスが PAYG 場合のサポートについて**

ご利用のライセンスが PAYG の場合、弊社としてトラブルシューティングとして調査が可能となっております。


本記事の内容は以上となります。
