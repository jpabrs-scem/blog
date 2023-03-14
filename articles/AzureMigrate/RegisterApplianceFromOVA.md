---
title: Azure Migrate で PE プロジェクトに ova からデプロイしたアプライアンスを登録する手順
date: 2022-08-11 12:00:00
tags:
  - Azure Migrate
  - how to
disableDisclaimer: false
---

<!-- more -->
こんにちは! ABRS チームの 朴 です。
今回は VMware VM を Azure に移行する (エージェントレス型方式) 際、既にパブリック エンドポイントを利用する Azure Migrate プロジェクトに登録されている
Azure Migrate アプライアンスをプライベート エンドポイント接続を利用する他の Azure Migrate プロジェクトに再登録する方法についてご説明させていただきます。



## 目次
-----------------------------------------------------------
[1. 接続方法ごとの Azure Migrate アプライアンスのデプロイ方法について](#1)
   [  1.1 パブリック エンドポイントを使用する Azure Migrate を使用する時 (V2A エージェントレス型方式) の Azure Migrate アプライアンスのデプロイ方法](#1-1)
   [  1.2 プライベート エンドポイントを使用する Azure Migrate を使用する時 (V2A エージェントレス型方式) の Azure Migrate アプライアンスのデプロイ方法](#1-2) 
[2. OVA ファイルから Azure Migrate アプライアンスをデプロイした後、プライベート エンドポイント接続を利用する他の Azure Migrate プロジェクトに再登録する手順](#2)
-----------------------------------------------------------


## <a id="1"></a> 1. 接続方法ごとの Azure Migrate アプライアンスのデプロイ方法について

### <a id="1-1"></a> 1-1 パブリック エンドポイントを使用する Azure Migrate を使用する時 (V2A エージェントレス型方式) の Azure Migrate アプライアンスのデプロイ方法
 パブリック エンドポイントを使用する Azure Migrate を使用する時 (V2A エージェントレス型方式) : 
 この場合は、Azure Portal から OVA ファイル および ZIP ファイルがダウンロードできます。
    
![](https://user-images.githubusercontent.com/71251920/183872769-21b6ce08-c80e-46b1-836b-229f2b7b4c4b.png)

### <a id="1-2"></a>1-2 プライベート エンドポイントを使用する Azure Migrate を使用する時 (V2A エージェントレス型方式) の Azure Migrate アプライアンスのデプロイ方法
 
 プライベート エンドポイントを使用する Azure Migrate を使用する時 (V2A エージェントレス型方式) : この際は、Azure Portal から Zip ファイルのみがダウンロードできます。

![](https://user-images.githubusercontent.com/71251920/183872774-607827ea-0021-4727-b0bf-3eb4fd74b0ef.png)

Azure Migrate アプライアンスのデプロイ方法については、公開情報をご参照いただければ幸いです。
https://docs.microsoft.com/ja-jp/azure/migrate/migrate-appliance

上記の画面によりますと、ダウンロードするファイル (OVA ファイルと ZIP ファイル) が異なるため、パブリック エンドポイントを使用する Azure Migrate プロジェクトに登録した Azure Migrate アプライアンスは、
プライベート エンドポイントを使用する Azure Migrate プロジェクトに再登録できないのではないかと読み取れますが、実際そうではありません。
[2. の手順](#2) にて Azure Migrate アプライアンスを切り替えて登録する方法を紹介します。
　
## <a id="2"></a> 2. OVA ファイルから Azure Migrate アプライアンスをデプロイした後、プライベート エンドポイント接続を利用する他の Azure Migrate プロジェクトに再登録する手順
> (注: **既に Azure Migrate アプライアンスが存在するサーバーで実施する場合、既存の構成がクリーンアップされますのでご注意ください。**)

### <a id="2-1"></a> 2-1. Azure Migrate Project を 2 つ作成します。
  a. Azure Migrate Project 1 : (プロジェクト名 : PublicEndpoint, V2A エージェントレス、パブリックエンドポイント接続)								
  b. Azure Migrate Project 2 : (プロジェクト名 : PrivateEP, V2A エージェントレス、プライベートエンドポイント接続)								
								
![](https://user-images.githubusercontent.com/71251920/183872777-8eed04ff-cb7a-4b48-9467-8d23de5b0192.png)

![](https://user-images.githubusercontent.com/71251920/183872782-439979cc-d4b9-4a1f-8b3c-f3d00a28927f.png)

### <a id="2-2"></a> 2-2. Azure Migrate Project 1 (PublicEndpoint) から OVA ファイルをダウンロードし、Azure Migrate アプライアンスをデプロイします。								
a. ova ファイルは、Azure Portal もしくは 公開情報からダウンロードいただいても問題ございません。								
・アプライアンス - Vmware  - Azure Migrate アプライアンス
https://docs.microsoft.com/ja-jp/azure/migrate/migrate-appliance#appliance---vmware						

![](https://user-images.githubusercontent.com/71251920/183872732-3d2fc9ec-812f-4d86-a2e5-0587ece25875.png)
![](https://user-images.githubusercontent.com/71251920/183872742-e1eb0069-9776-42e9-9dcb-d884ba943019.png)


### <a id="2-3"></a> 2-3. 検証環境は、ova ファイルからデプロイした Azure Migrate アプライアンスを Azure Migrate Project 1 (PublicEndpoint) に登録している状態を前提としています。			
ova ファイルからデプロイした Azure Migrate アプライアンスを Azure Migrate Project 1 (PublicEndpoint) に登録する手順は、割愛させていただきます。				

### <a id="2-4"></a> 2-4. アプライアンスをホストするサーバー上のフォルダーに インストーラー スクリプトを含んだ ZIP ファイル (AzureMigrateInstaller.zip) を抽出します。
a. インストーラー スクリプトを含んだ ZIP ファイル (AzureMigrateInstaller.zip) 、Azure Portal もしくは公開情報からダウンロードいただいても問題ございません。						
・スクリプトを使用してアプライアンスを設定する
https://docs.microsoft.com/ja-jp/azure/migrate/deploy-appliance-script?msclkid=1eb571a2a5ca11eca56137c5033e85e4


![](https://user-images.githubusercontent.com/71251920/183872748-7feab4d1-4067-48de-9a70-16a336a8fa3d.png)

### <a id="2-5"></a> 2-5. PowerShell スクリプトファイルを実行するため、下記のコマンドを実行します。					
     # Set-Executionpolicy Allsigned


![](https://user-images.githubusercontent.com/71251920/183872749-267f9bc4-15fb-45aa-aca0-03405074d0a9.png)

### <a id="2-6"></a> 2-6. PowerShell ディレクトリを、ダウンロードした ZIP ファイルの内容が抽出されたフォルダーに変更し、下記のコマンドを実行します。		
    # PS C:\Users\administrator\Desktop\AzureMigrateInstaller> .\AzureMigrateInstaller.ps1	



 a. 下記の公開情報の技術の通り、Azure Migrate アプライアンスがすでに設定されているサーバーでスクリプト実行する場合、既存の構成がクリーンアップし、必要な構成の新しいアプライアンスが設定される仕組みとなっています。

![](https://user-images.githubusercontent.com/71251920/183872751-ddc0bf98-e560-4dfc-b745-67a3076a9f12.png)

![](https://user-images.githubusercontent.com/71251920/183872756-d446ea96-38e5-4fec-abbe-ee2acb833e76.png)

### <a id="2-7"></a> 2-7. ova ファイルをデプロイした時と同様に、ApplianceConfigurationManager が自動に起動されます。


![](https://user-images.githubusercontent.com/71251920/183872760-e94e88e6-7f75-4db3-808b-545a0459194f.png)

### <a id="2-8"></a> 2-8. ApplianceConfigurationManager が起動されたら、お客様の環境に合わせて Azure Migrate アプライアンスを Azure Migrate Project 2 (PrivateEndpoint) に登録して頂ければと思います。

a. Azure Migrate アプライアンスは、インターネットに接続する必要がありますので Azure Migrate アプライアンスのサーバーに Proxy が設定されている場合は、
下記の設定を改めてご確認頂ければと思います。

![](https://user-images.githubusercontent.com/71251920/183872762-5fd9e062-2f81-4938-b83c-da04eec2fd72.png)

b. ソース環境からプライベート エンドポイントのプライベート IP アドレスを解決するために、追加の DNS 設定が必要になる場合があります。
プライベート IP アドレスが使用できるよう、Azure Migrate プロジェクトの評価ツールのプロパティーから DNS 設定をダウンロードして頂き、
ダウンロードした DNS 設定をオンプレミスの DNS サーバーもしくはアプライアンスの Hosts ファイルへ設定し、プライベート エンドポイントの FQDN の名前解決できるように設定する必要があります。

![](https://user-images.githubusercontent.com/71251920/183872766-4e725e3d-2d74-4de0-975b-0e3d6a089ce8.png)
	

c. VM Ware から Azure へ移行する際、エージェント レスやエージェント ベースの方式に関係なく、vCenter Server のアクセス許可が必要となります。

d. プライベート エンドポイントを使用した Azure Migrate の設定手順は下記の公開情報をご参照ください。	
・サポート要件と考慮事項 - プライベート エンドポイントで Azure Migrate を使用する 
https://docs.microsoft.com/ja-jp/azure/migrate/how-to-use-azure-migrate-with-private-endpoints
・パブリック エンドポイント接続を使用して Azure Migrate プロジェクトのデータを ExpressRoute 経由でレプリケートする
https://docs.microsoft.com/ja-jp/azure/migrate/replicate-using-expressroute
・ネットワーク接続に関する問題のトラブルシューティング - Azure Migrate
https://docs.microsoft.com/ja-jp/azure/migrate/troubleshoot-network-connectivity#possible-causes-1

### <a id="2-9"></a> 2-9. 下記の画面になると、登録完了を意味します。

![](https://user-images.githubusercontent.com/71251920/183872768-06315655-ce47-432d-b3e7-9aa08fe683bf.png)




本記事の内容は以上となります。
