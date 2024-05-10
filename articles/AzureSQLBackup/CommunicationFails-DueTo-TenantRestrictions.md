---
title: テナント制限により Microsoft Entra ID (旧称 Azure Active Directory) 向けの通信に失敗する
date: 2024-05-08 12:00:00
tags:
  - Azure SQL Backup
  - how to
disableDisclaimer: false
---

<!-- more -->
みなさんこんにちは、Azure Backup サポートです。
 
MARS バックアップや SQL Server バックアップなどのバックアップにおいて、お客様によってはバックアップや復元で使用する通信がプロキシを経由する構成とされていることがあります。 
ご利用のプロキシでテナント制限の構成している場合、Microsoft Entra ID (旧称 Azure Active Directory) への通信ができず、バックアップ対象のサーバーからバックアップサービス利用のための Azure 認証が失敗することで、バックアップの有効化をはじめとした各種操作ができないことがあります。 
 
このブログでは、バックアップ対象のサーバーのプロキシ環境でテナント制限を実施している場合のバックアップの失敗について、テナント制限が原因でバックアップが失敗しているかの判断方法について記載してます。

## 目次 
-----------------------------------------------------------
[1. テナント制限とは](#1)
[2. テナント制限がかかっている場合の判断方法について (Azure Portal でのログインでの確認)](#2)
[3. 回避策について](#3)
-----------------------------------------------------------

## <a id="1"></a> 1.  テナント制限とは
以下のブログに記載がございますが、テナント制限をすることでプロキシを経由した通信について特定の Microsoft Entra ID テナント以外のアクセスが制限されます。

![image](https://github.com/jpabrs-scem/blog/assets/141223502/a3dd80b9-75f4-4ee0-8aed-668c945b264a)

・テナント制限とは | テナント制限について 
https://jpazureid.github.io/blog/azure-active-directory/tenant-restriction/#%E3%83%86%E3%83%8A%E3%83%B3%E3%83%88%E5%88%B6%E9%99%90%E3%81%A8%E3%81%AF


## <a id="2"></a> 2．テナント制限がかかっている場合の判断方法について (Azure Portal でのログインでの確認)
バックアップ対象のサーバーのログから確認することができます。
各ログに「AADSTS500021」の文字列がある場合、テナント制限がかかっていると判断できます。

以下にログファイル名とログが格納されるディレクトリをご案内します。
(ログが格納されているディレクトリは既定の設定の場合を示しています)

#### ＜Azure Backup for SQL in VM の場合＞ 
・ログファイル名 
　WorkloadExtensionHandlerXX.log 
・ディレクトリ 
　WindowsAzure\Logs\Plugins\Microsoft.Azure.RecoveryServices.WorkloadBackup.AzureBackupWindowsWorkload\バージョン\WorkloadExtnLogFolder 
・エラー出力例 
>---> (内部例外 #0) Microsoft.IdentityModel.Clients.ActiveDirectory.AdalServiceException:
　AADSTS500021: Access to 'IDMAADTenantjpepod01' tenant is denied.

#### ＜Microsoft Azure Recovery Services (MARS) の場合＞
・ログファイル名 
　CBEngine XX.errlog 
・ディレクトリ 
　C:\Program Files\Microsoft Azure Recovery Services Agent\Temp 
・ディレクトリ(MABS) 
　C:\Program Files\Microsoft Azure Backup Server\DPM\MARS\Microsoft Azure Recovery Services Agent\Temp\ 
・エラー出力例 
>02C4 02D8 08/19 04:36:31.844 79 CallerFileName(0) 816A55BE-5C1F-45C0-A77E-C991A8958DD9 WARNING Exception in GetAADToken | Params: {Data = }{Message = AADSTS500021: Access to 'IDMAADTenantjpepod01' tenant is denied.

## <a id="3"></a> 3．回避策について
ご利用のプロキシ環境でテナント制限しており「AADSTS500021」のメッセージを確認しましたらテナント制限によりバックアップが失敗している可能性が高いです。
該当する場合、ご利用のプロキシで以下のテナントへのアクセスを許可していただきますようお願いいたします。

Azure Backup では、O365 の以下のテナントに接続が必要です。
以下は、バックアップ利用の際に使用されるテナントになります。
 
IDMServiceAADTenant<リージョン>pod01.onmicrosoft.com
 
お客様の環境のリージョンに合わせて、以下テナントのアクセスを許可をしてください。
※現時点でテナント名やテナント ID の公開情報はないため、以下のリージョン以外のテナント名やテナント ID の確認がご希望の場合、Azure Backup の窓口へお問い合わせをお願いいたします。
 
#### ＜東日本リージョンの Azure Backup のテナント情報＞
テナント名 : IDMServiceAADTenantjpepod01.onmicrosoft.com
テナント ID : 6e92595a-0b9c-49e4-a1e9-884d0ab4f4f0
 
#### ＜西日本リージョンの Azure Backup のテナント情報＞
テナント名 : IDMAADTenantjpwpod01.onmicrosoft.com
テナント ID : 4617fbbe-e76e-4071-90cd-6f5e7f5d5244

>備考：
テナント制限の操作に関してご確認したい場合、Entra ID のお問合せをお願いいたします。
専門のエンジニアが対応することで円滑で正確な対応が可能となります。
